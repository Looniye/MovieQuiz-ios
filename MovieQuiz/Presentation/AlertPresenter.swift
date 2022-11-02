import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol{
    
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    func showAlert(quiz model: AlertModel) {
        let alert = UIAlertController.init(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: { _ in
                model.completion()
            }
        ))
        delegate?.present(alert, animated: true)
    }
}
