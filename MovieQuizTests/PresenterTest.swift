import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    func show(quiz result: MovieQuiz.QuizResultsViewModel) {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    
    func toggleDisableButtons() {
        
    }
    
    func toggleEnableButtons() {
        
    }
    
    
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let vc = MovieQuizViewControllerProtocolMock()
        let sut = MovieQuizPresenter(viewController: vc)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questNumber, "1/10")
    }
}
