import Foundation

struct HotelInfoModel: Codable {
    let id: Int
    let name, address: String
    let stars, distance: Double
    let image: String?
    let suitesAvailability: String
    let lat, lon: Double

    enum CodingKeys: String, CodingKey {
        case id, name, address, stars, distance, image
        case suitesAvailability = "suites_availability"
        case lat, lon
    }
}
