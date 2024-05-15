import Foundation

// MARK: - HotelModelElement
struct HotelModelElement: Codable {
    let id: Int
    let name, address: String
    let stars: Int
    let distance: Double
    let suitesAvailability: String

    enum CodingKeys: String, CodingKey {
        case id, name, address, stars, distance
        case suitesAvailability = "suites_availability"
    }
}

