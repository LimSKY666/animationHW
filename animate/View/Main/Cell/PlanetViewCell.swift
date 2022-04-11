//
//  PlanetViewCell.swift
//  animate
//
//  Created by Семён Соколов on 10.04.2022.
//

import UIKit

protocol ConfigureCell {
    func configure(image: UIImage, color: UIColor)
}

class PlanetViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView! {
        didSet {
            view.backgroundColor = .red
            view.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = imageView.bounds.width / 2
            imageView.contentMode = .scaleAspectFit
        }
    }
}

extension PlanetViewCell: ConfigureCell {
    func configure(image: UIImage, color: UIColor) {
        imageView.image = image
        view.backgroundColor = color.withAlphaComponent(0.3)
    }
}
