//
//  TabGroups.swift
//
//  Created by Emily Ivie on 9/23/15.
//  Copyright © 2015 urdnot.

//  Licensed under The MIT License
//  For full copyright and license information, please see http://opensource.org/licenses/MIT
//  Redistributions of files must retain the above copyright notice.

//

import UIKit

// implemented by tab groups top-level page
public protocol TabGroupsControllable: class, UIPageViewControllerDataSource, UIPageViewControllerDelegate {//, UINavigationControllerDelegate {

    // implement in controller:
    var tabs: UIHeaderTabs! { get } // @IBOutlet
    var pageControllerWrapper: UIView! { get } // @IBOutlet
    var controllerStoryboards: [String] { get }
    var orderedGroups: [String] { get }
    var pageViewController: UIPageViewController? { get set }
    var controllers: [UIViewController] { get set }
    var currentIndex: Int { get set }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    
    // call this element in viewDidLoad(), after setting up orderedGroups and controllerStoryboards
    func setupTabGroups()

    // public, but require no additional code in implementing controller
    func handlePageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    func handlePageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    func handlePageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    func switchToPage(controller: UIViewController)
}

extension TabGroupsControllable where Self: UIViewController {
    
    public func setupTabGroups() {
        setupGroups()
        setupPageControl()
        setupPageViewController()
    }
    
    private func setupGroups() {
        for (index, group) in orderedGroups.enumerate() {
            let storyboardObj = UIStoryboard(name: controllerStoryboards[index], bundle: NSBundle.mainBundle())
            if let viewController = storyboardObj.instantiateInitialViewController() {
                if let groupController = viewController as? TabGroupControllable {
                    groupController.group = group
                    groupController.groupIndex = index
                    groupController.groupsController = self
                }
                controllers.append(viewController)
            }
        }
    }

    private func setupPageViewController() {
        let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([controllers[currentIndex] as UIViewController], direction: .Forward, animated: false, completion: nil)
        pageViewController.willMoveToParentViewController(self)
        self.addChildViewController(pageViewController)
        pageViewController.didMoveToParentViewController(self)
        pageControllerWrapper.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.leadingAnchor.constraintEqualToAnchor(pageControllerWrapper.leadingAnchor).active = true
        pageViewController.view.trailingAnchor.constraintEqualToAnchor(pageControllerWrapper.trailingAnchor).active = true
        pageViewController.view.topAnchor.constraintEqualToAnchor(pageControllerWrapper.topAnchor).active = true
        pageViewController.view.bottomAnchor.constraintEqualToAnchor(pageControllerWrapper.bottomAnchor).active = true
        self.pageViewController = pageViewController
    }

    private func setupPageControl() {
        tabs.segments = orderedGroups.count
        tabs.segmentTitles = orderedGroups.map{ $0 }.joinWithSeparator(",")
        tabs.selectedSegmentIndex = currentIndex
        tabs.onClick = { [weak self] index in
            self?.switchToPage(controllers[index])
        }
    }

    public func handlePageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        if let controller = viewController as? TabGroupControllable {
            let prevIndex = controller.groupIndex - 1
            if 0..<controllers.count ~= prevIndex {
                let prevController = controllers[prevIndex]
                return prevController
            }
        }
        return nil
    }

    public func handlePageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

        if let controller = viewController as? TabGroupControllable {
            let nextIndex = controller.groupIndex + 1
            if 0..<controllers.count ~= nextIndex {
                let nextController = controllers[nextIndex]
                return nextController
            }
        }
        return nil
    }

    public func handlePageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    
        if completed {
            if let controller = pageViewController.viewControllers?.last as? TabGroupControllable {
                currentIndex = controller.groupIndex
            }
            tabs.selectedSegmentIndex = currentIndex
        }
    }
    
    public func switchToPage(controller: UIViewController) {
        var direction = UIPageViewControllerNavigationDirection.Forward
        if let groupController = controller as? TabGroupControllable {
            if groupController.groupIndex == currentIndex {
//                return //?
            }
            direction = groupController.groupIndex > currentIndex ? .Forward : .Reverse
            currentIndex = groupController.groupIndex
            tabs.selectedSegmentIndex = currentIndex
        }
        pageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: { finished in
            dispatch_async(dispatch_get_main_queue(), {
                self.pageViewController?.setViewControllers([controller], direction: .Forward, animated: false, completion: nil)
            })
        })
    }
}