//
//  PlanetDetailsViewController.swift
//  animate
//
//  Created by Семён Соколов on 10.04.2022.
//

import UIKit

class PlanetsDetailsViewConroller: UIViewController {

    @IBOutlet weak var detailBackgroundView: UIView!
    @IBOutlet weak var detailPlanetImage: UIImageView! {
        didSet {
            detailPlanetImage.layer.cornerRadius = detailPlanetImage.bounds.width / 2
            detailPlanetImage.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            closeButton.layer.cornerRadius = closeButton.bounds.width / 2
        }
    }

    // MARK: - Variables
    var planet: Planet?

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.view.addGestureRecognizer(tapGesture)

        guard let planet = planet else { return }
        let image = planet.image
        detailPlanetImage.image = UIImage(named: image)
    }
}

extension PlanetsDetailsViewConroller {
    @objc func viewDidTap() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - PlanetsTransitionable
extension PlanetsDetailsViewConroller: PlanetTransitionable {
    var planetImage: UIImageView {
        return detailPlanetImage
    }
    
    var backgroundView: UIView {
        return detailBackgroundView
    }
}
