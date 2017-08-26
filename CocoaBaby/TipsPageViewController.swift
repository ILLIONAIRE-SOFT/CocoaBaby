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
    var order : Int!
    var pageIsAnimating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageIsAnimating = false
        self.dataSource = self
        self.delegate = self
        order = setOrder()
        
        let initialViewController = self.unusedViewController()
        
        self.setViewControllers([ initialViewController ], direction: .forward, animated: true,completion: { bool in
            initialViewController.view.frame = CGRect(x: -10, y: -30, width: 355, height: 578)
            initialViewController.order = self.order
            initialViewController.tipTitle.text = TipsStore.shared.Tips[self.order]?.title
            initialViewController.segmentedControl.selectedSegmentIndex = 0
            initialViewController.segmentedControl.addTarget(initialViewController, action: #selector(initialViewController.tipTargetChanged(segControl:)), for: .valueChanged)
            initialViewController.tipTargetChanged(segControl: initialViewController.segmentedControl)
        })
    }

    // Tips pageView에서 재사용되는 뷰를 만들기 위함. 만약 reusableViewControllers set에 남은 것이 있으면 그것을 사용하고
    // 없으면 새로 만듦.
    
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
    
    func setOrder() -> Int {
        if UserDefaults.standard.object(forKey: "savedLastPage" ) == nil {
            UserDefaults.standard.set(1, forKey: "savedLastPage")
        }
        return UserDefaults.standard.integer(forKey: "savedLastPage")
    }
}



extension TipsPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    // 이전 페이지와 이후 페이지를 만들어줌.

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousViewController = unusedViewController()
        let previousPageIndex = order - 1
        
        if pageIsAnimating {
            return nil
        }
        
        guard previousPageIndex > 0 else {
            return nil
        }
        
        previousViewController.order = previousPageIndex
        return previousViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        if pageIsAnimating {
            return nil
        }

        let nextViewController = unusedViewController()
        let nextPageIndex = order + 1
        
        guard nextPageIndex <= TipsStore.shared.Tips.count else {
            return nil
        }
        
        nextViewController.order = nextPageIndex
        return nextViewController
    }
    
    // 애니메이션 중간에는 transaction 막기 위해서
    // pageIsAnimating이 true인 상태에서는 페이지 변환이 일어나지 않음.
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pageIsAnimating = true
    }
    
    
    // 애니메이션이 끝난 뒤에 현재 보여지는 week를 1개씩 늘림 && pageIsAnimating를 false 로 만들어줌.
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let previousViewControllers = previousViewControllers.first! as! TipsDetailViewController

        let currentViewControllers = pageViewController.viewControllers?.first! as! TipsDetailViewController
        
        
        
        if finished || completed{
            pageIsAnimating = false
            if let previousOrder = previousViewControllers.order,
                let currentOrder = currentViewControllers.order {
                if previousOrder < currentOrder {
                    self.order? += 1
                    UserDefaults.standard.set(self.order, forKey: "savedLastPage")
                } else if previousOrder > currentOrder {
                    self.order? -= 1
                    UserDefaults.standard.set(self.order, forKey: "savedLastPage")
                }
            }
        }

    }
}
