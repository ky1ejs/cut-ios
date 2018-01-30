//
//  FollowersTVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 29/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import UIKit
import RxSwift

class FollowersTVC: UITableViewController {
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
        title = "Followers"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(cellClass: UserCell.self)
        
        _ = GetFollowers(user: user)
            .call()
            .takeUntil(rx.deallocated)
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellClass: UserCell.self)) { _, user, cell in
                cell.user = user
        }
        
        _ = tableView.rx.modelSelected(User.self).subscribe(onNext: { user in
            self.navigationController?.pushViewController(UserVC(user: user), animated: true)
        })
    }
}
