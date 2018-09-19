import UIKit

protocol ViewControllerDelegate: AnyObject {
  func viewControllerViewDidLoad(viewController: ViewController)
  func viewControllerViewWillAppear(viewController: ViewController, animated: Bool)
  func viewControllerViewDidAppear(viewController: ViewController, animated: Bool)
  func viewControllerViewWillDisappear(viewController: ViewController, animated: Bool)
  func viewControllerViewDidDisappear(viewController: ViewController, animated: Bool)
}

class ViewController: UIViewController {

  weak var delegate: ViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()

    delegate?.viewControllerViewDidLoad(viewController: self)

//    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) { [weak self] in
//      guard let strongSelf = self else { return }
//
//      strongSelf.delegate?.viewControllerViewDidLoad(viewController: strongSelf)
//    }

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    delegate?.viewControllerViewWillAppear(viewController: self, animated: animated)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    delegate?.viewControllerViewDidAppear(viewController: self, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    delegate?.viewControllerViewWillDisappear(viewController: self, animated: animated)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    delegate?.viewControllerViewDidDisappear(viewController: self, animated: animated)
  }

}

