//
//  FilmDetailVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 18/05/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

class FilmDetailVC: UIViewController {
    let film: Film
    
    init(film: Film) {
        self.film = film
        super.init(nibName: nil, bundle: nil)
        title = film.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = FilmDetailView(film: film)
    }
}
