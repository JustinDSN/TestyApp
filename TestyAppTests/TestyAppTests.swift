import XCTest
@testable import TestyApp

func constructTestingViews(viewControllerDelegate: ViewControllerDelegate, makeWindowKeyAndVisible: Bool) -> (UIStoryboard, AppDelegate, ViewController) {
  let storyboard = UIStoryboard(name: "Main", bundle: nil)

  let rootViewController = storyboard.instantiateInitialViewController() as! ViewController
  rootViewController.delegate = viewControllerDelegate

  let appDelegate = AppDelegate()

  let window = UIWindow()
  window.rootViewController = rootViewController
  appDelegate.window = window

  if (makeWindowKeyAndVisible) {
    window.makeKeyAndVisible()
  }

  return (storyboard, appDelegate, rootViewController)
}

class TestyAppTests: XCTestCase, ViewControllerDelegate {
  var storyboard: UIStoryboard! = nil
  var appDelegate: AppDelegate! = nil
  var rootViewController: ViewController! = nil
  var viewDidLoadExpectation: XCTestExpectation? = nil
  var viewWillAppearExpectation: XCTestExpectation? = nil
  var viewDidAppearExpectation: XCTestExpectation? = nil
  var viewWillDisappearExpectation: XCTestExpectation? = nil
  var viewDidDisappearExpectation: XCTestExpectation? = nil

  func createSystemUnderTest(makeWindowKeyAndVisible: Bool) {
    let tuple = constructTestingViews(viewControllerDelegate:  self, makeWindowKeyAndVisible: makeWindowKeyAndVisible)
    storyboard = tuple.0
    appDelegate = tuple.1
    rootViewController = tuple.2
  }

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    storyboard = nil
    appDelegate = nil
    rootViewController = nil
    super.tearDown()
  }

  func testViewControllerLifecycle() {
    viewDidLoadExpectation = expectation(description: "Wait for viewDidLoad")
    viewWillAppearExpectation = expectation(description: "Wait for viewWillAppear")
    viewDidAppearExpectation = expectation(description: "Wait for viewDidAppear")
    viewWillDisappearExpectation = expectation(description: "Wait for viewWillDisappear")
    viewDidDisappearExpectation = expectation(description: "Wait for viewDidDisappear")

    let expectations = [
      viewDidLoadExpectation!,
      viewWillAppearExpectation!,
      viewDidAppearExpectation!,
      viewWillDisappearExpectation!,
      viewDidDisappearExpectation!
    ]

    createSystemUnderTest(makeWindowKeyAndVisible: true)

    wait(for: expectations, timeout: 1, enforceOrder: true)
  }

  func viewControllerViewDidLoad(viewController: ViewController) {
    viewDidLoadExpectation?.fulfill()
    viewDidLoadExpectation = nil
  }

  func viewControllerViewWillAppear(viewController: ViewController, animated: Bool) {
    viewWillAppearExpectation?.fulfill()
    viewWillAppearExpectation = nil
  }

  func viewControllerViewDidAppear(viewController: ViewController, animated: Bool) {
    viewDidAppearExpectation?.fulfill()
    viewDidAppearExpectation = nil

    //Present a different view controller to trigger the viewWillDisappear and
    //viewDidDisappear lifecylce methods
    rootViewController.present(UIViewController(), animated: true, completion: nil)
  }

  func viewControllerViewWillDisappear(viewController: ViewController, animated: Bool) {
    viewWillDisappearExpectation?.fulfill()
    viewWillDisappearExpectation = nil
  }

  func viewControllerViewDidDisappear(viewController: ViewController, animated: Bool) {
    viewDidDisappearExpectation?.fulfill()
    viewDidDisappearExpectation = nil
  }
}
