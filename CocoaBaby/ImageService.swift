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
        
        UIGraphicsBeginImageContext(image.size)
        let imageAreaSize = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        image.draw(in: imageAreaSize)
        
        // MARK: WeekLabel
        let label = UILabel()
        label.text = cameraViewLabel.text
        label.textAlignment = .left
        label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40 * image.size.width/cameraViewWidth)
        
        label.textColor = UIColor.white
        
        let labelWidth : CGFloat = label.intrinsicContentSize.width * 1.5
        let labelHeight : CGFloat = label.intrinsicContentSize.height * 1.5
        
        let labelPointX : CGFloat = image.size.width/2 - (labelWidth/2)*2.1 + 200
        let labelPointY : CGFloat = image.size.height/50
        let labelRect = CGRect(x: labelPointX, y: labelPointY, width: labelWidth, height: labelHeight)
        
        label.frame = labelRect
        
        // MARK: babyNameLabel
        let babyNameLabel = UILabel()
        babyNameLabel.text = babyNameViewLabel.text
        babyNameLabel.textAlignment = .left
        babyNameLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20 * image.size.width/cameraViewWidth)
        
        babyNameLabel.textColor = UIColor.white
        
        let babylabelWidth : CGFloat = babyNameLabel.intrinsicContentSize.width * 1.5
        let babylabelHeight : CGFloat = babyNameLabel.intrinsicContentSize.height * 1.5
        
        let babylabelPointX : CGFloat = image.size.width/2 - (labelWidth/2)*2.1 + 200
        let babylabelPointY : CGFloat = image.size.height/5 - 100
        let babylabelRect = CGRect(x: babylabelPointX, y: babylabelPointY, width: babylabelWidth, height: babylabelHeight)
        
        babyNameLabel.frame = babylabelRect
        
        // MARK: LineDrawing
        let weeklabelWidth : CGFloat = label.intrinsicContentSize.width
        
        let labelImage = UIImage.imageWithLabel(label: label)
        let babylabelImage = UIImage.imageWithLabel(label: babyNameLabel)
        
        labelImage.draw(in: labelRect)
        babylabelImage.draw(in: babylabelRect)
        
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
