//
//  BaseNavigationViewController.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    
    enum Style {
        case solid
        case transparent
        
        var preferredStatusBarStyle: UIStatusBarStyle {
            
            switch self {
            case .solid:
                return .`default`
            case .transparent:
                return .lightContent
            }
        }
    }
    
    internal var shouldRotate = false
    internal var style: Style = .solid {
        didSet {
            if style == .transparent {
                
                navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationBar.shadowImage = UIImage()
                navigationBar.isTranslucent = true
                navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                navigationBar.tintColor = UIColor.white
                view.backgroundColor = .clear
                
            } else {
                
                navigationBar.setBackgroundImage(nil, for: .default)
                navigationBar.shadowImage = nil
                navigationBar.isTranslucent = false
                navigationBar.barTintColor = UIColor.customBlue
                navigationBar.tintColor = UIColor.white
                navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupOnLoad()
    }
    
    private func setupOnLoad() {
        
        // replace back button
        self.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "ic_back")
        self.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "ic_back")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style.preferredStatusBarStyle
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override var shouldAutorotate: Bool {
        return shouldRotate
    }
}
