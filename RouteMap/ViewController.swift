//
//  ViewController.swift
//  RouteMap
//
//  Created by MAC on 28/01/22.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locations = [Location]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let location1 = Location(latitide: 9.9312, longitude: 76.2673, name: "Kochi", subtitle: "Hey")
        let location2 = Location(latitide: 11.0168, longitude: 76.9558, name: "Coimbatore", subtitle: "")
        let location3 = Location(latitide: 9.9252, longitude: 78.1198, name: "Madurai", subtitle: "")
        let location4 = Location(latitide: 10.0889, longitude: 77.0595, name: "Munnar", subtitle: "")
        let location5 = Location(latitide: 9.9312, longitude: 76.2673, name: "Kochi", subtitle: "")
        
        locations.append(location1)
        locations.append(location2)
        locations.append(location3)
        locations.append(location4)
        locations.append(location5)
        
        for i in 0..<locations.count - 1{
            
            let startLocation = locations[i]
            let endLocation = locations[i+1]
            
            loadMap(startLocation: startLocation, endLocation: endLocation)
            
        }
        
    }
    
    
    func loadMap (startLocation: Location, endLocation: Location) {
        
        let sourceLocation = CLLocationCoordinate2D(latitude:startLocation.latitide , longitude: startLocation.longitude)
        let destinationLocation = CLLocationCoordinate2D(latitude:endLocation.latitide , longitude: endLocation.longitude)
        
        let sourcePin = customPin(pinTitle: startLocation.name, pinSubTitle: startLocation.subtitle, location: sourceLocation)
        let destinationPin = customPin(pinTitle: endLocation.name, pinSubTitle: endLocation.subtitle, location: destinationLocation)
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            //get route and assign to our route variable
            let route = directionResonse.routes[0]
            
            //add rout to our mapview
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            //setting rect of our mapview to fit the two locations
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            
        }
        
        
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
}

