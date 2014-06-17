//
//  ResultsEntry.swift
//  HeySwift
//
//  Created by k on 6/13/14.
//  Copyright (c) 2014 iksnae. All rights reserved.
//

import UIKit

class ResultsEntry: NSObject {

    // properties
    var thumbImage:UIImage?
    var title:String?
    var url:String?
    var thumbUrl:String?
    
    
    
    // parse json dictionary
    func parseDict(json:Dictionary<String,AnyObject>)
    {
        
        // reduced repeat code
        func parseString( key:String, dict:NSDictionary ) ->String
        {
            return dict[key] as String
        }
        
        // set values with parse function
        
        
        // title
        self.title = parseString("contentNoFormatting", json )
        
        // full res image url
        self.url = parseString("url", json )
            .stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        // thumb image url
        self.thumbUrl = parseString("tbUrl", json )
            .stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        // load the thumb
        self.loadThumb()
        
    }
    
    
    
    // load thumb image
    func loadThumb()
    {
        let imageData:NSData = NSData.dataWithContentsOfURL(NSURL(string: self.thumbUrl), options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        self.thumbImage = UIImage(data: imageData)
    }
    
    
    // load full image lazily
    @lazy var fullImage:UIImage = {
        println("loading image from: ", self.url.description )
        
        var error:NSError?
        let imageData:NSData = NSData.dataWithContentsOfURL(NSURL(string: self.url), options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &error)
        if error { return UIImage() } else
        {
            return UIImage(data: imageData)
        }
        
    }()
    
    
    
    
}
