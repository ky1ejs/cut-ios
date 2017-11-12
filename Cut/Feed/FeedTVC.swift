//
//  FeedTVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 20/07/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import RxSwift
import EasyPeasy

class FeedTVC: UIViewController {
    let tableView = UITableView()
    
    var thing: FeedIntroView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Feed"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.addSubview(tableView)
        tableView <- [
            Top().to(view.safeAreaLayoutGuide, .top),
            Leading(),
            Trailing(),
            Bottom().to(view.safeAreaLayoutGuide, .top)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(cellClass: FeedCell.self)
        
        loadFilms()
        
        _ = tableView
            .rx
            .modelSelected(Watch.self)
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { watch in
                self.navigationController?.pushViewController(FilmDetailVC(film: watch.film), animated: true)
            })
    }
    
    
    func loadFilms() {
        _ = Store.user.observeOn(MainScheduler.instance).takeUntil(rx.deallocated).subscribe { event in
            guard case .next(let state) = event else { return }
            guard case .latest(let user) = state else { return }
            
            if !user.isFullUser || user.followerCount.value == 0 {
                let mode: FeedIntroViewMode = user.isFullUser ? .followFriends : .loginSignUp
                let thing = FeedIntroView(mode: mode)
                self.view.addSubview(thing)
                self.thing = thing
                thing <- Edges()
            } else {
                self.thing?.removeFromSuperview()
                _ = GetFeed()
                    .call()
                    .takeUntil(self.rx.deallocated)
                    .bind(to: self.tableView.rx.items(cellIdentifier: FeedCell.reuseIdentifier, cellType: FeedCell.self)) { (index, watch, cell) in
                        assert(Thread.isMainThread)
                        cell.watch = watch
                }
            }
            
        }
    }

}
