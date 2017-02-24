//
//  LoginView.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/14/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class LoginView: UIView {
    // its frame
    static let itsRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 320)
    
    var delegate: LoginViewDelegate!
    
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var googleLabel: UILabel!
    
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
        let viewName = "LoginView"
        let view: UIView = Bundle.main.loadNibNamed(viewName,
                                                              owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        
        facebookLabel.text = "\(NSString.init(utf8String: JetExFontHexCode.facebookIcon.rawValue)!)"
        googleLabel.text = "\(NSString.init(utf8String: JetExFontHexCode.googleIcon.rawValue)!)"
    }
    
    // MARK: - Sign In
    @IBAction func signInWithFacebook(_ sender: AnyObject) {
        delegate.signInWithFacebook()
    }
    
    @IBAction func signInWithGoogle(_ sender: AnyObject) {
        delegate.signInWithGoogle()
    }
    
    @IBAction func signInWithEmail(_ sender: AnyObject) {
        delegate.signInWithEmail()
    }
    
    // MARK: - Sign Up
    @IBAction func signUp(_ sender: AnyObject) {
        delegate.signUp()
    }
}
