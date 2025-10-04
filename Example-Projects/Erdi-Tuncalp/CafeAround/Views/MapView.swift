import MapKit
import SwiftUI

struct MapView: View {
    @ObservedObject var locationManager: LocationManager

    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedCafe: Cafe?
    @State private var route: MKRoute?

    var body: some View {
        Map(position: $cameraPosition, selection: $selectedCafe) {
            UserAnnotation()

            ForEach(Cafe.mockData) { cafe in
                Annotation(cafe.name, coordinate: cafe.coordinate) {
                    VStack {
                        Image(systemName: "cup.and.saucer.fill")
                            .foregroundColor(.brown)
                            .font(.title2)
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.brown, lineWidth: 2))
                    }
                }
                .tag(cafe)
            }

            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        .sheet(item: $selectedCafe) { cafe in
            CafeDetailView(cafe: cafe, userLocation: locationManager.userLocation, route: route)
                .presentationDetents([.height(300)])
        }
        .onChange(of: selectedCafe) { oldValue, newValue in
            if let cafe = newValue, let userLocation = locationManager.userLocation {
                fetchRoute(from: userLocation, to: cafe.coordinate)
            } else {
                route = nil
            }
        }
    }

    private func fetchRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        request.transportType = .walking

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error {
                print("Rota hesaplama hatası: \(error.localizedDescription)")
                return
            }
            guard let route = response?.routes.first else { return }
            self.route = route
        }
    }
}

#Preview {
    MapView(locationManager: LocationManager())
}
