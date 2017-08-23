//
//  CaptureBabyViewController.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 22..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class CaptureBabyViewController: UIViewController {

    @IBOutlet var viewTitle: UILabel!
    @IBOutlet var captureByRectangle: UIButton!
    @IBOutlet var captureBySquare: UIButton!
    
    var squareImage = UIImage()
    var rectangleImage = UIImage()
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var saveToDeviceButton: UIButton!
    
    let captureWhiteView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false

        
        captureByRectangle.layer.cornerRadius = captureByRectangle.frame.width/2
        captureBySquare.layer.cornerRadius = captureBySquare.frame.width/2
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.alpha = 0
        self.shareButton.alpha = 0
        self.saveToDeviceButton.alpha = 0
        
        captureWhiteView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        captureWhiteView.backgroundColor = .white
        self.view.addSubview(captureWhiteView)
        captureWhiteView.isHidden = true
    }

    @IBAction func selectNormal(_ sender: Any) {
        captureWhiteView.isHidden = false
        
        UIView.animate(withDuration: 1.2, animations: {
            self.captureWhiteView.alpha = 0
        }) { (isCompleted) in
            self.captureWhiteView.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5) {
            self.viewTitle.alpha = 0
            self.captureByRectangle.alpha = 0
            self.captureBySquare.alpha = 0
            self.imageView.alpha = 1
            self.shareButton.alpha = 1
            self.saveToDeviceButton.alpha = 1
        }
        imageView.image = rectangleImage
    }
    
    @IBAction func selectSqure(_ sender: Any) {
        captureWhiteView.isHidden = false
        
        UIView.animate(withDuration: 1.2, animations: {
            self.captureWhiteView.alpha = 0
        }) { (isCompleted) in
            self.captureWhiteView.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5) {
            self.viewTitle.alpha = 0
            self.captureByRectangle.alpha = 0
            self.captureBySquare.alpha = 0
            self.imageView.alpha = 1
            self.shareButton.alpha = 1
            self.saveToDeviceButton.alpha = 1
        }
        imageView.image = squareImage
    }
    
    @IBAction func share(_ sender: Any) {
        let activityItem: [AnyObject] = [self.imageView.image as AnyObject]
        
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        
        self.present(avc, animated: true, completion: nil)
    }
    
    @IBAction func saveToDevice(_ sender: Any) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
