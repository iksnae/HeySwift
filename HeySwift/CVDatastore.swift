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
    
    let baseQueryString:String = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&q="
    let queue:NSOperationQueue = NSOperationQueue()
    let url:NSURL = NSURL(string: "")
    let items:NSMutableArray = NSMutableArray()
    
    var delegate:CVDatastoreDelegate?
    
    
    var searchQuery:String = ""{
        didSet{
            println( "set last search query: " + searchQuery )
        }
    }
    
    var searchStartIndex:Int = 0{
        didSet{
            println( "set last search index: " + String( searchStartIndex ) )
        }
    }

    var currentState:DataSourceState = .Idle{
        didSet{
            println( "datasource state changed:\t" + currentState.toRaw() )
            self.delegate?.dataSourceDidChangeState(currentState)
        }
    }
    
    
    func searchURL() -> NSURL
    {
        let urlEncodedQuery:String = searchQuery.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let urlString:String = baseQueryString + urlEncodedQuery + "&start=" + String( searchStartIndex )
        return NSURL(string: urlString )
    }
    
    
    func searchForImages( query:String, start:Int )
    {
        // cache the query and start values
        searchQuery = query
        searchStartIndex = start
        items.removeAllObjects()
        
        // load images
        self.loadImages()
    }
    
  

    func refresh()
    {
        searchStartIndex = 0
        items.removeAllObjects()
        loadImages()
    }
    
    func loadMoreImages()
    {
        searchStartIndex = self.items.count;
        loadImages()
    }
    
    func loadImages()
    {
        self.currentState = .Loading
        
        
        let request:NSURLRequest = NSURLRequest(URL: self.searchURL() )
        NSURLRequest(URL: self.url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // set the state: loaded
            self.currentState = .Loaded
            
            // check that there was no error with request
            if (error)
            {
                println("Request Failed: ", error.localizedDescription )
                self.currentState = .Failed
                self.currentState = .Idle
            }
            else
            {
                println("Request Successful")
                self.parseResults( data )
            }
            
        })
    }
    
    
    func parseResults( data:NSData )
    {
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
            loadMoreImages()
        }
        
        return cell
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int
    {
        return 1
    }
    
    
}
