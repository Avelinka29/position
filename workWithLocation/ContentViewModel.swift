//
//  ContentViewModel.swift
//  workWithLocation
//
//  Created by Avelina Maksimchik on 06.07.2026.
//
import Foundation
import MapKit
internal import Combine

class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManeger: CLLocationManager?
    
    var searchTerm = ""
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    
    @Published private(set)var places = [Place]()
    @Published private(set) var selectedPlace: Place?
    
    
    var selectedPlaceName: String {
        guard let selectedPlace = selectedPlace else {return ""}
        return selectedPlace.name
    }
    
    var selectedPlaceAdress: String {
        guard let selectPlace = selectedPlace else {return ""}
        if let street = selectPlace.placemark.thoroughfare,
           let subAdress = selectPlace.placemark.subThoroughfare {
            return street + ", " + subAdress
        }
        return ""
    }
    
    
    
    // 1 - проверить доступ к локации
    
    func checkLocationIsEnable() {
        if CLLocationManager.locationServicesEnabled() {
            locationManeger = CLLocationManager()
            locationManeger?.delegate = self
        } else {
            print("alert")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
    
    // 2 - проверка прав, которые нам предоставлены
    
    private func checkLocationAuth() {
        guard let locationManager = locationManeger else {return}
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            print("Ограничен доступ")
            
        case .denied:
            print("Не предоставлен доступ2")
        case . authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span:
                                            MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            @unknown default:
            break
        }
    }
    
    
    // 3 - функция поиска
    
    func search(){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTerm
        request.region = region
        
        let search = MKLocalSearch(request: request)
        
        search.start {responce, err in
            guard let responce = responce else {return}
            
            DispatchQueue.main.async {
                self.places = responce.mapItems.map({item in
                    Place(name: item.name ?? "", placemark: item.placemark, coordinate: item.placemark.coordinate, address: item.placemark.locality ?? "")})
            }
            
        }
        
    }
    
    // 4 - selected place
    
    func selectedPlace(for place: Place){
        self.selectedPlace = place
    }
    
}


