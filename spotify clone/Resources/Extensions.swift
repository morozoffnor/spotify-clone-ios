//
//  Extensions.swift
//  spotify clone
//
//  Created by Игорь Морозов on 22.08.2021.
//

import Foundation
import UIKit

// This is the extension just for my sanity's sake
// so I wont need to type "frame.size.width" every
// time to get width and so on. Math should be
// pretty simple

extension UIView {
    
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
}
