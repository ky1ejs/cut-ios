//
//  FilmTVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 03/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class FilmTVC: UITableViewController {
    
    init() {
        super.init(style: .plain)
        title = "Films"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(cellClass: FilmTableCell.self)
        
        loadFilms()
        
        _ = tableView
            .rx
            .itemSelected
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] indexPath in
                guard let safeSelf = self else { return }
                guard let cell = safeSelf.tableView.cellForRow(at: indexPath) as? FilmTableCell else { return }
                guard let film = cell.film else { return }
                safeSelf.navigationController?.pushViewController(FilmDetailVC(film: film), animated: true)
        })
    }
    
    
    func loadFilms() {
        _ = ListFilms()
            .call()
            .takeUntil(rx.deallocated)
            .bindTo(tableView.rx.items(cellIdentifier: FilmTableCell.reuseIdentifier, cellType: FilmTableCell.self)) { (index, film, cell) in
                assert(Thread.isMainThread)
                cell.film = film
        }
    }
}

