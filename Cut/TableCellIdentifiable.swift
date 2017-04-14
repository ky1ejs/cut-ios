//
//  TableCellIdentifiable.swift
//  Cut
//
//  Created by Kyle McAlpine on 24/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import RxSwift

protocol TableCellIdentifiable: class {
    static var reuseIdentifier: String { get }
}

extension TableCellIdentifiable {
    static var reuseIdentifier: String { return String(describing: self) }
}

extension UITableView {
    func register<CellClass: TableCellIdentifiable>(cellClass klass: CellClass.Type) {
        self.register(klass, forCellReuseIdentifier: klass.reuseIdentifier)
    }
    
    func dequeueReusableCell<C: TableCellIdentifiable>(ofClass: C.Type) -> C? {
        return self.dequeueReusableCell(withIdentifier: C.reuseIdentifier) as? C
    }
}

extension Reactive where Base == UITableView {
    func items<S, Cell: TableCellIdentifiable, O>(cellClass klass: Cell.Type) -> (O) -> (@escaping (Int, S.Iterator.Element, Cell) -> Swift.Void) -> Disposable where S : Sequence, Cell : UITableViewCell, O : ObservableType, O.E == S {
        return items(cellIdentifier: klass.reuseIdentifier, cellType: klass)
    }
}
