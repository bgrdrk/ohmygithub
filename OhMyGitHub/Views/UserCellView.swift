import UIKit

final class UserCellView: UIView {
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let followersLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property Setters
    
    func setImage(image: UIImage) {
        profileImageView.image = image
        profileImageView.contentMode = .scaleAspectFit
    }
    
    func setUsername(_ username: String) {
        usernameLabel.text = username
    }
    
    func setFollowersCount(_ count: Int) {
        followersLabel.text = "Followers count: \(count)"
    }
    
    // MARK: - Configuration
    
    private func configure() {
        setupConstraints()
        profileImageView.backgroundColor = .systemRed
        usernameLabel.text = "Username"
        followersLabel.text = "Followers count: *"
    }
    
    private func setupConstraints() {
        
        profileImageView.setDimensions(width: 80, height: 80)
        
        let labelsStack = UIStackView(arrangedSubviews: [usernameLabel, followersLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 5
        labelsStack.distribution = .fillEqually
        
        let mainStack = UIStackView(arrangedSubviews: [profileImageView, labelsStack])
        mainStack.axis = .horizontal
        mainStack.spacing = 10
        mainStack.distribution = .fillProportionally

        self.addSubview(mainStack)
        
        mainStack.addConstraintsToFillView(self)
    }
    
}
