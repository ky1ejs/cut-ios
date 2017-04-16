//
//  ProfileView.swift
//  Cut
//
//  Created by Kyle McAlpine on 10/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

class ProfileView: UIView {
    let emailLabel = UILabel()
    let usernameLabel = UILabel()
    
    let watchListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: FilmPosterLayout())
    let ratedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: FilmPosterLayout())
    
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        let detailsContainer = UIView()
        let detailsCenteringContainer = UIView()
        
        addSubview(detailsContainer)
        detailsContainer.addSubview(detailsCenteringContainer)
        addSubview(ratedCollectionView)
        addSubview(watchListCollectionView)
        
        detailsCenteringContainer.addSubview(emailLabel)
        detailsCenteringContainer.addSubview(usernameLabel)
        
        detailsContainer <- [
            Leading(),
            Top(),
            CenterX(),
            Height(*0.3).like(self)
        ]
        
        detailsCenteringContainer <- [
            Leading(20),
            CenterX(),
            CenterY()
        ]
        
        emailLabel <- [
            Leading(30),
            Top(),
            CenterX()
        ]
        
        usernameLabel <- [
            Leading().to(emailLabel, .leading),
            Top(10).to(emailLabel),
            Bottom()
        ]
        
        watchListCollectionView <- [
            Top().to(detailsContainer),
            Leading(),
            CenterX(),
            Bottom()
        ]
        
        ratedCollectionView <- [
            Top().to(detailsContainer),
            Leading(),
            CenterX(),
            Bottom()
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
