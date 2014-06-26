//
//  MyCollectionViewCell.swift
//  HeySwift
//
//  Created by k on 6/13/14.
//  Copyright (c) 2014 iksnae. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet var label : UILabel
    @IBOutlet var imageView : UIImageView
    
    var entry:ResultsEntry = ResultsEntry()
    {
        didSet{
            self.labelText = entry.title!
            imageView.image = entry.thumbImage
            }
    }
    
    
    var labelText:String = "" {
        didSet{
            self.vibrantLabel.text = self.labelText
            self.label.text = self.labelText
        }
    }
    
    let blurEffectStyle = UIBlurEffectStyle.Light
   
    override func didMoveToSuperview()
    {
        
        if !blurView.superview {
            contentView.addSubview(blurView)
            blurView.contentView.addSubview(vibrancyView)
            vibrancyView.contentView.addSubview(vibrantLabel)
        }
    }
    
    @lazy var vibrantLabel :UILabel = {
        let label = UILabel(frame: self.label.bounds)
        label.text = self.label.text
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .Center
        
        switch self.blurEffectStyle {
        case .Dark:
            label.textColor = UIColor(white: 0.6, alpha: 1.0)
            
        case .Light, .ExtraLight:
            label.textColor = UIColor(white: 0.4, alpha: 1.0)
        }
        
        return label
        
        }()
    
    
    @lazy var blurView :UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: self.blurEffectStyle)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame = self.label.frame
        
        
        
        return view
        }()
    
    @lazy var vibrancyView :UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: self.blurEffectStyle)
        let vibrancy = UIVibrancyEffect(forBlurEffect: blurEffect)
        let view = UIVisualEffectView(effect: vibrancy)
        view.frame = self.label.bounds
        
        return view
        }()
}
