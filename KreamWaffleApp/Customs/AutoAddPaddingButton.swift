//
//  AutoAddPaddingButton.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/21.
//

import Foundation
import UIKit

class AutoAddPaddingButtton : UIButton
{
    override var intrinsicContentSize: CGSize {
       get {
           let baseSize = super.intrinsicContentSize
           return CGSize(width: baseSize.width + 20,//ex: padding 20
                         height: baseSize.height)
           }
    }
}
