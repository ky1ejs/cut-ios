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
import RocketData
import ConsistencyManager

class FeedTVC: UIViewController {
    private let feedView = FeedView(state: .loading)
    private var ctaDisposeBag = DisposeBag()
    private var user: EitherSignedUpUser?
    
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
        
        feedView.tableView.rowHeight = UITableViewAutomaticDimension
        feedView.tableView.estimatedRowHeight = 100
        feedView.tableView.register(cellClass: FeedCell.self)
        feedView.state.value = .loading
        
        DataModelManager.sharedInstance.consistencyManager.addModelUpdatesListener(self)
        
        _ = feedView.tableView
            .rx
            .modelSelected(Watch.self)
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { watch in
                self.navigationController?.pushViewController(FilmDetailVC(film: watch.film), animated: true)
            })
    }
}

extension FeedTVC: ConsistencyManagerUpdatesListener {
    func consistencyManager(_ consistencyManager: ConsistencyManager, updatedModel model: ConsistencyManagerModel, changes: [String : ModelChange], context: Any?) {
        
        self.ctaDisposeBag = DisposeBag()
        
        self.feedView.state.value = {
            if let currentUser = model as? CurrentUser {
                _ = self.feedView.ctaButton.rx.tap.subscribe({ _ in
                    self.present(AuthenticationVC(user: currentUser), animated: true, completion: nil)
                }).disposed(by: self.ctaDisposeBag)
                
                return .loginSignUp
            } else if let currentSignedUpUser = model as? CurrentSignedUpUser {
                if currentSignedUpUser.info.followingCount == 0 {
                    return .followFriends
                } else {
                    let feed = GetFeed().call().takeUntil(self.rx.deallocated).share()
                    _ = feed.bind(to: self.feedView.tableView.rx.items(cellIdentifier: FeedCell.reuseIdentifier, cellType: FeedCell.self)) { (index, watch, cell) in
                        assert(Thread.isMainThread)
                        cell.watch = watch
                    }
                    _ = feed.subscribe({ _ in
                        self.feedView.state.value = .showFeed
                    })
                }
            }
            
            return .loading
        }()
    }
}
