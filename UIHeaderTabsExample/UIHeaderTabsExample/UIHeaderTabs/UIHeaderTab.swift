//
//  UIHeaderTab.swift
//
//  Created by Emily Ivie on 9/10/15.
//  Copyright © 2015 urdnot.

//  Licensed under The MIT License
//  For full copyright and license information, please see http://opensource.org/licenses/MIT
//  Redistributions of files must retain the above copyright notice.

import UIKit

@IBDesignable public class UIHeaderTab: UIView {
    
    @IBInspectable public var title: String = "Tab" {
        didSet {
            if oldValue != title {
                setupTab()
            }
        }
    }
    
    @IBInspectable public var selected: Bool = false {
        didSet {
            if oldValue != selected {
                setupTab()
            }
        }
    }
    
    @IBInspectable public var index: Int = 0 {
        didSet {
            if oldValue != index {
                setupTab()
            }
        }
    }
    
    public var onClick: ((Int) -> Void)?
    
    @IBOutlet weak var unselectedWrapper: UIView!
    @IBOutlet weak var selectedWrapper: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var selectedUnderline: UIView!
    
    @IBAction func onClick(sender: UIButton) {
        onClick?(index)
    }
    
    internal func setupTab() {
        label1.text = title
        label2.text = title
        unselectedWrapper.hidden = selected
        selectedWrapper.hidden = !selected
    }
}
 