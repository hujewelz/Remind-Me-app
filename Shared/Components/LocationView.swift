//
//  LocationView.swift
//  TODO
//
//  Created by luobobo on 2022/6/20.
//

import SwiftUI
import CoreLocation

// CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417)
struct LocationView: View {
    @State private var location = ""
    @StateObject private var geocoder = Geocoder()
    @State private var currentCoordinate: CLLocationCoordinate2D? = .init(latitude: 37.785834, longitude: -122.406417)
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                MapView(coordinate: $currentCoordinate)
                    
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.secondary)
                    TextField("Enter Location", text: $location)
                        .onSubmit {
                            currentCoordinate = nil
                            Task {
                                currentCoordinate = await geocoder.geocode(address: "浙江省杭州市上城区九堡街道蓝桥名苑6幢")
                            }
                        }
                }
                .padding(.horizontal, 16)
                .frame(width: proxy.size.width - 32, height: 44)
                .background(Pallet.systemBackground)
                .cornerRadius(22)
                .offset(y: proxy.safeAreaInsets.top + 15)
                
                
                HStack {
                    Text("Location services is off").font(.callout.bold())
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.orange)
                .foregroundColor(Color.white)
                .cornerRadius(40)
                .offset(y: proxy.size.height)
                .onTapGesture {
                    if let bundleId = Bundle.main.bundleIdentifier,
                        let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
