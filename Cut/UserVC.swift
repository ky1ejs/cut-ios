//
//  UserVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 21/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import UIKit

class UserVC: UIViewController {
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        let userView = UserView(user: user)
        
        userView.watchListCollectionView.register(cellClass: FilmCollectionCell.self)
        userView.ratedCollectionView.register(cellClass: FilmCollectionCell.self)
        
        _ = GetUserWatchList(username: user.username)
            .call()
            .bind(to: userView
                .watchListCollectionView
                .rx
                .items(cellClass: FilmCollectionCell.self)) { _, film, cell in
                    cell.film = film
        }
        
        _ = GetUserRatings(username: user.username)
            .call()
            .bind(to: userView
                .ratedCollectionView
                .rx
                .items(cellClass: FilmCollectionCell.self)) { _, watch, cell in
                    cell.film = watch.film
        }
        
        _ = userView.watchListCollectionView.rx.modelSelected(Film.self).subscribe(onNext: { [weak self] film in
            guard let safeSelf = self else { return }
            safeSelf.navigationController?.pushViewController(FilmDetailVC(film: film), animated: true)
        })
        
        _ = userView.ratedCollectionView.rx.modelSelected(Watch.self).subscribe(onNext: { [weak self] watch in
            guard let safeSelf = self else { return }
            safeSelf.navigationController?.pushViewController(FilmDetailVC(film: watch.film), animated: true)
        })
        
        _ = userView.followButton.rx.tap.subscribe(onNext: {
            _ = self.user.toggleFollowing().subscribe()
        })
        
        view = userView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self === navigationController?.viewControllers.first {
            let dismissButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
            _ = dismissButton.rx.tap.subscribe(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            navigationItem.rightBarButtonItem = dismissButton
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
