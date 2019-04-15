////
////  FollowersTVC.swift
////  Cut
////
////  Created by Kyle McAlpine on 29/01/2018.
////  Copyright © 2018 Kyle McAlpine. All rights reserved.
////
//
//import UIKit
//import RxSwift
import RocketData
//
//class FollowersTVC: UITableViewController {
//    let user: EitherSignedUpUser
//    private let provider = CollectionDataProvider<EitherSignedUpUser>(dataModelManager: DataModelManager.sharedInstance)
//
//    init(user: EitherSignedUpUser) {
//        self.user = user
//        super.init(style: .plain)
//        title = "Followers"
//        provider.delegate = self
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
//        _ = GetFollowers(username: user.userInfo.username)
//            .call()
//            .takeUntil(rx.deallocated)
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { users in
//                self.provider.setData(users.models, cacheKey: nil)
//            })
//
//        _ = tableView.rx.modelSelected(User.self).subscribe(onNext: { user in
//            self.navigationController?.pushViewController(UserVC(user: user), animated: true)
//        })
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(ofClass: UserCell.self)!
//        cell.user = provider.data[indexPath.row]
//        return cell
//    }
//}
//
//extension FollowersTVC: CollectionDataProviderDelegate {
//    func collectionDataProviderHasUpdatedData<T>(_ dataProvider: CollectionDataProvider<T>, collectionChanges: CollectionChange, context: Any?) where T : SimpleModel {
//        switch collectionChanges {
//        case .changes(let changes):
//            let createIndex: (CollectionChangeInformation) -> IndexPath = { info in IndexPath(row: info.index, section: 0) }
//            tableView.deleteRows(at: changes.deletedRows.map(createIndex), with: .automatic)
//            tableView.insertRows(at: changes.insertedRows.map(createIndex), with: .automatic)
//            tableView.reloadRows(at: changes.updatedRows.map(createIndex), with: .automatic)
//        case .reset:
//            tableView.reloadData()
//        }
//    }
//}
//
//
//
extension CollectionChangeInformation {
    var index: Int {
        switch self {
        case .delete(let index): return index
        case .insert(let index): return index
        case .update(let index): return index
        }
    }
}

public extension Collection where Iterator.Element == CollectionChangeInformation {
    var deletedRows: [CollectionChangeInformation] {
        return self.filter({ info -> Bool in
            if case .delete = info { return true }
            return false
        })
    }

    var updatedRows: [CollectionChangeInformation] {
        return self.filter({ info -> Bool in
            if case .update = info { return true }
            return false
        })
    }

    var insertedRows: [CollectionChangeInformation] {
        return self.filter({ info -> Bool in
            if case .insert = info { return true }
            return false
        })
    }
}

