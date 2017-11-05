//
//  ProfileVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 10/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy
import RxSwift

class ProfileVC: UIViewController {
    let profileView = ProfileView()
    let authButton = UIBarButtonItem(title: "Login/Sign Up", style: .plain, target: nil, action: nil)
    let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: nil, action: nil)
    
    var userDisposeBag = DisposeBag()
    var user: User? {
        didSet {
            userDisposeBag = DisposeBag() // Empties the bag by generating a new one
            
            profileView.emailLabel.text = user?.email.value
            profileView.usernameLabel.text = user?.username.value
            
            guard let user = user else { return }
            
            _ = user.username
                .asObservable()
                .takeUntil(rx.deallocated)
                .bind(to: profileView.usernameLabel.rx.text)
                .disposed(by: userDisposeBag)
                
            _ = user.email
                .asObservable()
                .takeUntil(rx.deallocated)
                .bind(to: profileView.emailLabel.rx.text)
                .disposed(by: userDisposeBag)
            
            
            
            _ = Observable.combineLatest(user.email.asObservable(), user.username.asObservable(), resultSelector: { (email, username) -> Bool in
                guard let _ = email else { return false }
                guard let _ = username else { return false }
                return true
            }).takeUntil(rx.deallocated)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { isLoggedIn in
                    self.navigationItem.rightBarButtonItem = isLoggedIn ? self.logOutButton : self.authButton
                })
                .disposed(by: userDisposeBag)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Profile"
        
        authButton.target = self
        authButton.action = #selector(showAccountController)
        
        logOutButton.target = self
        logOutButton.action = #selector(logOut)
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
        
        _ = GetUser()
            .call()
            .takeUntil(rx.deallocated)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .next(let user):   self?.user = user
                case .error(let error): print(error)
                case .completed:        break
                }
        }
        
        _ = profileView.watchListCollectionView.rx.modelSelected(Watch.self).subscribe(onNext: { [weak self] watch in
            guard let safeSelf = self else { return }
            safeSelf.navigationController?.pushViewController(FilmDetailVC(film: watch.film), animated: true)
        })
        
        _ = profileView.ratedCollectionView.rx.modelSelected(Watch.self).subscribe(onNext: { [weak self] watch in
            guard let safeSelf = self else { return }
            safeSelf.navigationController?.pushViewController(FilmDetailVC(film: watch.film), animated: true)
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
            .bind(to: profileView.ratedCollectionView.rx.items(cellClass: FilmCollectionCell.self)) { index, watch, cell in
                cell.film = watch.film
        }
    }
    
    @objc func showAccountController() {
        present(AuthenticationVC(user: user!), animated: true)
    }
    
    @objc func logOut() {
        _ = user?.logOut().takeUntil(rx.deallocated).subscribe()
    }
}
