import UIKit

class UserCellTableViewCell: UITableViewCell {
    
    private let userCellView = UserCellView()
    private var viewModel: UserCellViewModel?
    
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
        self.viewModel?.start()
        userCellView.configure()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        self.addSubview(userCellView)
        userCellView.anchor(allSidesPadding: 5, inView: self)
    }
    
    private func bindViewModel() {
        viewModel!.profileImage.bind { [weak self] image in
            self?.userCellView.setImage(image: image)
        }
    }
}
