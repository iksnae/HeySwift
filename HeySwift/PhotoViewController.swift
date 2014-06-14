//
//  PhotoViewController.swift
//  HeySwift
//
//  Created by k on 6/14/14.
//  Copyright (c) 2014 iksnae. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoViewController: UIViewController, UIActionSheetDelegate {

    @IBOutlet var imageView : UIImageView
    
    var entry:ResultsEntry = ResultsEntry(){
        didSet{
            self.imageView.image = self.entry.thumbImage
        }
    }
    
    @IBAction func onDone(sender : AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onAction(sender : AnyObject) {
        
        let actionSheet:UIActionSheet = UIActionSheet()
        actionSheet.delegate = self
        actionSheet.addButtonWithTitle("Cancel")
        actionSheet.addButtonWithTitle("Show Hi Res Image")
        actionSheet.addButtonWithTitle("Save Image")
        
        actionSheet.cancelButtonIndex=0
        
        actionSheet.showInView(self.view)
    }
    
    @IBAction func onSave(sender : AnyObject) {
        self.saveImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    
    func saveImage()
    {
        UIImageWriteToSavedPhotosAlbum(self.entry.fullImage, nil, nil, nil)
    }
    
    
    func actionSheet(actionSheet: UIActionSheet!, didDismissWithButtonIndex buttonIndex: Int)
    {
        switch(buttonIndex) {
            
        case 0:
            println("cancelled")
            
        case 1:
            println("hi res")
            self.imageView.image = self.entry.fullImage
            
        case 2:
            println("save")
            saveImage()
        
        default:
            println("unknown action index" + String(buttonIndex))
    }
    
        
    }

}
