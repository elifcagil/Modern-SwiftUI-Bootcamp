import SwiftUI

@main
struct CafeAroundApp: App {
    @StateObject private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            MapView(locationManager: locationManager)
                .onAppear {
                    locationManager.requestPermission()
                }
        }
    }
}
