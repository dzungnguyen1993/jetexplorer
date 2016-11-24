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
        
        // TODO: update the appId here
        static let appId = 1159421121
        static let review = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appId)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
    }
    
    struct GoogleAPI {
        static let clientID = "372612069534-rs25sfhnlj60tdqroeenmvrt5i50p3a1.apps.googleusercontent.com"
    }
    
}
