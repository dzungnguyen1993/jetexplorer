//
//  Constant.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/24/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import Foundation

struct APIURL {
    struct JetExAPI {
        static let base = "https://jetexplorer.com"
        static let signUp = "/api/auth/signup"
        static let signIn = "/api/auth/signin"
        static let signInWithFacebook = "/api/auth/mfacebook"
        static let signInWithGoogle = "/api/auth/mgoogle"
        static let signOut = "/api/auth/signout"
        static let history = "/api/users/history"
        static let updateUserData = "/api/users"
        static let getUserInfo = "/api/users/me"
        static let changePassword = "/api/users/password"
        static let forgotPassword = "/api/auth/forgot"
        static let changeAvatar = "/api/users/picture"
        static let changeCurrency = "/api/users/currency"
        static let createSubscribe = "/api/subscribe-email"
        static let checkSubscribe = "/api/check-subscribed-email"
        static let editSubscribe = "/api/edit-status-subscribe-email"
        
        // TODO: update the appId here
        static let appId = 1159421121
        static let review = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appId)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
    }
    
    struct FacebookAPI {
        static let prelink = "https://graph.facebook.com/me?fields=email,name,first_name,last_name,gender,birthday,picture.type(large),cover&access_token="
    }
    
    struct GoogleAPI {
        static let clientID = "514456118871-qcmqqechijrvbm44jf6nhn83pgh8mt6l.apps.googleusercontent.com"
        static let prelink = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token="
    }
    
}
