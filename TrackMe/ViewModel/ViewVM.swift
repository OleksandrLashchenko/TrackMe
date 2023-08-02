//
//  ViewVM.swift
//  TrackMe
//
//  Created by RX on 8/2/23.
//

import Foundation
import CoreLocation

protocol ViewVMDelegate: AnyObject {
    func didUpdateLocation(location: CLLocation)
    func didMoveInMeters(distance: Double)
    func didFail(error: Error)
}

class ViewVM: NSObject {
    
    weak var delegate: ViewVMDelegate?
    
    init(delegate: ViewVMDelegate? = nil) {
        self.delegate = delegate
        super.init()
        TMLocationManager.shared.addObservers { [self] (location, distance) in
            self.delegate?.didUpdateLocation(location: location)
            self.delegate?.didMoveInMeters(distance: distance)
        } exceptionObserver: { [self] (error) in
            self.delegate?.didFail(error: error)
        }
    }
    
    func requestLocation() {
        TMLocationManager.shared.requestLocation()
    }
    
    func startTrack() {
        TMLocationManager.shared.startLocationTracking()
    }
    
    func stopTrack() {
        TMLocationManager.shared.stopLocationTracking()
    }
    
    deinit {
        stopTrack()
        TMLocationManager.shared.removeObservers()
    }
    
}
