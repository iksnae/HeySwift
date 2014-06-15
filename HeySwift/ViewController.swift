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
    
    // Properties ( Constants )
    
    let datasource:CVDatastore = CVDatastore()
    let activityView:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    let blurEffectStyle = UIBlurEffectStyle.Dark
    
    
    
    
    // Properties ( Reactive )
    
    var selectedIndexPath:NSIndexPath = NSIndexPath(forItem: 0, inSection: 0){
        didSet{
            let entry:ResultsEntry = self.datasource.items.objectAtIndex(self.selectedIndexPath.row) as ResultsEntry
            
            self.navigationController.presentViewController(self.photoVC, animated: true, completion:{
                self.photoVC.entry = entry
                })
        }
    }
    
    var totalResults:Int = 0
    {
        didSet{
            self.title = "\(totalResults) images for '" + self.datasource.searchQuery + "'"
            
        }
    }
    
    var isSearching:Bool = false
    {
        didSet{
            if(isSearching)
            {
                self.title = ""
                self.view.addSubview(self.blurView)
                self.view.addSubview(self.dismissSearchButton);
            }
            else
            {
                searchBar.resignFirstResponder()
                self.title = "Total Images: \(self.datasource.collectionView(self.collectionView, numberOfItemsInSection: 0))"
                self.blurView.removeFromSuperview()
                self.dismissSearchButton.removeFromSuperview()
                searchBar.text = ""
            }
        }
    }
    
    // Properties ( Lazy Instantiated )
    
    @lazy var searchBar:UISearchBar = {
        
        let sb = UISearchBar()
        sb.frame = CGRect(x: 0, y: 0, width:  CGRectGetWidth(self.collectionView.frame), height: 44)
        sb.searchBarStyle = UISearchBarStyle.Minimal
        sb.barStyle = UIBarStyle.Black
        sb.autocorrectionType = UITextAutocorrectionType.No
        sb.delegate = self
        return sb
    }()
    
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
    
    
    // Functions
    func onDismissSearch()
    {
        self.searchBar.resignFirstResponder()
    }
    
    
    
    // ViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityView)
        self.view.backgroundColor = UIColor.blackColor()
        self.navigationController.navigationBar.addSubview(self.searchBar)
        
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.dataSource = self.datasource
        self.collectionView.delegate = self
        self.datasource.delegate = self
        self.collectionView.contentOffset = CGPoint(x: 0, y: 44);
        
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
                self.totalResults = self.datasource.collectionView(self.collectionView, numberOfItemsInSection: 0)
                self.collectionView.reloadData()
                self.activityView.stopAnimating()
            })
        default:
            println("unhandled invalid state:" + newState.toRaw())
        }
    }
    
    // UICollectionView Delegate Methods
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!)
    {
        self.selectedIndexPath = indexPath
    }
    
    
    
    // UISearchBar Delegate Methods
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar!)
    {
        self.isSearching = true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar!) -> Bool
    {
        self.isSearching = false;
        return true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar!)
    {
        self.isSearching = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar!)
    {
        println(self.searchBar.text)
        self.datasource.searchForImages(searchBar.text, start: 0)
        self.isSearching = false;
    }
    
    
    
    
}
