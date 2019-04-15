//
//  UserCell.swift
//  Cut
//
//  Created by Kyle McAlpine on 14/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy
import Kingfisher
import RocketData
import ConsistencyManager
import RxSwift

class UserCell: UITableViewCell {
    var user: EitherSignedUpUser? {
        didSet {
            // Clean up from previous user
            actionDisposeBag = DisposeBag()
            DataModelManager.sharedInstance.consistencyManager.removeListener(self)
            
            profileImageView.kf.setImage(with: user?.userInfo.profileImageURL)
            usernameTitleLabel.text = user?.userInfo.username
            
            switch user {
            case .some(.currentUser(let user)):
                DataModelManager.sharedInstance.consistencyManager.addListener(self, to: user)
                followButton.isHidden = true
            case .some(.user(let user)):
                DataModelManager.sharedInstance.consistencyManager.addListener(self, to: user)
                followButton.isHidden = false
                followButton.setTitle(user.following ? "Unfollow" : "Follow", for: .normal)
                _ = followButton.rx.tap.subscribe({ _ in
                    _ = FollowUnfollowUser(username: user.info.username, follow: !user.following).call().subscribe(onNext: { user in
                        DataModelManager.sharedInstance.consistencyManager.updateModel(EitherSignedUpUser.user(user))
                    })
                }).disposed(by: actionDisposeBag)
            default:
                break
            }
        }
    }
    
    let profileImageView = UIImageView()
    let usernameTitleLabel = UILabel()
    let followButton = UIButton()
    var actionDisposeBag = DisposeBag()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameTitleLabel)
        contentView.addSubview(followButton)
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(.blue, for: .normal)
        followButton.layer.borderColor = UIColor.blue.cgColor
        followButton.layer.borderWidth = 2
        followButton.layer.cornerRadius = 5
        
        profileImageView <- [
            Leading(20),
            CenterY(),
            Top(>=20),
            Height(40),
            Width().like(profileImageView, .height)
        ]
        
        usernameTitleLabel <- [
            Leading(15).to(profileImageView),
            CenterY(),
            Top(>=20)
        ]
        
        followButton <- [
            CenterY(),
            Leading(15).to(usernameTitleLabel),
            Trailing(20),
            Height(34),
            Width(80)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserCell: ConsistencyManagerListener {
    func currentModel() -> ConsistencyManagerModel? {
        return user
    }
    
    func modelUpdated(_ model: ConsistencyManagerModel?, updates: ModelUpdates, context: Any?) {
        self.user = model as? EitherSignedUpUser
    }
}

extension UserCell: TableCell {
    typealias Model = EitherSignedUpUser
    var model: Model? {
        get { return user }
        set { user = newValue }
    }
}
