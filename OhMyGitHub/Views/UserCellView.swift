import UIKit

final class UserCellView: UIView {
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let followersLabel = UILabel()
    
    func configure() {
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
    
    func setImage(image: UIImage) {
        profileImageView.image = image
        profileImageView.contentMode = .scaleAspectFit
    }
    
}
