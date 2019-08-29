//
//  MMBNavigationController.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/7/30.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit

class MMBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }

}
