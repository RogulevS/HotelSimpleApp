import UIKit
import SnapKit

protocol InfoViewOutput: AnyObject {
    func loadData()
    func startAnimation()
    func stopAnimation()
}

final class InfoViewController: UIViewController {
    
    //MARK: - Private properties
    
    private let presenter: InfoViewPresenter
    private let imageHotel = UIImageView()
    private let imageContentView: UIView = {
        let imageView = UIView()
        imageView.backgroundColor = .white
        imageView.layer.borderWidth = LocalConstants.imageLayerBorderWidth
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: LocalConstants.titleLabelSize)
        return label
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: LocalConstants.addressLabelSize)
        label.numberOfLines = LocalConstants.addressNumberOfLines
        return label
    }()
    private lazy var loader = UIActivityIndicatorView()
    
    //MARK: - Init
    
    init(presenter: InfoViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(LocalConstants.fatalErrorString)
    }
    
    //MARK: - Lyficycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter.loadData()
        setupUI()
    }
    
    //MARK: - Private methods
    
    private func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(imageHotel)
        view.addSubview(titleLabel)
        view.addSubview(addressLabel)
        view.addSubview(imageContentView)
        imageContentView.insertSubview(imageHotel, at: LocalConstants.insertSubviewImageHotel)
    }
    
    private func setupConstraints() {
        imageContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(LocalConstants.imageContentViewHeight)
        }
        imageHotel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageHotel.snp.bottom).inset(LocalConstants.labelTopInset)
            make.leading.equalToSuperview().inset(LocalConstants.labelLeadingInset)
        }
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(LocalConstants.labelTopInset)
            make.leading.trailing.equalToSuperview().inset(LocalConstants.labelLeadingInset)
        }
    }
    
    private func configureView(with model: PresentedHotelInfoModel) {
        titleLabel.text = model.name
        imageHotel.image = model.presentedImage
        addressLabel.text = model.address
    }
    
    private func startAnimation() {
        loader.isHidden = false
        loader.startAnimating()
    }
    
    private func stopAnimation() {
        loader.stopAnimating()
        loader.isHidden = true
    }
}

//MARK: - Presenter protocol extension

extension InfoViewController: InfoViewInput {
    func update(with model: PresentedHotelInfoModel) {
        configureView(with: model)
    }
}

//MARK: - Local constants
private extension InfoViewController {
    enum LocalConstants {
        static let imageLayerBorderWidth: CGFloat = 10
        static let titleLabelSize: CGFloat = 16
        static let addressLabelSize: CGFloat = 14
        static let addressNumberOfLines = 2
        static let fatalErrorString = "init(coder:) has not been implemented"
        static let insertSubviewImageHotel = 0
        static let imageContentViewHeight = 230
        static let labelTopInset = -20
        static let labelLeadingInset = 20
    }
}
