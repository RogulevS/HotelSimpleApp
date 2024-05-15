import UIKit

protocol MainViewInput: AnyObject {
    func createInfoView(_ id: Int) -> InfoViewController
    func requestData()
}

final class MainPresenter: MainViewInput {
   
    //MARK: - Private properties
    
    private let networkManager = NetworkManager.shared
    private weak var view: MainViewOutput?
    
    //MARK: - Init
    
    init(view: MainViewOutput) {
        self.view = view
    }
    
    //MARK: - Private methods
    
    private func loadData() async {
        Task { @MainActor in
            do {
                view?.startAnimation()
                let hotels = try await networkManager.getHotels()
                view?.getHotels(hotels)
                view?.stopAnimation()
            } catch {
                print(error)
            }
        }
    }
    
    //MARK: - Methods
    
    func createInfoView(_ id: Int) -> InfoViewController {
        let presenter = InfoViewPresenter(id: id)
        let view = InfoViewController(presenter: presenter)
        presenter.view = view
        return view
    }
    
    func requestData() {
         Task {
             await loadData()
         }
     }
}
