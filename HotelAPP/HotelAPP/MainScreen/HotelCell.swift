import UIKit

final class HotelCell: UITableViewCell {
    
    //MARK: - Properties
    
    let hotelNameLabel = UILabel()
    let ratingLabel = UILabel()
    let distanceLabel = UILabel()
    let suitesLabel = UILabel()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError(LocalConstants.fatalErrorString)
    }
    
    //MARK: - Private methods
    
    private func setupLabels() {
        hotelNameLabel.font = UIFont.boldSystemFont(ofSize: LocalConstants.boldSystemFontОfSize)
        contentView.addSubview(hotelNameLabel)
        
        ratingLabel.font = UIFont.systemFont(ofSize: LocalConstants.systemFontOfSize)
        contentView.addSubview(ratingLabel)

        distanceLabel.font = UIFont.systemFont(ofSize: LocalConstants.systemFontOfSize)
        contentView.addSubview(distanceLabel)
        
        suitesLabel.font = UIFont.systemFont(ofSize: LocalConstants.systemFontOfSize)
        contentView.addSubview(suitesLabel)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(LocalConstants.contentWidth)
            make.width.equalToSuperview()
        }
        hotelNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LocalConstants.hotelNameLabelTopInset)
            make.leading.equalToSuperview().inset(LocalConstants.hotelNameLeadingInset)
        }
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(hotelNameLabel.snp.bottom).inset(LocalConstants.distanceSuitesTopInset)
            make.leading.equalTo(hotelNameLabel)
        }
        suitesLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).inset(LocalConstants.distanceSuitesTopInset)
            make.leading.equalTo(distanceLabel)
        }
        ratingLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(LocalConstants.ratingTrailingInset)
            make.bottom.equalTo(suitesLabel)
        }
    }
}

// MARK: - Local constants

private extension HotelCell {
    enum LocalConstants {
        static let fatalErrorString = "init(coder:) has not been implemented"
        static let boldSystemFontОfSize: CGFloat = 16
        static let systemFontOfSize: CGFloat = 10
        static let contentWidth = 60
        static let hotelNameLabelTopInset = 6
        static let hotelNameLeadingInset = 16
        static let distanceSuitesTopInset = -2
        static let ratingTrailingInset = 16
    }
}
