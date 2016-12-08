//
//  LoadingPopupVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 12/9/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class LoadingPopupVC: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var timer: Timer?
    
    func startProgress(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.fakeUpdatingProgress), userInfo: nil, repeats: true)
    }
    
    func updateProgress(percent: Int, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.05, animations: {
            self.progressView.progress = Float(percent)/100.0
        }, completion: { (completed) in
            if let completion = completion {
                // complete
                self.timer?.invalidate() // stop timer
                self.timer = nil
                
                completion()
            }
        })
    }
    
    func fakeUpdatingProgress() {
        let currentPercent = self.progressView.progress
        if currentPercent < 0.95 {
            self.progressView.setProgress(currentPercent + 0.01, animated: true) // + 10% per second
        }
    }
}
