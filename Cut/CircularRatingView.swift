//
//  CircularRatingView.swift
//  Cut
//
//  Created by Kyle McAlpine on 18/06/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

class CircularRatingView: UIView {
    let arcLayer = CAShapeLayer()
    let icon = UIImageView()
    
    var rating: Rating {
        didSet {
            icon.image = rating.icon
            setNeedsDisplay()
        }
    }
    
    init(rating: Rating) {
        self.rating = rating
        
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        icon.image = rating.icon
        
        let container = UIView()
        
        container.addSubview(icon)
        addSubview(container)
        
        container.layer.addSublayer(arcLayer)
        
        container <- [
            Width(55),
            Height().like(container, .width),
            CenterX(),
            CenterY(),
            Leading(>=0),
            Top(>=0)
        ]
        
        icon <- [
            Top(12),
            Leading(12),
            CenterX(),
            CenterY()
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        arcLayer.strokeColor = UIColor.red.cgColor
        arcLayer.fillColor = UIColor.clear.cgColor
        arcLayer.lineWidth = 6
        
        let radius = (rect.width / 2) - (arcLayer.lineWidth / 2)
        let start = CGFloat((3 * Double.pi) / 2)
        let end = CGFloat(((Double.pi * 2) * rating.score) - (Double.pi / 2))
        
        let arc = UIBezierPath(arcCenter: rect.center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        arcLayer.path = arc.cgPath
    }
}
