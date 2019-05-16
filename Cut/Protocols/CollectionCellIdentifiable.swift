//
//  CollectionCellIdentifiable.swift
//  Cut
//
//  Created by Kyle McAlpine on 15/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import RxSwift

protocol CollectionCellIdentifiable: class {
    static var reuseIdentifier: String { get }
}

extension CollectionCellIdentifiable {
    static var reuseIdentifier: String { return String(describing: self) }
}

extension UICollectionViewCell: CollectionCellIdentifiable {}

extension UICollectionView {
    func register<CellClass: CollectionCellIdentifiable>(cellClass klass: CellClass.Type) {
        self.register(klass, forCellWithReuseIdentifier: klass.reuseIdentifier)
    }
    
    func dequeueReusableCell<C: TableCellIdentifiable>(ofClass: C.Type, indexPath: IndexPath) -> C? {
        return self.dequeueReusableCell(withReuseIdentifier: C.reuseIdentifier, for: indexPath) as? C
    }
}

extension Reactive where Base == UICollectionView {
    func items<S, Cell, O>(cellClass klass: Cell.Type) -> (O) -> (@escaping (Int, S.Iterator.Element, Cell) -> Swift.Void) -> Disposable where S : Sequence, Cell : UICollectionViewCell, O : ObservableType, O.Element == S {
        return items(cellIdentifier: klass.reuseIdentifier, cellType: klass)
    }
}

