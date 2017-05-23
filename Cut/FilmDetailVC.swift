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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        let filmView = FilmDetailView(film: film)
        view.addSubview(filmView)
        filmView <- [
            Leading(),
            CenterX(),
            Top().to(self.topLayoutGuide),
            Bottom().to(self.bottomLayoutGuide)
        ]
        
    }
}
