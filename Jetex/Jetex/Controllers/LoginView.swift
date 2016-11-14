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
    }
    
    // MARK: - Sign In
    @IBAction func signInWithFacebook(_ sender: AnyObject) {
        
    }
    
    @IBAction func signInWithGoogle(_ sender: AnyObject) {
        
    }
    
    @IBAction func signInWithEmail(_ sender: AnyObject) {
        
    }
    
    // MARK: - Sign Up
    @IBAction func signUp(_ sender: AnyObject) {
        
    }
}
