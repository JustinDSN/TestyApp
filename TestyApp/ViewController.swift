import UIKit

protocol ViewControllerDelegate: AnyObject {
  func viewControllerViewDidLoad(viewController: ViewController)
  func viewControllerViewWillAppear(viewController: ViewController, animated: Bool)
  func viewControllerViewDidAppear(viewController: ViewController, animated: Bool)
  func viewControllerViewWillDisappear(viewController: ViewController, animated: Bool)
  func viewControllerViewDidDisappear(viewController: ViewController, animated: Bool)
}

class BaseViewControllerState {
  var name: String {
    fatalError("Subclass must implement")
  }

  init() {
    print("Init of \(name)")
  }

  deinit {
    print("Deinit of \(name)")
  }

  func activate(sayHelloAfter: DispatchTimeInterval) {
    print("Activating \(name)...")

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + sayHelloAfter) { [unowned self] in
        self.sayHello()
    }
  }

  func sayHello() {
    print("Hello from \(name)")
  }
}

class ViewControllerStateA: BaseViewControllerState {
  override var name: String {
    return "ViewControllerStateA"
  }
}

class ViewControllerStateB: BaseViewControllerState {
  override var name: String {
    return "ViewControllerStateB"
  }
}

class ViewController: UIViewController {

  weak var delegate: ViewControllerDelegate?
  var currentState: BaseViewControllerState = ViewControllerStateA() {
    didSet {
      currentState.activate(sayHelloAfter: .seconds(1))
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    currentState.activate(sayHelloAfter: .seconds(4))

    delegate?.viewControllerViewDidLoad(viewController: self)
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

