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
    let feedView = FeedView(state: .loading)
    var ctaDisposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Feed"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedView.tableView.rowHeight = UITableView.automaticDimension
        feedView.tableView.estimatedRowHeight = 100
        feedView.tableView.register(cellClass: FeedCell.self)
        
        loadFilms()
        
        _ = feedView.tableView
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
            
            self.ctaDisposeBag = DisposeBag()
            
            self.feedView.state.accept({
                if !user.isFullUser || user.followerCount.value == 0 {
                    _ = self.feedView.ctaButton.rx.tap.subscribe({ _ in
                        switch self.feedView.state.value {
                        case .loginSignUp:
                            self.present(AuthenticationVC(user: user), animated: true, completion: nil)
                        case .followFriends:
                            break
                        default:
                            break
                        }
                    }).disposed(by: self.ctaDisposeBag)
                    return user.isFullUser ? .followFriends : .loginSignUp
                }
                
                let feed = GetFeed().call().takeUntil(self.rx.deallocated)
                _ = feed.bind(to: self.feedView.tableView.rx.items(cellIdentifier: FeedCell.reuseIdentifier, cellType: FeedCell.self)) { (index, watch, cell) in
                        assert(Thread.isMainThread)
                        cell.watch = watch
                }
                _ = feed.subscribe({ _ in
                    self.feedView.state.accept(.showFeed)
                })
                
                return .loading
            }())
        }
    }

}
