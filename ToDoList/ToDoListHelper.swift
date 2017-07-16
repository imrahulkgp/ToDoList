//
//  ToDoListHelper.swift
//  ToDoList
//
//  Created by Rahul Gupta on 16/07/17.
//  Copyright © 2017 SRS. All rights reserved.
//

import Foundation
import UIKit

class ToDoListHelper: NSObject {
    
    class func barItemWithImage(image: UIImage, highlightedImage: UIImage, forFrame rect: CGRect, withPadding padding: CGFloat, isLeftBarButton isleftBarButton: Bool, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.frame = rect
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.imageEdgeInsets = isleftBarButton ? UIEdgeInsetsMake(0, -padding, 0, padding) : button.imageEdgeInsets
        let customUIBarButtonItem = UIBarButtonItem(customView: button)
        return customUIBarButtonItem
    }
    
}
