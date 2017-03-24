//
//  TableCellIdentifiable.swift
//  Cut
//
//  Created by Kyle McAlpine on 24/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

protocol TableCellIdentifiable: class {
    static var reuseIdentifier: String { get }
}

extension TableCellIdentifiable {
    static var reuseIdentifier: String { return String(describing: self) }
}

extension UITableView {
    func registerClass<CellClass: TableCellIdentifiable>(_ klass: CellClass.Type) {
        self.register(klass, forCellReuseIdentifier: klass.reuseIdentifier)
    }
    
    func dequeueReusableCellOfClass<C: TableCellIdentifiable>(_: C.Type) -> C? {
        return self.dequeueReusableCell(withIdentifier: C.reuseIdentifier) as? C
    }
}
