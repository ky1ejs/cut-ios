//
//  CurrentUserView.swift
//  Cut
//
//  Created by Kyle McAlpine on 10/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

class CurrentUserView: UIView {
    let emailLabel = UILabel()
    let usernameLabel = UILabel()
    let segmentedControl = UISegmentedControl(items: ["Watch List", "Ratings"])
    let qrCodeButton = UIButton(type: .custom)
    
    let watchListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: FilmPosterLayout())
    let ratedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: FilmPosterLayout())
    
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        segmentedControl.selectedSegmentIndex = 0
        
        qrCodeButton.setTitle("QR", for: .normal)
        qrCodeButton.setTitleColor(.blue, for: .normal)
        
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
        detailsCenteringContainer.addSubview(qrCodeButton)
        detailsCenteringContainer.addSubview(emailLabel)
        detailsCenteringContainer.addSubview(usernameLabel)
        addSubview(ratedCollectionView)
        addSubview(watchListCollectionView)
        
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
        
        qrCodeButton <- [
            Top().to(emailLabel, .top),
            Trailing(20)
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
