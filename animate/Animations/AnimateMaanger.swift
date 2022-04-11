//
//  AnimateMaanger.swift
//  animate
//
//  Created by Семён Соколов on 10.04.2022.
//

import UIKit

enum AnimationType {
    case present
    case dismiss
}

final class AnimationManager: NSObject {

    // MARK: - Variables
    private let animationDuration: Double
    private let animationType: AnimationType

    // MARK: - Init
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension AnimationManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
        else {
            transitionContext.completeTransition(false)
            return
        }
        switch animationType {
        case .present:
            presentAnimation(
                transitionContext: transitionContext,
                fromView: fromViewController,
                toView: toViewController
            )
        case .dismiss:
            dismissAnimation(
                transitionContext: transitionContext,
                fromView: fromViewController,
                toView: toViewController
            )
        }
    }
}

// MARK: - Preenting animation
private extension AnimationManager {
    func presentAnimation(transitionContext: UIViewControllerContextTransitioning, fromView: UIViewController, toView: UIViewController) {

        let containerView = transitionContext.containerView

        let firstPartDuration = (animationDuration / 3)
        let secondPartDuration = (animationDuration / 3) * 2
        guard let fromPlanetVC = fromView as? PlanetsViewController else { return }
        guard let toPlanetDetailVC = toView as? PlanetsDetailsViewConroller else { return }
        let backgroundView = UIView()
        let planetSnapshot = UIImageView()

        let backgroundFrame = containerView.convert(
            fromPlanetVC.backgroundView.frame,
            from: fromPlanetVC.backgroundView.superview
        )

        let planetSnapshotFrame = containerView.convert(
            fromPlanetVC.planetImage.frame,
            from: fromPlanetVC.planetImage.superview
        )

        backgroundView.frame = backgroundFrame
        backgroundView.backgroundColor = fromPlanetVC.backgroundView.backgroundColor
        backgroundView.layer.cornerRadius = fromPlanetVC.backgroundView.layer.cornerRadius

        planetSnapshot.frame = planetSnapshotFrame
        planetSnapshot.image = fromPlanetVC.planetImage.image
        planetSnapshot.contentMode = .scaleAspectFit

        containerView.addSubview(fromPlanetVC.view)
        containerView.addSubview(toPlanetDetailVC.view)
        containerView.addSubview(backgroundView)
        containerView.addSubview(planetSnapshot)

        fromPlanetVC.view.isHidden = false
        fromPlanetVC.collectionView.isHidden = true
        toPlanetDetailVC.view.isHidden = true

        let frameAnim = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        let animator1 = {
            UIViewPropertyAnimator(duration: firstPartDuration, dampingRatio: 1) {
                backgroundView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }()

        let animator2 = {
            UIViewPropertyAnimator(duration: secondPartDuration, curve: .easeInOut) {
                backgroundView.frame = frameAnim
                planetSnapshot.transform = CGAffineTransform(rotationAngle: .pi)
                planetSnapshot.frame = containerView.convert(
                    toPlanetDetailVC.planetImage.frame,
                    from: toPlanetDetailVC.planetImage.superview
                )
            }
        }()

        animator1.addCompletion { _ in
            animator2.startAnimation()
        }

        animator2.addCompletion { _ in
            fromPlanetVC.collectionView.isHidden = false
            toPlanetDetailVC.view.isHidden = false

            backgroundView.removeFromSuperview()
            planetSnapshot.removeFromSuperview()

            transitionContext.completeTransition(true)
        }

        animator1.startAnimation()
    }
}

// MARK: - Dismissing animation
private extension AnimationManager {
    func dismissAnimation(transitionContext: UIViewControllerContextTransitioning, fromView: UIViewController, toView: UIViewController) {

        let containerView = transitionContext.containerView
        containerView.addSubview(toView.view)
        containerView.addSubview(fromView.view)
        transitionContext.completeTransition(true)
    }
}
