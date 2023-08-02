//
//  TMLocationManager.swift
//  TrackMe
//
//  Created by RX on 8/2/23.
//

import Foundation
import CoreLocation

class TMLocationManager: NSObject {
    
    static let shared = TMLocationManager()
    
    private var manager: CLLocationManager
    private var lastLocation: CLLocation?
    
    /// Observers
    private var locationObserver: ((CLLocation, Double) -> Void)?
    private var exceptionObserver: ((Error) -> Void)?
    
    /// The minimum distance in meters the device must move horizontally before an update event is generated.
    private let significantMeters: Double = 5
    
    public var authorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return self.manager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    override init() {
        self.manager = CLLocationManager()
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.distanceFilter = significantMeters
        self.manager.requestAlwaysAuthorization()
        self.manager.allowsBackgroundLocationUpdates = true
        self.manager.pausesLocationUpdatesAutomatically = false
        self.manager.showsBackgroundLocationIndicator = true
        super.init()
        self.manager.delegate = self
    }
}

// MARK: - Public functions
extension TMLocationManager {
    func requestAuthorization() {
        self.manager.requestAlwaysAuthorization()
    }
    
    func requestLocation() {
        self.manager.requestLocation()
    }
    
    func startLocationTracking() {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            self.manager.startUpdatingLocation()
        }
    }
    
    func stopLocationTracking() {
        self.manager.stopUpdatingLocation()
    }
    
    func addObservers(locationObserver: @escaping (CLLocation, Double) -> Void,
                      exceptionObserver: @escaping (Error) -> Void) {
        self.locationObserver = locationObserver
        self.exceptionObserver = exceptionObserver
    }
    
    func removeObservers() {
        self.locationObserver = nil
        self.exceptionObserver = nil
    }
}

// MARK: - Private functions
extension TMLocationManager {
    private func checkLocationChanges(currentLocation: CLLocation) {
        guard !currentLocation.isEqual(location: lastLocation) else { return }
        
        var movedDistance: Double = 0
        if let lastLocation = lastLocation {
            let distance = currentLocation.distance(from: lastLocation)
            if distance > significantMeters {
                movedDistance = distance
            }
        }
        
        self.locationObserver?(currentLocation, movedDistance)
        lastLocation = currentLocation
    }
}

// MARK: - CLLocationManagerDelegate
extension TMLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            let error: CLError = .init(_nsError: .init(domain: "location", code: 0))
            self.exceptionObserver?(error)
            return
        }

        self.checkLocationChanges(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.exceptionObserver?(error)
    }
}
