//
//  WelcomeViewController.swift
//  LandmarkRemark
//
//  Created by Mira Kim on 20/05/19.
//  Copyright © 2019 mira. All rights reserved.
//

import Foundation
import UIKit

/**
    Intro page controller shows the pages with swipe gesture to go back and forth.
 */
class IntroPageController: UIPageViewController {
    
    /// Pages to show in the controller.
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "Page1"),
            self.getViewController(withIdentifier: "Page2")
        ]
    }()
    
    /// Helper method to instantiate the view controller from storyboard
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    fileprivate var pageControl = UIPageControl()
    
    private let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the data source and delegate to self
        // which is defined below in extensions
        self.dataSource = self
        self.delegate = self
        
        // set the first page
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        // configure the page control dots
        configurePageControl()
        
        // add observer to detect when setup completes successfully 
        notificationCenter.addObserver(self, selector: #selector(introCompleted), name: SetupCompletedNotification, object: nil)
    }
    
    /**
        Creates the page dots to show at the bottom of the screen
     */
    func configurePageControl() {
        // Create page control
        pageControl = UIPageControl(frame: CGRect(x: 0,
                                                  y: UIScreen.main.bounds.maxY - 50,
                                                  width: UIScreen.main.bounds.width,
                                                  height: 50))
        self.pageControl.numberOfPages = pages.count
        self.pageControl.currentPage = 0
        
        let palette = ColorPalette()
        self.pageControl.tintColor = palette.orange
        self.pageControl.pageIndicatorTintColor = palette.lightBlue
        self.pageControl.currentPageIndicatorTintColor = palette.orange
        self.view.addSubview(pageControl)
    }
    
    @objc func introCompleted() {
        LoggingUtility.debug("Setup is complete")
        performSegue(withIdentifier: "unwindSegueToSplash", sender: self)
    }
    
    
    deinit {
        // Removes self from observer list
        notificationCenter.removeObserver(self)
    }
}

// MARK: - UIPageViewControllerDataSource
extension IntroPageController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0,
            pages.count > previousIndex else {
                return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
}

// MARK: - UIPageViewControllerDelegate
extension IntroPageController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = pages.firstIndex(of: pageContentViewController)!
    }
    
    
}

