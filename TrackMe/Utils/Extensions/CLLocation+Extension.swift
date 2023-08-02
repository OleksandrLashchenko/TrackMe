//
//  CLLocation+Extension.swift
//  TrackMe
//
//  Created by RX on 8/2/23.
//

import Foundation
import CoreLocation

extension CLLocation {
    func isEqual(location: CLLocation?) -> Bool {
        guard let location = location else { return false}
        return ( self.coordinate.latitude == location.coordinate.latitude &&
                 self.coordinate.longitude == location.coordinate.longitude )
    }
}
