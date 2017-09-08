//
//  PinView.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 08/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import MapKit

class PinView: MKPinAnnotationView {
    
    override var isSelected: Bool {
        didSet {
            pinTintColor = isSelected ? .sb_green : .sb_red
        }
    }
}
