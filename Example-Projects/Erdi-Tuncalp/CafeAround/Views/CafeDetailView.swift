import SwiftUI
import MapKit

struct CafeDetailView: View {
    let cafe: Cafe
    let userLocation: CLLocationCoordinate2D?
    let route: MKRoute?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerView
            Divider()
            if let userLocation {
                infoSection(for: userLocation)
                mapsButton
            } else {
                noLocationView
            }
            Spacer()
        }
        .padding()
    }

    // MARK: - View Components

    private var headerView: some View {
        HStack {
            Image(systemName: "cup.and.saucer.fill")
                .foregroundColor(.brown)
                .font(.title2)

            Text(cafe.name)
                .font(.title2)
                .fontWeight(.bold)

            Spacer()
        }
        .padding(.top)
    }

    private func infoSection(for userLocation: CLLocationCoordinate2D) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            infoRow(
                icon: "location.fill",
                color: .blue,
                title: "Mesafe:",
                value: LocationHelper.formattedDistance(from: userLocation, to: cafe.coordinate)
            )

            if let route {
                infoRow(
                    icon: "figure.walk",
                    color: .green,
                    title: "Yürüme süresi:",
                    value: LocationHelper.formatDuration(route.expectedTravelTime)
                )

                infoRow(
                    icon: "arrow.triangle.turn.up.right.diamond",
                    color: .orange,
                    title: "Yön:",
                    value: LocationHelper.getDirection(from: userLocation, to: cafe.coordinate)
                )
            }
        }
    }

    private func infoRow(icon: String, color: Color, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(title)
                .fontWeight(.semibold)
            Text(value)
                .foregroundColor(.secondary)
        }
    }

    private var mapsButton: some View {
        Button(action: openInMaps) {
            HStack {
                Image(systemName: "map.fill")
                Text("Apple Maps'te Yol Tarifi Al")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }

    private var noLocationView: some View {
        Text("Konum bilgisi alınamadı")
            .foregroundColor(.secondary)
    }

    // Apple Maps'te aç
    private func openInMaps() {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: cafe.coordinate))
        mapItem.name = cafe.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
}

#Preview {
    Color.white
        .sheet(isPresented: .constant(true)) {
            CafeDetailView(
                cafe: Cafe.mockData[0],
                userLocation: CLLocationCoordinate2D(latitude: 40.990446, longitude: 29.029167),
                route: MKRoute()
            )
            .presentationDetents([.height(300)])
        }
}
