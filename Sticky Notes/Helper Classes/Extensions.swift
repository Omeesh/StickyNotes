//
//  Inspectable.swift
//  Sticky Notes
//
//  Created by Omeesh Sharma on 10/07/20.
//  Copyright © 2020 Omeesh Sharma. All rights reserved.
//

import UIKit

extension UIView{
    
    //Rounded corners
    @IBInspectable var cornerRadius:CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
}
