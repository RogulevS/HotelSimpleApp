import UIKit
import SnapKit

protocol MainViewOutput: AnyObject {
    func getHotels(_ hotels: [HotelModelElement])
    func startAnimation()
    func stopAnimation()
}

private enum SortingType {
    case update
    case distance
    case suites
}

final class MainViewController: UIViewController {
    
    //MARK: - Private properties
    
    private let tableView = UITableView()
    private var hotels: [HotelModelElement] = []
    private var currentSortingType: SortingType = .update
    private lazy var loader = UIActivityIndicatorView()
    
    //MARK: - Properties
    
    var presenter: MainPresenter?
    
    //MARK: - Lyficycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupLoader()
        presenter?.requestData()
    }
    
    //MARK: - Private methods
    
    private func setupNavigationBar() {
        title = LocalConstants.title
        let sortButton = UIBarButtonItem(title: LocalConstants.sortButtonTitle, style: .done, target: self, action: #selector(sortHotels))
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HotelCell.self, forCellReuseIdentifier: LocalConstants.cellID)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupLoader() {
        view.addSubview(loader)
        loader.isHidden = true
        loader.style = .large
        loader.color = .green
        loader.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc private func sortHotels() {
        let alertController = UIAlertController(title: LocalConstants.alertControllerTitle, message: nil, preferredStyle: .actionSheet)
        let sortingOptions: [(String, UIAlertAction.Style, SortingType)] = [
            (LocalConstants.distanceTitle, .default, .distance),
            (LocalConstants.suitesTitle, .default, .suites),
            (LocalConstants.updateTitle, .cancel, .update)
        ]
        
        for option in sortingOptions {
            let action = UIAlertAction(title: option.0, style: option.1) { _ in
                self.currentSortingType = option.2
                self.sortHotelsBy(type: option.2)
            }
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }

    private func sortHotelsBy(type: SortingType) {
        switch type {
        case .update:
            presenter?.requestData()
        case .distance:
            hotels.sort { $0.distance < $1.distance }
        case .suites:
            hotels.sort { $0.suitesAvailability.count > $1.suitesAvailability.count }
        }
        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocalConstants.cellID) as! HotelCell
        cell.hotelNameLabel.text = hotels[indexPath.row].name
        cell.ratingLabel.text = "Rating: \(hotels[indexPath.row].stars)"
        cell.distanceLabel.text = "Distance: \(hotels[indexPath.row].distance) m"
        cell.suitesLabel.text = "Suites: \(hotels[indexPath.row].suitesAvailability)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hotelId = hotels[indexPath.row].id
        guard let hotelDetailVC = presenter?.createInfoView(hotelId) else { return }
        navigationController?.pushViewController(hotelDetailVC, animated: true)
       }
}

//MARK: - Presenter protocol extension

extension MainViewController: MainViewOutput {
    
    func startAnimation() {
        loader.isHidden = false
        loader.startAnimating()
    }
    
    func stopAnimation() {
        loader.stopAnimating()
        loader.isHidden = true
    }
    func getHotels(_ hotels: [HotelModelElement]) {
        self.hotels = hotels
        tableView.reloadData()
    }
}

//MARK: - Local constants

private extension MainViewController {
    enum LocalConstants {
        static let title = "Отели"
        static let sortButtonTitle = "Сортировать"
        static let cellID = "cell"
        static let alertControllerTitle = "Выберите тип сортировки"
        static let distanceTitle = "Расстояние"
        static let suitesTitle = "Наличие номеров"
        static let updateTitle = "Обновить"
    }
}
