//
//  RatingPopUpVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 29/11/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

class RatingPopUpVC: UIViewController {
    let film: Film
    
    init(film: Film) {
        self.film = film
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let popUpView = RatingPopUpView(rating: film.status.value?.ratingScore)
        _ = popUpView.rateButton.rx
            .tap
            .asObservable()
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { _ in
                let rating = popUpView.ratingView.rating?.rawValue ?? 0
                _ = RateFilm(film: self.film, rating: rating).call().subscribe({ event in
                    self.dismiss(animated: true, completion: nil)
                })
            })
        view = popUpView
    }
}

extension RatingPopUpVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AlertPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossFadeTransition(direction: .`in`)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossFadeTransition(direction: .out)
    }
}
