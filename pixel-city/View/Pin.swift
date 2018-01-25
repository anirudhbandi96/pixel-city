//
//  Pin.swift
//  pixel-city
//
//  Created by Anirudh Bandi on 1/22/18.
//  Copyright © 2018 Caleb Stultz. All rights reserved.
//

import Foundation


import MapKit

class Pin: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        super.init()
    }
}
