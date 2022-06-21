//
//  Geocode.swift
//  TODO
//
//  Created by luobobo on 2022/6/21.
//

import Foundation
import CoreLocation

final class Geocoder: ObservableObject {

    @Published private(set) var isGeocoding = false
//    @Published private(set) var locations: [CLLocation] = []
//    @Published private(set) var currentCoordinate: CLLocationCoordinate2D?
    
    private let geo: CLGeocoder
    
    init() {
        geo = CLGeocoder()
    }
    
    @MainActor
    func geocode(address: String) async -> CLLocationCoordinate2D? {
        isGeocoding = true
        defer {
            isGeocoding = false
        }
     
        do {
            let result = try await geo.geocodeAddressString(address)
            let locations = result.filter { $0.location != nil }.map { $0.location! }
            return locations.first?.coordinate
        } catch {
            print("geocode with error: ", error)
        }
        return nil
    }
}
