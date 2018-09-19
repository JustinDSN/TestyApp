import UIKit

protocol ViewControllerDelegate: AnyObject {
  func viewControllerViewDidLoad(viewController: ViewController)
  func viewControllerViewWillAppear(viewController: ViewController, animated: Bool)
  func viewControllerViewDidAppear(viewController: ViewController, animated: Bool)
  func viewControllerViewWillDisappear(viewController: ViewController, animated: Bool)
  func viewControllerViewDidDisappear(viewController: ViewController, animated: Bool)
}

class BaseViewControllerState: NSObject {
  var name: String {
    fatalError("Subclass must implement")
  }

  var pendingWorkItem: DispatchWorkItem?

  override init() {
    super.init()
    print("DEBUG: \(#function) \(self.asPointer) \(self.asPointer.asEmoji)")
    print("Init of \(name)")
  }

  deinit {
    print("Deinit of \(name)")
    pendingWorkItem?.cancel()
  }

  func activate(sayHelloAfter: DispatchTimeInterval) {
    print("Activating \(name)...")
    pendingWorkItem?.cancel()

    let workItem = DispatchWorkItem { [unowned self] in
      self.sayHello()
    }

    pendingWorkItem = workItem
    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + sayHelloAfter, execute: workItem)
  }

  func sayHello() {
    print("DEBUG: \(#function) \(self.asPointer) \(self.asPointer.asEmoji)")
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

extension NSObject {
  public var asPointer: UnsafeMutableRawPointer {
    return Unmanaged.passUnretained(self).toOpaque()
  }
}

extension UnsafeMutableRawPointer {
  public var asEmoji: String {
    // Adapted from https://gist.github.com/iandundas/59303ab6fd443b5eec39
    // Tweak the range to your liking.
    //let range = 0x1F600...0x1F64F
    let range = 0x1F300...0x1F3F0
    let index = (self.hashValue % range.count)
    let ord = range.lowerBound + index
    guard let scalar = UnicodeScalar(ord) else {
      return "❓"
    }
    return String(scalar)
  }
}
