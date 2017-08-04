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
    
    var userDisposeBag = DisposeBag()
    var user: User? {
        didSet {
            userDisposeBag = DisposeBag() // Empties the bag by generating a new one
            
            profileView.emailLabel.text = user?.email.value
            profileView.usernameLabel.text = user?.username.value
            
            _ = user?.username
                .asObservable()
                .takeUntil(rx.deallocated)
                .bind(to: profileView.usernameLabel.rx.text)
                .disposed(by: userDisposeBag)
                
            _ = user?.email
                .asObservable()
                .takeUntil(rx.deallocated)
                .bind(to: profileView.emailLabel.rx.text)
                .disposed(by: userDisposeBag)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAccountController))
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
        
        _ = profileView.watchListCollectionView.rx.modelSelected(Film.self).subscribe(onNext: { [weak self] film in
            guard let safeSelf = self else { return }
            safeSelf.navigationController?.pushViewController(FilmDetailVC(film: film), animated: true)
        })
        
        _ = profileView.ratedCollectionView.rx.modelSelected(Film.self).subscribe(onNext: { [weak self] film in
            guard let safeSelf = self else { return }
            safeSelf.navigationController?.pushViewController(FilmDetailVC(film: film), animated: true)
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
        present(SignUpVC(user: user!), animated: true)
    }
}
