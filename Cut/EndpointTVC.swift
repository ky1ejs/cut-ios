//
//  EndpointTVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 19/03/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import UIKit
import RxSwift
import RocketData
import ConsistencyManager

class EndpointTVC<CellType: UITableViewCell & TableCell, E, M>: UITableViewController where M: Model, CellType.Model == M, E: Endpoint, E.SuccessData == Array<M> {
    private let endpoint: E
    private let provider = CollectionDataProvider<CellType.Model>(dataModelManager: DataModelManager.sharedInstance)
    
    //    var modelSelected: ControlEvent<M> { return tableView.rx.modelSelected(M.self) }
    
    init(endpoint: E, title: String) {
        self.endpoint = endpoint
        
        super.init(style: .plain)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(cellClass: CellType.self)
        
        _ = endpoint
            .call()
            .takeUntil(rx.deallocated)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { models in
                self.provider.setData(models, cacheKey: nil)
            })
    }
}

extension EndpointTVC: CollectionDataProviderDelegate {
    func collectionDataProviderHasUpdatedData<T>(_ dataProvider: CollectionDataProvider<T>, collectionChanges: CollectionChange, context: Any?) {
        switch collectionChanges {
        case .changes(let changes):
            let createIndex: (CollectionChangeInformation) -> IndexPath = { info in IndexPath(row: info.index, section: 0) }
            tableView.deleteRows(at: changes.deletedRows.map(createIndex), with: .automatic)
            tableView.insertRows(at: changes.insertedRows.map(createIndex), with: .automatic)
            tableView.reloadRows(at: changes.updatedRows.map(createIndex), with: .automatic)
        case .reset:
            tableView.reloadData()
        }
    }
}

protocol TableCell {
    associatedtype Model
    
    var model: Model? { get set }
}
