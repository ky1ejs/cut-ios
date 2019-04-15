//
//  CurrentUserVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 10/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import RxSwift
import RocketData

class CurrentUserVC: UIViewController {
    let profileView = CurrentUserView()
    let authButton = UIBarButtonItem(title: "Login/Sign Up", style: .plain, target: nil, action: nil)
    let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: nil, action: nil)
    var actionDisposeBag = DisposeBag()
    let repo = EitherCurrentUserRepository()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Profile"
        _ = repo.takeUntil(rx.deallocated).observeOn(MainScheduler.instance).subscribe(onNext: { state in
            self.actionDisposeBag = DisposeBag()
            
            switch state {
            case .notFetched:
                break
            case .latest(let user):
                switch user {
                case .currentUser(let user):
                    self.profileView.emailLabel.text = nil
                    self.profileView.usernameLabel.text = nil
                    self.navigationItem.rightBarButtonItem = self.authButton
                    _ = self.authButton.rx.tap.subscribe({ _ in
                        self.present(AuthenticationVC(user: user), animated: true)
                    }).disposed(by: self.actionDisposeBag)
                case .currentSignedUpUser(let user):
                    self.profileView.emailLabel.text = user.email
                    self.profileView.usernameLabel.text = user.info.username
                    self.navigationItem.rightBarButtonItem = self.logOutButton
                    _ = self.logOutButton.rx.tap.subscribe({ _ in
                        _ = self.repo.logOut()
                    }).disposed(by: self.actionDisposeBag)
                }
            case .error(let error):
                break
            }})
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
        
        _ = profileView.watchListCollectionView.rx.modelSelected(Film.self).subscribe(onNext: { [weak self] film in
            guard let safeSelf = self else { return }
            safeSelf.navigationController?.pushViewController(FilmDetailVC(film: film), animated: true)
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
        
        _ = GetCurrentUserWatchList()
            .call()
            .takeUntil(rx.deallocated)
            .bind(to: profileView.watchListCollectionView.rx.items(cellClass: FilmCollectionCell.self)) { index, film, cell in
                cell.film = film
        }
        
        _ = GetCurrentUserRatedFilms()
            .call()
            .takeUntil(rx.deallocated)
            .bind(to: profileView.ratedCollectionView.rx.items(cellClass: FilmCollectionCell.self)) { index, film, cell in
                cell.film = film
        }
    }
}
