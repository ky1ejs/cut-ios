//
//  SearchView.swift
//  Cut
//
//  Created by Kyle McAlpine on 13/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

class SearchView: UIView {
    let segmentedControl = UISegmentedControl(items: ["Films", "Users"])
    let filmTableView = UITableView()
    let userTableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        segmentedControl.selectedSegmentIndex = 0
        
        addSubview(segmentedControl)
        addSubview(userTableView)
        addSubview(filmTableView)
        
        segmentedControl <- [
            Top(10).to(safeAreaLayoutGuide, .top),
            Leading(20),
            CenterX()
        ]
        
        filmTableView <- [
            Top(10).to(segmentedControl),
            Leading(),
            CenterX(),
            Bottom()
        ]
        
        userTableView <- [
            Top().to(filmTableView, .top),
            Leading(),
            CenterX(),
            Bottom()
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
