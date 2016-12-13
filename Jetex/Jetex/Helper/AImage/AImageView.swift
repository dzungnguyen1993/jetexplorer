//
//  AImageView.swift
//  AImage
//
//  Created by wangjwchn on 16/3/14.
//  Copyright © 2016 JW. All rights reserved.
//

import ImageIO
import UIKit
let _imageviewStorageKey = malloc(8)
let DEFAULT_MEMORY_LIMIT = 20

public extension UIImageView {
    
    public convenience init(AImage:UIImage, MemoryLimit_MB:Int = DEFAULT_MEMORY_LIMIT){
        self.init()
        SetAImage(AImage: AImage,MemoryLimit_MB: MemoryLimit_MB)
    }
    
    
    public func SetAImage(AImage:UIImage,MemoryLimit_MB:Int = DEFAULT_MEMORY_LIMIT){
        self.m_ = imageview_storage()
        self.m_!.aImage = AImage
        self.m_!.displayOrderIndex = 0
        self.m_!.needToPlay = false;
        self.m_!.timer = nil;
        self.m_!.currentImage = UIImage(cgImage: CGImageSourceCreateImageAtIndex(self.GetAImage().GetImageSource(),0,nil)!)
        if(self.GetAImage().GetImageSize()>=MemoryLimit_MB){
            self.m_!.timer = CADisplayLink(target: self, selector: #selector(UIImageView.updateFrameWithoutCache))
        }else{
            DispatchQueue.global().async {
                self.prepareCache()
            }
            
            self.m_!.timer = CADisplayLink(target: self, selector: #selector(UIImageView.updateFrameWithCache))
        }
        
        self.m_!.timer!.frameInterval = self.GetAImage().GetRefreshFactor()
        self.m_!.timer!.add(to: .main, forMode: RunLoopMode.commonModes)
    }
    
    
    public func APlay(){
        self.m_!.needToPlay = true;
    }
    public func AStop(){
        self.m_!.needToPlay = false;
    }
    
    public func GetPlayJudge()->Bool {return m_!.needToPlay!}
    public func GetTimer()->CADisplayLink {return m_!.timer!}
    public func GetAImage()->UIImage {return m_!.aImage!}
    public func GetDisplayOrderIndex()->Int{return m_!.displayOrderIndex!}
    public func GetCurrentImage()->UIImage{return m_!.currentImage!}
    public func GetImageCache()->NSCache<AnyObject, AnyObject> {return m_!.cache!}
    
    func prepareCache(){
        self.m_!.cache = NSCache()
        
        let options = NSDictionary(dictionary: [kCGImageSourceShouldCache : true])
        
        for i in 0..<self.GetAImage().GetDisplayOrder().count {
            let image = UIImage(cgImage: CGImageSourceCreateImageAtIndex(self.GetAImage().GetImageSource(), self.GetAImage().GetDisplayOrder()[i], options)!)
            self.GetImageCache().setObject(image,forKey: i as AnyObject)
        }
    }
    
    //bound to 'displayLink'
    func updateFrameWithoutCache(){
        if(self.GetPlayJudge() == true){
            self.image = self.GetCurrentImage()
            DispatchQueue.global().async {
                let options = NSDictionary(dictionary: [kCGImageSourceShouldCache : false])
                self.m_!.currentImage = UIImage(cgImage: CGImageSourceCreateImageAtIndex(self.GetAImage().GetImageSource(), self.GetAImage().GetDisplayOrder()[self.GetDisplayOrderIndex()], options)!)
                    
                self.m_!.displayOrderIndex = (self.GetDisplayOrderIndex()+1)%self.GetAImage().GetImageNumber()
            }
        }
    }
    
    //bound to 'displayLink'
    func updateFrameWithCache(){
        if(self.GetPlayJudge() == true){
            self.image = self.GetImageCache().object(forKey: self.GetDisplayOrderIndex() as AnyObject) as? UIImage
            self.m_!.displayOrderIndex = (self.GetDisplayOrderIndex()+1)%self.GetAImage().GetImageNumber()
        }
    }
    
    private var m_:imageview_storage?{
        get {
            return (objc_getAssociatedObject(self, _imageviewStorageKey) as! imageview_storage)
        }
        set {
            objc_setAssociatedObject(self, _imageviewStorageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
        }
    }
    
}

private class imageview_storage{
    var needToPlay:Bool?
    var timer:CADisplayLink?
    var aImage:UIImage?
    var displayOrderIndex:Int?
    var currentImage:UIImage?
    var cache:NSCache<AnyObject, AnyObject>?
}

