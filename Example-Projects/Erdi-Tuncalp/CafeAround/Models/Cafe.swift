import CoreLocation
import Foundation

struct Cafe: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let category: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Cafe {
    static let mockData: [Cafe] = [
        Cafe(name: "Kahve Diyarı", latitude: 40.9900, longitude: 29.0254, category: "Kahve"),
        Cafe(name: "Moda Cafe", latitude: 40.9850, longitude: 29.0300, category: "Kahve"),
        Cafe(name: "Şirin Kafe", latitude: 40.9920, longitude: 29.0280, category: "Tatlı"),
        Cafe(name: "Kitap Cafe", latitude: 40.9880, longitude: 29.0240, category: "Kahve"),
        Cafe(name: "Sahil Kafe", latitude: 40.9860, longitude: 29.0310, category: "Kahve"),
        Cafe(name: "Bahçe Cafe", latitude: 40.9910, longitude: 29.0260, category: "Kahve"),
        Cafe(name: "Nostaljik Mekan", latitude: 40.9870, longitude: 29.0290, category: "Tatlı"),
        Cafe(name: "Keyif Durağı", latitude: 40.9895, longitude: 29.0275, category: "Kahve")
    ]
}
