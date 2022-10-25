import Foundation

protocol AlertPresenterDelegate: AnyObject {
    func didShowAlert(quiz model: AlertModel?)
}
