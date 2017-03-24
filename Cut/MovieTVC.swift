//
//  MovieTVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 03/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class MovieTVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.registerClass(MovieTableCell.self)
        
        loadMovies()
        
        _ = tableView
            .rx
            .itemSelected
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] indexPath in
                assert(Thread.isMainThread)
                guard let safeSelf = self else { return }
                guard let cell = safeSelf.tableView.cellForRow(at: indexPath) else { return }
                print(cell.textLabel?.text ?? "")
                safeSelf.tableView.deselectRow(at: indexPath, animated: true)
        })
    }
    
    
    func loadMovies() {
        _ = RottenTomatoesListMovies()
            .call()
            .takeUntil(self.rx.deallocated)
            .bindTo(tableView.rx.items(cellIdentifier: MovieTableCell.reuseIdentifier, cellType: MovieTableCell.self)) { (index, movie, cell) in
                assert(Thread.isMainThread)
                cell.movie = movie
        }
    }
}


