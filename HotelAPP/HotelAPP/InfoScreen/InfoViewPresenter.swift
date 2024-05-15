import UIKit

protocol InfoViewInput: AnyObject {
    func update(with model: PresentedHotelInfoModel)
}

final class InfoViewPresenter {
    
    //MARK: - Private properties
    
    private let id: Int
    private let networkManager = NetworkManager.shared
    
    //MARK: - Properties
    
    weak var view: InfoViewInput?
    
    //MARK: - Init
    
    init(id: Int) {
        self.id = id
    }
    
    //MARK: - Methods
    
    func loadData() {
         Task {
             await fetchAndPresentData()
         }
     }
    
    //MARK: - Private methods
    
    private func fetchAndPresentData() async {
        do {
            let model = try await networkManager.getHotel(by: id)
            let image = try await networkManager.getHotelImage(by: model.image)
            Task { @MainActor in
                createPresentedModel(with: model, imageData: image)
            }
        } catch {
            print(error)
        }
    }
    
    private func createPresentedModel(with model: HotelInfoModel, imageData: Data?) {
        let hotelImage: UIImage?
        if let imageData = imageData, let image = UIImage(data: imageData) {
            hotelImage = image
        } else {
            hotelImage = UIImage(resource: .noimage)
        }
        let presentedModel = PresentedHotelInfoModel(name: model.name,
                                                     address: model.address,
                                                     stars: model.stars,
                                                     distance: model.distance,
                                                     presentedImage: hotelImage,
                                                     suitesAvailability: model.suitesAvailability)
        view?.update(with: presentedModel)
    }
}
