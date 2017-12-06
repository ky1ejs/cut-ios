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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = RatingPopUpView(rating: film.status.value?.ratingScore)
    }
}
