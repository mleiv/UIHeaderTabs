//
//  UIHeaderTabs.swift
//
//  Created by Emily Ivie on 9/10/15.
//  Copyright © 2015 urdnot.

//  Licensed under The MIT License
//  For full copyright and license information, please see http://opensource.org/licenses/MIT
//  Redistributions of files must retain the above copyright notice.


import UIKit

@IBDesignable public class UIHeaderTabs: UIView {

    @IBInspectable public var segments: Int = 0 {
        didSet {
            if oldValue != segments && didSetup {
                setupTabs()
            }
        }
    }
    @IBInspectable public var segmentTitles: String = "" {
        didSet {
            if oldValue != segmentTitles && segmentTitles.characters.count > 0 && didSetup {
                setupTabs()
            }
        }
    }
    @IBInspectable public var selectedSegmentIndex: Int = 0 {
        didSet {
            if oldValue != selectedSegmentIndex && didSetup {
                setupTabs()
            }
        }
    }
    
    public var onClick: ((Int) -> Void)? {
        didSet {
            nib?.tabs.forEach {
                $0.onClick = onClick
            }

        }
    }
    
    internal var didSetup = false
    private var nib: UIHeaderTabsNib?
    
    public override func layoutSubviews() {
        if !didSetup {
            setupTabs()
        }
        super.layoutSubviews()
    }

    internal func setupTabs() {
        if nib == nil, let view = UIHeaderTabsNib.loadNib() {
            insertSubview(view, atIndex: 0)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
            view.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
            view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
            view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
            nib = view
        }
        if let view = nib {
            if segments != view.tabs.count {
                view.setupTabs(segments)
            }
            let titles = segmentTitles.componentsSeparatedByString(",")
            if titles.count == view.tabs.count {
                for (index, tab) in view.tabs.enumerate() {
                    tab.title = titles[index]
                }
            }
            for (index, tab) in view.tabs.enumerate() {
                tab.selected = selectedSegmentIndex == index ? true : false
                tab.onClick = onClick
            }
            didSetup = true
        }
    }
}

@IBDesignable public class UIHeaderTabsNib: UIView {
    
    @IBOutlet weak var sampleTabWrapper: UIView!
    @IBOutlet weak var sampleTabStack: UIStackView!
    public var tabs = [UIHeaderTab]()
    
    public func setupTabs(count: Int) {
        tabs = []
        for element in sampleTabStack.arrangedSubviews {
            element.removeFromSuperview()
        }
        let bundle = NSBundle(forClass: self.dynamicType)
        for index in 0..<count {
            if let tab =  bundle.loadNibNamed("UIHeaderTab", owner: self, options: nil)?.first as? UIHeaderTab {
                tab.title = "Tab \(index + 1)"
                tab.index = index
                tabs.append(tab)
                sampleTabStack.addArrangedSubview(tab)
            }
        }
        sampleTabWrapper.frame.size.height = tabs[0].frame.height
    }
    
    public class func loadNib() -> UIHeaderTabsNib? {
        let bundle = NSBundle(forClass: UIHeaderTabsNib.self)
        if let view = bundle.loadNibNamed("UIHeaderTabsNib", owner: self, options: nil)?.first as? UIHeaderTabsNib {
            return view
        }
        return nil
    }
}
 