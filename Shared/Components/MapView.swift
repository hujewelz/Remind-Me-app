//
//  MapView.swift
//  TODO
//
//  Created by luobobo on 2022/6/20.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var coordinate: CLLocationCoordinate2D?
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
        map.isZoomEnabled = true
        map.showsCompass = false
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let coordinate = coordinate {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            uiView.setRegion(region, animated: true)
            uiView.setCenter(coordinate, animated: false)
            
            let ano = MKPointAnnotation()
            ano.coordinate = coordinate
            ano.title = "location"
            ano.subtitle = "address detail"
            uiView.addAnnotation(ano)
            
            uiView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Marker")
        }
    }
    
    func makeCoordinator() -> Coordinate {
        Coordinate()
    }
    
    final class Coordinate: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "Marker", for: annotation)
            view.canShowCallout = true
            return view
        }
    }
}



struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: .constant(nil))
            .ignoresSafeArea()
    }
}
