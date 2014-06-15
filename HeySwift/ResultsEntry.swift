//
//  ResultsEntry.swift
//  HeySwift
//
//  Created by k on 6/13/14.
//  Copyright (c) 2014 iksnae. All rights reserved.
//

import UIKit

class ResultsEntry: NSObject {
    
    
    func parseDict(json:Dictionary<String,AnyObject>)
    {
        if let title:AnyObject = json["contentNoFormatting"]{ self.title = title as NSString }
        if let url:AnyObject = json["url"]{ self.url = url.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding) as NSString }
        if let tbUrl:AnyObject = json["tbUrl"]{ self.thumbUrl = tbUrl.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding) as NSString }
        
        self.loadThumb()

        
    }
    
    func loadThumb()
    {
        let imageData:NSData = NSData.dataWithContentsOfURL(NSURL(string: self.thumbUrl), options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        self.thumbImage = UIImage(data: imageData)
    }
    
    var title:String?
    var url:String?
    var thumbUrl:String?
    var width:Float?
    var height:Float?
    
    @lazy var fullImage:UIImage = {
        println("loading image from: ", self.url.description )
        let imageData:NSData = NSData.dataWithContentsOfURL(NSURL(string: self.url), options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        return UIImage(data: imageData)
    }()
    
    var thumbImage:UIImage?
    
    
}
