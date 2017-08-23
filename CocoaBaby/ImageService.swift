//
//  ImageService.swift
//  TravelCam
//
//  Created by LEOFALCON on 2017. 8. 5..
//  Copyright © 2017년 LeFal. All rights reserved.
//

import Foundation
import UIKit
import CoreImage



class ImageService  {
    
    static func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = image.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }
        
        return nil
    }
    
    static func merge(image : UIImage, cameraViewLabel : UILabel, cameraViewWidth : CGFloat, babyNameViewLabel : UILabel) -> UIImage? {
        
        let expandRatio: CGFloat = image.size.width/cameraViewWidth
        let leftMargin: CGFloat = expandRatio * 16
        
        UIGraphicsBeginImageContext(image.size)
        let imageAreaSize = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        image.draw(in: imageAreaSize)
        
        // MARK: WeekLabel
        let weekLabel = UILabel()
        weekLabel.text = cameraViewLabel.text
        weekLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40 * expandRatio)
        weekLabel.sizeToFit()
        
        weekLabel.textColor = UIColor.white
        
        let weekLabelWidth: CGFloat = weekLabel.intrinsicContentSize.width
        let weekLabelHeight: CGFloat = weekLabel.intrinsicContentSize.height
        
        let weekLabelPointX: CGFloat = leftMargin
        let weekLabelPointY: CGFloat = 16 * expandRatio
        
        let weekLabelRect = CGRect(x: weekLabelPointX, y: weekLabelPointY, width: weekLabelWidth, height: weekLabelHeight)
        
        weekLabel.frame = weekLabelRect
        
        // MARK: Separator
        let separatorLabel = UILabel()
        separatorLabel.backgroundColor = .white
        
        let separatorWidth: CGFloat = weekLabel.intrinsicContentSize.width
        let separatorHeight: CGFloat = 0.5 * expandRatio
        
        let separatorPointX: CGFloat = leftMargin
        let separatorPointY: CGFloat = weekLabel.frame.maxY + (4 * expandRatio)
        
        let separatorRect: CGRect = CGRect(x: separatorPointX, y: separatorPointY, width: separatorWidth, height: separatorHeight)
        
        separatorLabel.frame = separatorRect
        
        // MARK: babyNameLabel
        let babyNameLabel = UILabel()
        babyNameLabel.text = babyNameViewLabel.text
        babyNameLabel.textAlignment = .left
        babyNameLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20 * expandRatio)
        
        babyNameLabel.textColor = UIColor.white
        
        let babylabelWidth: CGFloat = babyNameLabel.intrinsicContentSize.width
        let babylabelHeight: CGFloat = babyNameLabel.intrinsicContentSize.height
        
        let babylabelPointX: CGFloat = leftMargin
        let babylabelPointY: CGFloat = separatorLabel.frame.maxY + (4 * expandRatio)
        let babylabelRect = CGRect(x: babylabelPointX, y: babylabelPointY, width: babylabelWidth, height: babylabelHeight)
        
        babyNameLabel.frame = babylabelRect
        
        // MARK: Image draw
        let weekLabelImage = UIImage.imageWithLabel(label: weekLabel)
        let babylabelImage = UIImage.imageWithLabel(label: babyNameLabel)
        let separatorImage = UIImage.imageWithLabel(label: separatorLabel)
        
        weekLabelImage.draw(in: weekLabelRect)
        babylabelImage.draw(in: babylabelRect)
        separatorImage.draw(in: separatorRect)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
        
        return newImage
    }
}

extension UIImage {
    class func imageWithLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
