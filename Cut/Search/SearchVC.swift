//
//  SearchVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 12/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EasyPeasy

class SearchVC: UIViewController {
    let searchTF = UITextField()
    let searchView = SearchView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "Search"
        searchTF.placeholder = "Search"
        navigationItem.titleView = searchTF
        
        let qrButton = UIBarButtonItem(title: "QR", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = qrButton
        _ = qrButton.rx.tap.subscribe(onNext: { _ in
            self.present(QrCodeVC(), animated: true, completion: nil)
        })
        
        searchTF <- Width(200)
        
        _ = searchTF.rx
            .controlEvent(.editingChanged)
            .asObservable()
            .throttle(0.8, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] term in
                guard let `self` = self, let term = `self`.searchTF.text else { return }
                `self`.search(withTerm: term)
            })
        
        searchView.filmTableView.register(cellClass: FilmTableCell.self)
        searchView.userTableView.register(cellClass: UserCell.self)
        
        searchView.filmTableView.estimatedRowHeight = 60
        searchView.filmTableView.rowHeight = UITableViewAutomaticDimension
        
        searchView.userTableView.estimatedRowHeight = 60
        searchView.userTableView.rowHeight = UITableViewAutomaticDimension
        
        _ = searchView.segmentedControl.rx.controlEvent(.valueChanged).map { _ in 
            return self.searchView.segmentedControl.selectedSegmentIndex == 0
            }.observeOn(MainScheduler.instance)
            .subscribe(onNext: { showFilms in
                self.searchView.filmTableView.isHidden = !showFilms
            })
        
        _ = searchView.filmTableView.rx
            .itemSelected
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] indexPath in
                guard let safeSelf = self else { return }
                guard let cell = safeSelf.searchView.filmTableView.cellForRow(at: indexPath) as? FilmTableCell else { return }
                guard let film = cell.film else { return }
                safeSelf.navigationController?.pushViewController(FilmDetailVC(film: film), animated: true)
            })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = searchView
    }
    
    func search(withTerm term: String) {
        _ = Search(term: term).call()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { results in
            _ = Observable.just(results.films)
                .bind(to: self.searchView.filmTableView.rx.items(cellClass: FilmTableCell.self)) { _, film, cell in
                    cell.film = film
            }
            _ = Observable.just(results.users)
                .bind(to: self.searchView.userTableView.rx.items(cellClass: UserCell.self)) { _, user, cell in
                    cell.user = user
            }
        })
    }
}
