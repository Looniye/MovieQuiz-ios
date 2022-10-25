import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate{
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService = StatisticServiceImplementation()
    private var alertPresent: AlertPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSHomeDirectory())
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresent = AlertPresenter(delegate: self)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else{
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async {
            [weak self] in self?.show(quiz: viewModel)
        }
    }
    
    @IBAction private func  yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        toggleDisableButtons()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        toggleDisableButtons()
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswer, total: questionsAmount)
            let result = "Ваш результат: \(correctAnswer) из \(questionsAmount)"
            let gamesCount = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            let record = "Рекорд: \(statisticService.bestGame.correct)/\(questionsAmount) (\(statisticService.bestGame.date.dateTimeString))"
            let totalAccuracy = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy * 100))%"
            let mockedAlertModel: AlertModel = {
                AlertModel(
                    title: "Этот раунд окончен!",
                    message: "\(result) \n \(gamesCount) \n \(record) \n \(totalAccuracy)",
                    buttonText: "Сыграть ещё раз",
                    completion: {
                        self.currentQuestionIndex = 0
                        self.correctAnswer = 0
                        return self.questionFactory?.requestNextQuestion()
                    }
                )
            }()
            alertPresent?.showAlert(quiz: mockedAlertModel)
            
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswer += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResult()
            self.imageView.layer.borderWidth = 0
            self.toggleEnableButtons()
        }
    }
    
    private func toggleDisableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    private func toggleEnableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func show(quiz step: QuizStepViewModel) {
        self.imageView.image = step.image
        self.textLabel.text = step.question
        self.counterLabel.text = step.questNumber
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}
