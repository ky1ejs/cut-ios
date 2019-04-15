//
//  UserView.swift
//  Cut
//
//  Created by Kyle McAlpine on 21/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy
import Kingfisher
import RxSwift

class UserView: UIView {
    let profileImageView = UIImageView()
    let usernameLabel = UILabel()
    let followerCountButton = UIButton()
    let followingCountButton = UIButton()
    let followButton = UIButton()
    let segmentedControl = UISegmentedControl(items: ["watch_list", "rated_list"])
    let watchListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: FilmPosterLayout())
    let ratedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: FilmPosterLayout())
    
    let repo: UserRepository
    
    init(user: User) {
        repo = UserRepository(user: user)
        
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        profileImageView.kf.indicatorType = .activity
        
        followerCountButton.setTitleColor(.blue, for: .normal)
        followerCountButton.titleLabel?.numberOfLines = 0
        followerCountButton.titleLabel?.textAlignment = .center
        
        followingCountButton.setTitleColor(.blue, for: .normal)
        followingCountButton.titleLabel?.numberOfLines = 0
        followingCountButton.titleLabel?.textAlignment = .center
        
        followButton.setTitleColor(.white, for: .normal)
        followButton.backgroundColor = .blue
        followButton.layer.cornerRadius = 5
        
        segmentedControl.selectedSegmentIndex = 0
        _ = segmentedControl
            .rx
            .controlEvent(.valueChanged)
            .map() { _ in self.segmentedControl.selectedSegmentIndex == 0 }
            .subscribe(onNext: { showWatchList in
                self.watchListCollectionView.isHidden = !showWatchList
            })
        
        watchListCollectionView.backgroundColor = .white
        ratedCollectionView.backgroundColor = .white
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(followerCountButton)
        addSubview(followingCountButton)
        addSubview(followButton)
        addSubview(segmentedControl)
        addSubview(ratedCollectionView)
        addSubview(watchListCollectionView)
        
        profileImageView <- [
            Top(20).to(safeAreaLayoutGuide, .top),
            Leading(20),
            Width(115),
            Height().like(profileImageView, .width)
        ]
        
        usernameLabel <- [
            Top(20).to(profileImageView),
            Leading(20),
            Trailing(20)
        ]
        
        followerCountButton <- [
            Leading(20).to(profileImageView),
            Top().to(profileImageView, .top),
            Height(50),
            Width(80)
        ]
        
        followingCountButton <- [
            Leading(20).to(followerCountButton),
            Top().to(followerCountButton, .top),
            Height().like(followerCountButton),
            Width().like(followerCountButton)
        ]
        
        followButton <- [
            Bottom(20).to(profileImageView, .bottom),
            Leading().to(followerCountButton, .leading),
            Trailing().to(followingCountButton, .trailing),
            Height(40)
        ]
        
        segmentedControl <- [
            Top(20).to(usernameLabel),
            CenterX()
        ]
        
        watchListCollectionView <- [
            Top(20).to(segmentedControl),
            Leading(),
            Trailing(),
            Bottom()
        ]
        
        ratedCollectionView <- [
            Top().to(watchListCollectionView, .top),
            Bottom().to(watchListCollectionView, .bottom),
            Leading().to(watchListCollectionView, .leading),
            Trailing().to(watchListCollectionView, .trailing)
        ]
        
        _ = repo.takeUntil(rx.deallocated).bind { user in
            self.followerCountButton.setTitle("\(user.info.followerCount.description)\nfollowers", for: .normal)
            self.usernameLabel.text = user.info.username
            self.profileImageView.kf.setImage(with: user.info.profileImageURL)
            self.followingCountButton.setTitle("\(user.info.followingCount.description)\nfollowing", for: .normal)
            self.followButton.setTitle(user.following ? "Unfollow" : "Follow", for: .normal)
            self.segmentedControl.setTitle("Watch List (\(user.info.watchListCount))", forSegmentAt: 0)
            self.segmentedControl.setTitle("Ratings (\(user.info.ratedCount))", forSegmentAt: 1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
