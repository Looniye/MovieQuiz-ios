import Foundation
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(quiz model: AlertModel)
}
