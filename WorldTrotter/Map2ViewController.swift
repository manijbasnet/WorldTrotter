//
//  MapView2ViewController.swift
//  WorldTrotter
//
//  Created by Manij Basnet on 30/01/2019.
//  Copyright © 2019 Basnet Inc. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Map2ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var margins: UILayoutGuide!
    
    var london: MKPointAnnotation!
    var leicester: MKPointAnnotation!
    var nottingham: MKPointAnnotation!
    var pastLocations: [MKPointAnnotation]!
    var currentPastLocationIndex: Int! = 0
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        margins = view.layoutMarginsGuide
        
        createSegmentControl()
        createLocateButton()
        createSwitchButton()
        setPastLocations()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestAlwaysAuthorization()
    }
    
    //MARK: Segment control logic
    
    private func createSegmentControl(){
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(segmentedControl)
        
        segmentedControl.addTarget(self, action: #selector(Map2ViewController.mapTypeChanged(_:)), for: .valueChanged)
        
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
    
    //MARK: Locate button logic
    
    func createLocateButton(){
        let locateButton = UIButton(type: .roundedRect)
        locateButton.setTitle("Locate Me", for: .normal)
        locateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locateButton)
        
        let bottomConstraint = locateButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        let centreConstraint = locateButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        
        bottomConstraint.isActive = true
        centreConstraint.isActive = true
        
        locateButton.addTarget(self, action: #selector(Map2ViewController.determineUserLocation), for: .touchDown)
    }
    
    @objc func determineUserLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
    }

    //MARK: Switch button logic
    
    func setPastLocations(){
        london = MKPointAnnotation()
        london.title = "London"
        london.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        
        leicester = MKPointAnnotation()
        leicester.title = "Leicester"
        leicester.coordinate = CLLocationCoordinate2D(latitude: 52.6369, longitude: -1.1398)
        
        nottingham = MKPointAnnotation()
        nottingham.title = "Nottingham"
        nottingham.coordinate = CLLocationCoordinate2D(latitude: 52.9548, longitude: -1.1581)
        
        pastLocations = [london, leicester, nottingham]
    }
    
    func createSwitchButton(){
        let switchButton = UIButton(type: .roundedRect)
        switchButton.setTitle("Switch", for: .normal)
        view.addSubview(switchButton)
        
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = switchButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        let trailingConstraint = switchButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        bottomConstraint.isActive = true
        trailingConstraint.isActive = true
        
        switchButton.addTarget(self, action: #selector(Map2ViewController.goToNextPastLocation), for: .touchUpInside)
    }
    
    @objc func goToNextPastLocation(){
        let location = pastLocations[currentPastLocationIndex]
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(location)
        
        currentPastLocationIndex = (currentPastLocationIndex + 1) % pastLocations.count
    }

}
