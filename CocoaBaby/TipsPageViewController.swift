//
//  TipsPageViewController.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 11..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class TipsPageViewController: UIPageViewController {

    private var reusableViewControllers = Set<TipsDetailViewController>()
    var weekIndex = BabyStore.shared.getPregnantWeek().week
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        let initialViewController = self.unusedViewController()
        
        
        self.setViewControllers([ initialViewController ],
                                direction: .forward,
                                animated: false,
                                completion: nil)
        initialViewController.weekTitle.text = String(weekIndex)
    }

    func unusedViewController() -> TipsDetailViewController {
        let unusedViewControllers = reusableViewControllers.filter { $0.parent == nil }
        if let someUnusedViewController = unusedViewControllers.last {
            return someUnusedViewController
        } else {
            let newViewController = TipsDetailViewController()
            reusableViewControllers.insert(newViewController)
            return newViewController
        } 
    }
}


extension TipsPageViewController: UIPageViewControllerDataSource {
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousViewController = unusedViewController()
        
        let previousPageIndex = weekIndex - 1
        
        guard previousPageIndex > 0 else {
            return nil
        }
        
        previousViewController.weekTitle.text = String(previousPageIndex)
        
        self.weekIndex -= 1
        return previousViewController
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        let nextViewController = unusedViewController()
        
        let nextPageIndex = weekIndex + 1
        
        guard nextPageIndex < 41 else {
            return nil
        }
        
        nextViewController.weekTitle.text = String(nextPageIndex)
        
        self.weekIndex += 1
        return nextViewController
        
    }
}
