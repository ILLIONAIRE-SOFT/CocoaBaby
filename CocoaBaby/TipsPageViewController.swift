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
    var pageIsAnimating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageIsAnimating = false
        self.dataSource = self
        self.delegate = self
        let initialViewController = self.unusedViewController()
        
        self.setViewControllers([ initialViewController ],
                                direction: .forward,
                                animated: false,
                                completion: nil)
        initialViewController.week = self.weekIndex
    }

    func unusedViewController() -> TipsDetailViewController {
        let unusedViewControllers = reusableViewControllers.filter { $0.parent == nil }
        if let someUnusedViewController = unusedViewControllers.last {
            return someUnusedViewController
        } else {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "TipsDetailViewController") as! TipsDetailViewController
            reusableViewControllers.insert(newViewController)
            return newViewController
        } 
    }
}


extension TipsPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousViewController = unusedViewController()
        let previousPageIndex = weekIndex - 1
        
        if pageIsAnimating {
            return nil
        }
        
        guard previousPageIndex > 0 else {
            return nil
        }
        
        previousViewController.week = previousPageIndex
        
        return previousViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        if pageIsAnimating {
            return nil
        }

        let nextViewController = unusedViewController()
        let nextPageIndex = weekIndex + 1
        
        guard nextPageIndex < 41 else {
            return nil
        }
        
        nextViewController.week = nextPageIndex
        return nextViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pageIsAnimating = true
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let previousViewControllers = previousViewControllers.first! as! TipsDetailViewController

        let currentViewControllers = pageViewController.viewControllers?.first! as! TipsDetailViewController
        
        
        if finished || completed{
            pageIsAnimating = false
            if let previousWeek = previousViewControllers.week,
                let currentWeek = currentViewControllers.week {
                print("\(previousWeek),, \(currentWeek)")
                
                if previousWeek < currentWeek {
                    self.weekIndex += 1
                } else if previousWeek > currentWeek {
                    self.weekIndex -= 1
                }
            }
        }

    }
}
