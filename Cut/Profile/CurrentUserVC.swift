//
//  CurrentUserVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 10/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy
import RxSwift

class CurrentUserVC: UIViewController {
    let profileView = ProfileView()
    let authButton = UIBarButtonItem(title: "Login/Sign Up", style: .plain, target: nil, action: nil)
    let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: nil, action: nil)
    var actionDisposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Profile"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileView.watchListCollectionView.register(cellClass: FilmCollectionCell.self)
        profileView.ratedCollectionView.register(cellClass: FilmCollectionCell.self)
        
        
        _ = Store.user
            .takeUntil(rx.deallocated)
            .observeOn(MainScheduler.instance)
            .subscribe(self)
        
        _ = profileView.watchListCollectionView.rx.modelSelected(Watch.self).subscribe(onNext: { [weak self] watch in
            guard let safeSelf = self else { return }
            safeSelf.navigationController?.pushViewController(FilmDetailVC(film: watch.film), animated: true)
        })
        
        _ = profileView.ratedCollectionView.rx.modelSelected(Film.self).subscribe(onNext: { [weak self] film in
            guard let safeSelf = self else { return }
            safeSelf.navigationController?.pushViewController(FilmDetailVC(film: film), animated: true)
        })
        
        _ = profileView.qrCodeButton.rx.tap.asObservable().subscribe(onNext: { [weak self] _ in
            guard let safeSelf = self else { return }
            safeSelf.present(QrCodeVC(), animated: true, completion: nil)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _ = GetWatchList()
            .call()
            .takeUntil(rx.deallocated)
            .bind(to: profileView.watchListCollectionView.rx.items(cellClass: FilmCollectionCell.self)) { index, film, cell in
                cell.film = film
        }
        
        _ = GetRatedFilms()
            .call()
            .takeUntil(rx.deallocated)
            .bind(to: profileView.ratedCollectionView.rx.items(cellClass: FilmCollectionCell.self)) { index, film, cell in
                cell.film = film
        }
    }
}

extension CurrentUserVC: ObserverType {
    typealias E = StoreState<CurrentUser>
    
    func on(_ event: Event<CurrentUserVC.E>) {
        guard case .next(let state) = event else { return }
        guard case .latest(let user) = state else { return }
        profileView.emailLabel.text = user.email.value
        profileView.usernameLabel.text = user.username.value
        navigationItem.rightBarButtonItem = user.isFullUser ? logOutButton : authButton
        
        _ = authButton.rx.tap.subscribe({ _ in
            self.present(AuthenticationVC(user: user), animated: true)
        }).disposed(by: actionDisposeBag)
        
        _ = logOutButton.rx.tap.subscribe({ _ in
            _ = user.logOut().takeUntil(self.rx.deallocated).subscribe()
        }).disposed(by: actionDisposeBag)
    }
}
