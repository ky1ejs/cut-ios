////
////  FollowingTVC.swift
////  Cut
////
////  Created by Kyle McAlpine on 30/01/2018.
////  Copyright © 2018 Kyle McAlpine. All rights reserved.
////
//
//import UIKit
//import RxSwift
//import RocketData
//import ConsistencyManager
//
//class FollowingTVC: UITableViewController {
//    let user: User
//    
//    init(user: User) {
//        self.user = user
//        super.init(style: .plain)
//        title = "Following"
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 100
//        tableView.register(cellClass: UserCell.self)
//        
//        _ = GetFollowing(user: user)
//            .call()
//            .takeUntil(rx.deallocated)
//            .observeOn(MainScheduler.instance)
//            .bind(to: tableView.rx.items(cellClass: UserCell.self)) { _, user, cell in
//                cell.user = user
//        }
//        
//        _ = tableView.rx.modelSelected(User.self).subscribe(onNext: { user in
//            self.navigationController?.pushViewController(UserVC(user: user), animated: true)
//        })
//    }
//}
//
//
