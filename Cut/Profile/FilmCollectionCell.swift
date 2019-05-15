//
//  FilmCollectionCell.swift
//  Cut
//
//  Created by Kyle McAlpine on 15/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy
import Kingfisher

class FilmCollectionCell: UICollectionViewCell {
    var film: Film? {
        didSet {
            posterImageView.kf.setImage(with: film?.profileImageURL)
        }
    }
    
    let posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(posterImageView)
        
        posterImageView.easy.layout(Edges())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
