//
//  FeedView.swift
//  Cut
//
//  Created by Kyle McAlpine on 06/11/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy
import RxSwift
import RxCocoa

enum FeedViewState {
    case loading
    case loginSignUp
    case followFriends
    case showFeed
    
    var body: String {
        switch self {
        case .loginSignUp:
            return "Login or sign up to follow friends and see when they rate films or add them to their watch list."
        case .followFriends:
            return "Follow some friends to see the films their interested in"
        default:
            return ""
        }
    }
    
    var cta: String {
        switch self {
        case .loginSignUp:
            return "Login or Sign Up"
        case .followFriends:
            return "Follow Friends"
        default:
            return ""
        }
    }
}

class FeedView: UIView {
    let state: BehaviorRelay<FeedViewState>
    let ctaButton = UIButton(type: .custom)
    let tableView = UITableView(frame: .zero, style: .plain)
    
    fileprivate let loadingContainer = UIView()
    fileprivate let spinner = UIActivityIndicatorView(style: .gray)
    
    fileprivate let introContainer = UIView()
    fileprivate let bodyLabel = UILabel()
    
    let messageContainer = UIView()
    
    init(state: FeedViewState) {
        self.state = BehaviorRelay(value: state)
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        bodyLabel.text = state.body
        bodyLabel.numberOfLines = 0
        bodyLabel.textAlignment = .center
        
        ctaButton.setTitle(state.cta, for: .normal)
        ctaButton.setTitleColor(.white, for: .normal)
        ctaButton.backgroundColor = .red
        ctaButton.layer.cornerRadius = 5
        
        loadingContainer.addSubview(spinner)
        spinner.easy.layout(Center())
        
        introContainer.addSubview(bodyLabel)
        introContainer.addSubview(ctaButton)
        bodyLabel.easy.layout([
            Leading(20),
            CenterX(),
            CenterY()
        ])
        ctaButton.easy.layout([
            Top(20).to(bodyLabel),
            CenterX(),
            Leading(50),
            Height(44)
        ])
        
        addSubview(tableView)
        addSubview(introContainer)
        addSubview(loadingContainer)
        let containerContstraints = [
            Leading(),
            Trailing(),
            Top().to(safeAreaLayoutGuide, .top),
            Bottom().to(safeAreaLayoutGuide, .bottom)
        ]
        tableView.easy.layout(containerContstraints)
        introContainer.easy.layout(containerContstraints)
        loadingContainer.easy.layout(containerContstraints)
        
        _ = self.state.asObservable().takeUntil(rx.deallocated).observeOn(MainScheduler.instance).subscribe(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedView: ObserverType {
    typealias E = FeedViewState
    
    func on(_ event: Event<FeedViewState>) {
        guard case .next(let state) = event else { return }
        
        switch state {
        case .followFriends, .loginSignUp:
            bodyLabel.text = state.body
            ctaButton.setTitle(state.cta, for: .normal)
            introContainer.alpha = 1
            loadingContainer.alpha = 0
            tableView.alpha = 0
            spinner.stopAnimating()
        case .loading:
            introContainer.alpha = 0
            loadingContainer.alpha = 1
            tableView.alpha = 0
            spinner.startAnimating()
        case .showFeed:
            introContainer.alpha = 0
            loadingContainer.alpha = 0
            tableView.alpha = 1
            spinner.stopAnimating()
        }
    }
}
