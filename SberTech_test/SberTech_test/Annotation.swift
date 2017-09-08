//
//  Annotation.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 08/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import MapKit

class Annotation: NSObject, MKAnnotation {
    
    let identifier: Int
    
    init(coordinate: CLLocationCoordinate2D, identifier: Int, title: String? = nil, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
    }
    
    convenience init(latitude: Double, longitude: Double, identifier: Int, title: String? = nil, subtitle: String? = nil) {
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        self.init(coordinate: coordinate, identifier: identifier, title: title, subtitle: subtitle)
    }
    
    // MARK: - MKAnnotation
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
}
