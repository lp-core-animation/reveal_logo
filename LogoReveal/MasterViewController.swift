import UIKit
import QuartzCore

func delay(seconds: Double, completion: @escaping ()-> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class MasterViewController: UIViewController {
  
  let logo = RWLogoLayer.logoLayer()
  let transition = RevealAnimator()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Start"
    navigationController?.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // add the tap gesture recognizer
    let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    view.addGestureRecognizer(pan)
    
    // add the logo to the view
    logo.position = CGPoint(x: view.layer.bounds.size.width/2,
      y: view.layer.bounds.size.height/2 - 30)
    logo.fillColor = UIColor.white.cgColor
    view.layer.addSublayer(logo)
  }
  
  //
  // MARK: Gesture recognizer handler
  //

  @objc func didPan(_ recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .began:
      transition.interactive = true
      performSegue(withIdentifier: "details", sender: nil)
    default:
      transition.handlePan(recognizer)
    }
  }

  @objc func didTap() {
    performSegue(withIdentifier: "details", sender: nil)
  }
}

extension MasterViewController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController,
                            animationControllerFor operation: UINavigationController.Operation,
                            from fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.operation = operation
    return transition
  }

  func navigationController(_ navigationController: UINavigationController,
                            interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
    if !transition.interactive {
        return nil
      }
    return transition
  }
}

