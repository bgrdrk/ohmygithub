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
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
    }
    
    private func setupConstraints() {
        
        self.addSubview(profileImageView)
        self.addSubview(nameLabel)
        self.addSubview(usernameLabel)
        self.addSubview(followersLabel)
        
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.anchor(top: self.topAnchor,
                                left: self.leftAnchor,
                                bottom: self.bottomAnchor,
                                paddingTop: 10,
                                paddingLeft: 10,
                                paddingBottom: 10)
        
        nameLabel.anchor(top: profileImageView.topAnchor,
                         left: profileImageView.rightAnchor,
                         paddingLeft: 10)
        
        usernameLabel.anchor(top: nameLabel.bottomAnchor,
                             left: nameLabel.leftAnchor,
                             paddingTop: 10)
        
        followersLabel.anchor(top: usernameLabel.bottomAnchor,
                             left: usernameLabel.leftAnchor,
                             paddingTop: 10)
    }
    
}
