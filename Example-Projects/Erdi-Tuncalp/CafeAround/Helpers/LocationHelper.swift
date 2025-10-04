import Foundation
import CoreLocation

enum LocationHelper {

    // MARK: - Distance Formatting

    /// Mesafeyi okunabilir formatta döndür (m veya km)
    static func formattedDistance(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> String {
        let startLocation = CLLocation(latitude: start.latitude, longitude: start.longitude)
        let endLocation = CLLocation(latitude: end.latitude, longitude: end.longitude)
        let distanceInMeters = startLocation.distance(from: endLocation)

        if distanceInMeters < 1000 {
            return String(format: "%.0f m", distanceInMeters)
        } else {
            return String(format: "%.1f km", distanceInMeters / 1000)
        }
    }

    // MARK: - Duration Formatting

    /// Süreyi formatla (dakika veya saat+dakika)
    static func formatDuration(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds / 60)
        if minutes < 60 {
            return "\(minutes) dakika"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return "\(hours) saat \(remainingMinutes) dakika"
        }
    }

    // MARK: - Direction Calculation

    /// İki nokta arasındaki yönü hesapla (8 yön)
    static func getDirection(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> String {
        let deltaLon = end.longitude - start.longitude
        let deltaLat = end.latitude - start.latitude

        let angle = atan2(deltaLon, deltaLat) * 180 / .pi
        let normalizedAngle = (angle + 360).truncatingRemainder(dividingBy: 360)

        return switch normalizedAngle {
        case 0..<22.5, 337.5...360: "Kuzey ↑"
        case 22.5..<67.5: "Kuzeydoğu ↗"
        case 67.5..<112.5: "Doğu →"
        case 112.5..<157.5: "Güneydoğu ↘"
        case 157.5..<202.5: "Güney ↓"
        case 202.5..<247.5: "Güneybatı ↙"
        case 247.5..<292.5: "Batı ←"
        case 292.5..<337.5: "Kuzeybatı ↖"
        default: "Bilinmiyor"
        }
    }
}
