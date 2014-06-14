//
//  CVDatastore.swift
//  HeySwift
//
//  Created by k on 6/13/14.
//  Copyright (c) 2014 iksnae. All rights reserved.
//

import UIKit


enum DataSourceState:String {
    case Idle = "Idle"
    case Loading = "Loading"
    case Loaded = "Loaded"
    case Ready = "Ready"
    case Failed = "Failed"
}




protocol CVDatastoreDelegate{
    func dataSourceDidChangeState( let newState:DataSourceState )
}


class CVDatastore: NSObject, UICollectionViewDataSource {
    
    let queue = NSOperationQueue()
    let url = NSURL(string: "")
    
    
    var delegate:CVDatastoreDelegate?
    var items:NSMutableArray = NSMutableArray()
    
    var lastSearchString:String = ""
    
    var currentState:DataSourceState = .Idle{
        didSet{
            println( "datasource state changed:\t"+currentState.toRaw() )
            self.delegate?.dataSourceDidChangeState(currentState)
        }
    }
    
    
    func searchForImages(query:String,start:Int)
    {
        lastSearchString = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&q=\(query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))&start="
        var urlString:String = lastSearchString + String(start)
        
        
        
        let searchUrl = NSURL(string: urlString);
        
        self.items.removeAllObjects()
        
        self.currentState = .Loading
        
        let request:NSURLRequest = NSURLRequest(URL: self.imageSearchURLWithStart(start) )
        NSURLRequest(URL: searchUrl, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            self.currentState = .Loaded
            
            var readError : NSError?
            var dict:Dictionary<String,AnyObject> = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &readError) as Dictionary<String, AnyObject>
            
            if readError
            {
                if let error = readError
                {
                    println("failed to parse json: \( error.localizedDescription )" )
                }
                
                self.currentState = .Failed
                self.currentState = .Idle
            }
            else
            {
                var results:Array<Dictionary< String, AnyObject >> = dict["responseData"]?["results"] as Array<Dictionary< String, AnyObject >>
                
                for itm:Dictionary<String,AnyObject> in results
                {
                    var entry:ResultsEntry = ResultsEntry()
                    entry.parseDict(itm)
                    self.items.addObject(entry)
                }
                
                self.currentState = .Ready
                self.currentState = .Idle
            }
            
            
            })
        
    }
    
    func imageSearchURLWithStart(start:Int) ->NSURL
    {
        return NSURL(string: lastSearchString + String(start))
    }
    
    func refresh()
    {
        self.items.removeAllObjects()
        self.loadImagesFromIndex(0)
    }
    
    func loadImagesFromIndex(fromWhere:Int)
    {
        self.currentState = .Loading
        
        let request:NSURLRequest = NSURLRequest(URL: self.imageSearchURLWithStart(fromWhere) )
        NSURLRequest(URL: self.url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            self.currentState = .Loaded
            
            var readError : NSError?
            var dict:Dictionary<String,AnyObject> = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &readError) as Dictionary<String, AnyObject>
            
            if readError
            {
                if let error = readError
                {
                    println("failed to parse json: \( error.localizedDescription )" )
                }
                
                self.currentState = .Failed
                self.currentState = .Idle
            }
            else
            {
                var results:Array<Dictionary< String, AnyObject >> = dict["responseData"]?["results"] as Array<Dictionary< String, AnyObject >>
                
                for itm:Dictionary<String,AnyObject> in results
                {
                    var entry:ResultsEntry = ResultsEntry()
                    entry.parseDict(itm)
                    self.items.addObject(entry)
                }
                
                self.currentState = .Ready
                self.currentState = .Idle
            }
            
            
            })
    }
    
    
    // Collection View Delegate Methods
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int
    {
        return self.items.count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!
    {
        let cell:MyCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as MyCollectionViewCell
        
        let item:ResultsEntry = self.items.objectAtIndex(indexPath.row) as ResultsEntry
        cell.entry = item
        
        
        if indexPath.item == self.items.count-1 && self.items.count < 64
        {
            self.loadImagesFromIndex(self.items.count)
        }
        
        return cell
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int
    {
        return 1
    }
    
    
}
