//
//  ViewController.swift
//  HeySwift
//
//  Created by k on 6/12/14.
//  Copyright (c) 2014 iksnae. All rights reserved.
//

import UIKit
import AVFoundation


let screenSize:CGRect = UIScreen.mainScreen().bounds

class ViewController: UIViewController, CVDatastoreDelegate, UICollectionViewDelegate, UISearchBarDelegate {
    
    // IB Outlets
    
    @IBOutlet var collectionView : UICollectionView
    
    
    
    // Properties
    
    let datasource:CVDatastore = CVDatastore()
    let activityView:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    let searchBar:UISearchBar = UISearchBar()
    
    var selectedIndexPath:NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    let blurEffectStyle = UIBlurEffectStyle.Dark
    
    
    
    // ViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityView)
        
        self.view.backgroundColor = UIColor.blackColor()
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.dataSource = self.datasource
        self.collectionView.delegate = self
        self.datasource.delegate = self
        
        self.collectionView.contentOffset = CGPoint(x: 0, y: 44);
        
        self.searchBar.frame = CGRect(x: 0, y: 0, width:  CGRectGetWidth(self.collectionView.frame), height: 44)
        self.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        self.searchBar.barStyle = UIBarStyle.Black
        self.searchBar.autocorrectionType = UITextAutocorrectionType.No
        self.searchBar.delegate = self
        self.navigationController.navigationBar.addSubview(self.searchBar)
        
        self.datasource.searchForImages("frida", start: 0);
    }
    
    
    
    // DataSource Delegate Methods
    
    func dataSourceDidChangeState(newState: DataSourceState)
    {
        switch(newState){
        case .Loaded, .Failed, .Idle:
            println("unhandled valid state:\t\t" + newState.toRaw())
            
        case .Loading:
            self.activityView.startAnimating()

        case .Ready:
            
            dispatch_async(dispatch_get_main_queue(), {
                let count = self.datasource.collectionView(self.collectionView, numberOfItemsInSection: 0)
                
                self.title = "\(count) images for '" + self.datasource.searchQuery + "'"
                self.collectionView.reloadData()
                self.activityView.stopAnimating()
            })
        default:
            println("unhandled invalid state:" + newState.toRaw())
        }
    }
    
    @lazy var photoVC:PhotoViewController =
    {
        let vc:PhotoViewController = self.storyboard.instantiateViewControllerWithIdentifier("photoVC") as PhotoViewController
        return vc
    }()
    
    @lazy var dismissSearchButton:UIButton = {
        let btn:UIButton = UIButton(frame: self.collectionView.bounds)
        btn.addTarget(self, action: "onDismissSearch", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    @lazy var blurView :UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: self.blurEffectStyle)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame = self.collectionView.bounds
        return view
        }()
    
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!)
    {
        self.selectedIndexPath = indexPath
        let entry:ResultsEntry = self.datasource.items.objectAtIndex(self.selectedIndexPath.row) as ResultsEntry
        
   
        
        self.navigationController.presentViewController(self.photoVC, animated: true, completion:{
            self.photoVC.entry = entry
            
            })
    }
    
    
    func onDismissSearch()
    {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar!)
    {
        self.title = ""
        self.view.addSubview(self.blurView)
        self.view.addSubview(self.dismissSearchButton);
    }
    func searchBarShouldEndEditing(searchBar: UISearchBar!) -> Bool
    {
        searchBar.resignFirstResponder()
        return true
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar!)
    {
        searchBar.resignFirstResponder()
        self.title = "Total Images: \(self.datasource.collectionView(self.collectionView, numberOfItemsInSection: 0))"
        self.blurView.removeFromSuperview()
        self.dismissSearchButton.removeFromSuperview()
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar!)
    {
        println(self.searchBar.text)
        self.datasource.searchForImages(searchBar.text, start: 0)
        self.searchBar.resignFirstResponder()
        
    }
    
    
}
