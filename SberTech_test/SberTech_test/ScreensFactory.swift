//
//  ScreensFactory.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 07/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import UIKit

struct ScreensFactory {
    
    static func mainScreen(context: Any?) -> MainController {
        let model = MainViewModel(context: context)
        let controller = MainController(viewModel: model)
        return controller
    }
}
