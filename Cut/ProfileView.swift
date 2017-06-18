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
    let segmentedControl = UISegmentedControl(items: ["Watch List", "Ratings"])
    
    let watchListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: FilmPosterLayout())
    let ratedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: FilmPosterLayout())
    
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        segmentedControl.selectedSegmentIndex = 0
        
        _ = segmentedControl
            .rx
            .controlEvent(.valueChanged)
            .map() { _ in self.segmentedControl.selectedSegmentIndex == 0 }
            .subscribe(onNext: { showWatchList in
                self.watchListCollectionView.isHidden = !showWatchList
        })
        
        let detailsContainer = UIView()
        let detailsCenteringContainer = UIView()
        
        addSubview(detailsContainer)
        detailsContainer.addSubview(detailsCenteringContainer)
        detailsContainer.addSubview(segmentedControl)
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
        
        segmentedControl <- [
            Bottom(10),
            CenterX()
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
