//
//  MapView2ViewController.swift
//  WorldTrotter
//
//  Created by Manij Basnet on 30/01/2019.
//  Copyright © 2019 Basnet Inc. All rights reserved.
//

import UIKit
import MapKit

class MapView2ViewController: UIViewController {

    var mapView: MKMapView!
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        createSegmentControl()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapView2 loaded its view")
    }
    
    private func createSegmentControl(){
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(segmentedControl)
        
        segmentedControl.addTarget(self, action: #selector(MapView2ViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        setConstraints(segmentedControl)
    }
    
    private func setConstraints(_ control : UISegmentedControl){
        let margins = view.layoutMarginsGuide
        
        control.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = control.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leftConstraint = control.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let rightConstraint = control.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leftConstraint.isActive = true
        rightConstraint.isActive = true
    }
    
    @objc private func mapTypeChanged(_ segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
}
