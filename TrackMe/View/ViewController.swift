//
//  ViewController.swift
//  TrackMe
//
//  Created by RX on 8/2/23.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private let vm = ViewVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vm.delegate = self
        
        mapView.showsUserLocation = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vm.requestLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [self] in
            vm.startTrack()
        }
    }
    
}

extension ViewController: ViewVMDelegate {
    func didUpdateLocation(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        self.mapView.setRegion(region, animated: true)
    }
    
    func didMoveInMeters(distance: Double) {
        print("ViewController:: Did move \(distance) meters")
    }
    
    func didFail(error: Error) {
        print("ViewController:: Error -\(error.localizedDescription)")
    }
}

