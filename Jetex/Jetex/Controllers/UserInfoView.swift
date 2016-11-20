//
//  UserInfoView.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/14/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class UserInfoView: UIView {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var delegate : UserInfoViewDelegate!
    
    // its frame
    static let itsRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
    
    
    // MARK: - Init
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let viewName = "UserInfoView"
        let view: UIView = Bundle.main.loadNibNamed(viewName,
                                                    owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        
        let tapAvatarView = UITapGestureRecognizer(target: self, action: #selector(userAvatarPressed(sender:)))
        userAvatar.addGestureRecognizer(tapAvatarView)
    }
    
    @IBAction func viewAndEditProfileButtonPressed(_ sender: AnyObject) {
        delegate.viewAndEditProfile()
    }

    func userAvatarPressed(sender: AnyObject) {
        delegate.userAvatarPressed()
    }
    
    func updateUserName(userName: String) {
        self.userName.text = userName
    }
}
