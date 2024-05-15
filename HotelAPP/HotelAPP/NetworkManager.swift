import Foundation

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getHotels() async throws -> [HotelModelElement] {
        let urlString = "https://raw.githubusercontent.com/iMofas/ios-android-test/master/0777.json"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let model = try JSONDecoder().decode([HotelModelElement].self, from: data)
            return model
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func getHotel(by ID: Int) async throws -> HotelInfoModel {
        let urlString = "https://raw.githubusercontent.com/iMofas/ios-android-test/master/\(ID).json"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let model = try JSONDecoder().decode(HotelInfoModel.self, from: data)
            return model
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func getHotelImage(by imageID: String?) async throws -> Data? {
        guard let imageID else { return nil }
        
        let urlString = "https://github.com/iMofas/ios-android-test/raw/master/\(imageID)"
        
        guard let imageURL = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: imageURL)
        return data
    }
}

