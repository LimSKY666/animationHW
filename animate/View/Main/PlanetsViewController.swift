//
//  PlanetViewController.swift
//  animate
//
//  Created by Семён Соколов on 10.04.2022.
//

import UIKit

class PlanetsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "PlanetViewCell", bundle: nil), forCellWithReuseIdentifier: "PlanetCell")
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Variables
    let viewModel = PlanetViewModel()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        viewModel.delegate = self
        viewModel.generatePlanets()
    }
}

// MARK: - UICollectionViewDataSource
extension PlanetsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.planets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanetCell", for: indexPath) as! PlanetViewCell
        if let image = UIImage(named: viewModel.planets[indexPath.row].image) {
            cell.configure(image: image, color: UIColor(ciColor: .red))
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PlanetsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        viewModel.indexPath = indexPath
        let planet = viewModel.planets[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "PlanetsDetailsViewConroller") as! PlanetsDetailsViewConroller
        detailVC.planet = planet

        navigationController?.modalPresentationStyle = .custom
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PlanetsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width)
    }
}

// MARK: - ScrollViewDidScroll
extension PlanetsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / view.frame.width
        pageControl.currentPage = Int(scrollPos)
    }
}

extension PlanetsViewController: PlanetViewModelDelegate {
    func planetsDidLoad() {
        collectionView.reloadData()

        pageControl.numberOfPages = viewModel.planets.count
        pageControl.currentPage = 0
    }
}

// MARK: - UINavigationControllerDelegate
extension PlanetsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return AnimationManager(animationDuration: 1.3, animationType: .present)
        case .pop:
            return AnimationManager(animationDuration: 1.3, animationType: .dismiss)
        default:
            return nil
        }
    }
}

// MARK: - PizzaTransitionable
extension PlanetsViewController: PlanetTransitionable {
    
    var backgroundView: UIView {
        guard
            let indexPath = viewModel.indexPath,
            let planetCell = collectionView.cellForItem(at: indexPath) as? PlanetViewCell
        else {
            return UIView()
        }
        return planetCell.view
    }

    var planetImage: UIImageView {
        guard
            let indexPath = viewModel.indexPath,
            let planetCell = collectionView.cellForItem(at: indexPath) as? PlanetViewCell
        else {
            return UIImageView()
        }
        return planetCell.imageView
    }
}

