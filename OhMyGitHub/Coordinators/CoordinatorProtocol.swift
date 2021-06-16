import UIKit

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get set }
    var viewControllersFactory: ViewControllersFactory { get set }
    func start()
}
