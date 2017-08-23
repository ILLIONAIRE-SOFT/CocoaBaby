//
//  ShareImageService.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 23..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import Foundation
import UIKit

class ShareImageService {
    static func showShareViewController(presentViewController : UIViewController, image : UIImage?) {
        let shareSB = UIStoryboard(name: StoryboardName.share, bundle: nil)
        let captureBabyViewController = shareSB.instantiateViewController(withIdentifier: StoryboardName.captureBabyViewController) as! CaptureBabyViewController
        if let image = image {
            captureBabyViewController.selectedImage = image
        }
        captureBabyViewController.modalPresentationStyle = .overCurrentContext
        presentViewController.present(captureBabyViewController, animated: true, completion: nil)
    }
}
