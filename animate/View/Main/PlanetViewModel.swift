//
//  PlanetViewModel.swift
//  animate
//
//  Created by Семён Соколов on 10.04.2022.
//

import Foundation

protocol PlanetViewModelDelegate: AnyObject {
    func planetsDidLoad()
}

final class PlanetViewModel {
    
    weak var delegate: PlanetViewModelDelegate?
    
    var planets: [Planet] = []
    var indexPath: IndexPath?
    
    func generatePlanets() {
        planets.append(Planet(image: "0"))
        planets.append(Planet(image: "1"))
        planets.append(Planet(image: "2"))
        planets.append(Planet(image: "3"))
        planets.append(Planet(image: "4"))
        planets.append(Planet(image: "5"))
        delegate?.planetsDidLoad()
    }
}
