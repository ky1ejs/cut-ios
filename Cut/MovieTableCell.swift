//
//  MovieTableCell.swift
//  Cut
//
//  Created by Kyle McAlpine on 24/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import Kingfisher
import EasyPeasy
import SwipeCellKit

class MovieTableCell: SwipeTableViewCell {
    fileprivate var _textLabel: UILabel
    override var textLabel: UILabel {
        get { return _textLabel }
        set { _textLabel = newValue }
    }
    var posterImageView: UIImageView
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else {
                textLabel.text = nil
                posterImageView.image = nil
                return
            }
            
            textLabel.text = movie.title
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: movie.posterURL, placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil, completionHandler: nil)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        _textLabel = UILabel()
        posterImageView = UIImageView()
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textLabel)
        contentView.addSubview(posterImageView)
        
        textLabel <- [
            Leading(30).to(posterImageView),
            CenterY(),
            Bottom(>=20),
            Trailing(5)
        ]
        
        posterImageView <- [
            Top(5),
            CenterY(),
            Leading(5),
            Size(CGSize(width: 61, height: 91))
        ]
        
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieTableCell: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let watchAction = SwipeAction(style: .default, title: "Watch") { action, indexPath in
            guard let movieCell = tableView.cellForRow(at: indexPath) as? MovieTableCell else { return }
            movieCell.movie?.addToWatchList()
        }
        
        return [watchAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        return options
    }
}


extension MovieTableCell: TableCellIdentifiable {}
