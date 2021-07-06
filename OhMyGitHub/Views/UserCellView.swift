import UIKit

final class UserCellView: UIView {
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel().nameLabel
    private let usernameLabel = UILabel().usernameLabel
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
    
    func setName(_ name: String) {
        nameLabel.text = name
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
        self.layer.cornerRadius = AppUI.cornerRadius
        self.backgroundColor = AppUI.appColor(.customWhite)
    }
    
    private func setupConstraints() {
        
        self.addSubview(profileImageView)
        self.addSubview(nameLabel)
        self.addSubview(usernameLabel)
        self.addSubview(followersLabel)
        
        profileImageView.setDimensions(width: AppUI.heightOfLargeContainers, height: AppUI.heightOfLargeContainers)
        profileImageView.anchor(top: self.topAnchor,
                                left: self.leftAnchor,
                                bottom: self.bottomAnchor,
                                paddingTop: AppUI.spacing,
                                paddingLeft: AppUI.spacing,
                                paddingBottom: AppUI.spacing)
        
        nameLabel.anchor(top: profileImageView.topAnchor,
                         left: profileImageView.rightAnchor,
                         right: self.rightAnchor,
                         paddingLeft: AppUI.spacing,
                         paddingRight: AppUI.spacing)
        
        usernameLabel.anchor(top: nameLabel.bottomAnchor,
                             left: nameLabel.leftAnchor,
                             paddingTop: AppUI.spacing)
        
        followersLabel.anchor(top: usernameLabel.bottomAnchor,
                             left: usernameLabel.leftAnchor,
                             paddingTop: AppUI.spacing)
    }
    
}
