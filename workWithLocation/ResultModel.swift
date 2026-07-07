//
//  ResultModel.swift
//  workWithLocation
//
//  Created by Avelina Maksimchik on 06.07.2026.
//

import Foundation
import MapKit

struct Place: Identifiable {
    let id: UUID = UUID()
    let name: String
    let placemark: MKPlacemark
    let coordinate: CLLocationCoordinate2D
    let address: String
}
