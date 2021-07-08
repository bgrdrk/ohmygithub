import UIKit

class UserCell: UITableViewCell {

    private let indicator = IndicatorView()
    private let userCellView = UserCellView()
    private var viewModel: UserCellViewModel!
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Configuration
    
    func configureCell(with viewModel: UserCellViewModel) {
        self.viewModel = viewModel
        self.viewModel.start()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        backgroundColor = AppUI.appColor(.lightGrey)
        selectionStyle = .none
        addSubview(userCellView)
        addSubview(indicator)
        isUserInteractionEnabled = false
        userCellView.anchor(allSidesPadding: 5, inView: self)
        indicator.addConstraintsToFillView(userCellView)
        indicator.layer.cornerRadius = AppUI.cornerRadius
        indicator.start()
    }
    
    private func bindViewModel() {
        viewModel.profileImage.bind { [weak self] image in
            self?.userCellView.setImage(image: image)
        }
        
        viewModel.name.bind { [weak self] name in
            self?.userCellView.setName(name)
        }
        
        viewModel.username.bind { [weak self] username in
            self?.userCellView.setUsername(username)
        }
        
        viewModel.followers.bind { [weak self] followersCount in
            self?.userCellView.setFollowersCount(followersCount)
        }

        viewModel.dataFetchCounter.bind { [weak self] count in
            let flag = count == 2
            self?.indicator.isHidden = flag
            self?.isUserInteractionEnabled = flag
        }
    }
}
