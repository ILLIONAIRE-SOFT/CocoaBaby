//
//  CaptureBabyViewController.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 22..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class CaptureBabyViewController: UIViewController {

    
    var selectedImage = UIImage()
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var saveToDeviceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false

        self.imageView.image = selectedImage
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.isUserInteractionEnabled = false
        
        captureAnimataion()
    }

    
    @IBAction func share(_ sender: Any) {
        let activityItem: [AnyObject] = [self.imageView.image as AnyObject]
        
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)

        self.present(avc, animated: true, completion: nil)
    }
    
    @IBAction func saveToDevice(_ sender: Any) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            showSuccessToastMessage()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func captureAnimataion()  {
        let captureWhiteView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        captureWhiteView.backgroundColor = .white
        self.view.addSubview(captureWhiteView)
        captureWhiteView.isHidden = true
        UIView.animate(withDuration: 1.2, animations: {
            captureWhiteView.alpha = 0
        }) { (isCompleted) in
            captureWhiteView.isHidden = true
        }
    }
    
    func showSuccessToastMessage()  {
        let message = UIView(frame: CGRect(x: 0, y: -40, width: self.view.frame.width, height: 40))
        message.backgroundColor = UIColor(colorWithHexValue: 0xFFFFFF)
        
        let label = UILabel(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 20))
        label.textAlignment = .center
        label.text = "Saved"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13)
        message.addSubview(label)
        
        UIApplication.shared.keyWindow?.addSubview(message)
        
        UIView.animate(withDuration: 0.5, animations: {
            message.frame.origin.y += message.frame.height
        }) { (isCompleted) in
            UIView.animateKeyframes(withDuration: 0.5, delay: 1, animations: {
                message.frame.origin.y -= message.frame.height
            })
        }
    }
}
