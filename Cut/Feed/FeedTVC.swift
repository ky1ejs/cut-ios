//
//  FeedTVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 20/07/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

class FeedTVC: UITableViewController {

    init() {
        super.init(style: .plain)
        title = "Feed"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(cellClass: FeedCell.self)
        
        loadFilms()
        
        _ = tableView
            .rx
            .itemSelected
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] indexPath in
                guard let safeSelf = self else { return }
                guard let cell = safeSelf.tableView.cellForRow(at: indexPath) as? FeedCell else { return }
                guard let film = cell.watch?.film else { return }
                safeSelf.navigationController?.pushViewController(FilmDetailVC(film: film), animated: true)
            })
    }
    
    
    func loadFilms() {
        _ = GetFeed()
            .call()
            .takeUntil(rx.deallocated)
            .bind(to: tableView.rx.items(cellIdentifier: FeedCell.reuseIdentifier, cellType: FeedCell.self)) { (index, watch, cell) in
                assert(Thread.isMainThread)
                cell.watch = watch
        }
    }

}
