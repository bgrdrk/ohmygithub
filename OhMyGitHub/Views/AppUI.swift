import UIKit

struct AppUI {
    
    // MARK: - UI Constants
    
    static let titleFontSize: CGFloat = 25
    static let boldedFontSize: CGFloat = 22
    static let smallFontSize: CGFloat = 18
    static let buttonFontSize: CGFloat = 20
    static let customButtonTitleFontSize: CGFloat = 70
    
    static let cornerRadius: CGFloat = 8
    static let spacing: CGFloat = 10
    static let buttonHeight: CGFloat = 40
    static let sectionTitleHeight: CGFloat = 40
    static let heightOfLargeContainers: CGFloat = 100
    
    // MARK: - Colors
    
    enum AppColors {
        case customWhite
        case customBlack
        case lightGrey
        case darkGrey
    }
    
    static func appColor(_ color: AppColors) -> UIColor {
        switch color {
        case .customWhite:
            return .white
        case .customBlack:
            return .black
        case .lightGrey:
            return .systemGray6
        case .darkGrey:
            return .systemGray2
        }
    }
    
    // MARK: - App Style Buttons
    
    static func actionButton(withText text: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(buttonFontSize)
        button.backgroundColor = AppUI.appColor(.customWhite)
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.layer.cornerRadius = cornerRadius
        return button
    }
    
    static func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = AppUI.appColor(.customWhite)
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.layer.cornerRadius = cornerRadius
        let attributedString = button.makeAttributtedString(firstPart, secondPart)
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }
    
    // MARK: - Labels
    
    static func h1Label(withText text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = text
        label.textColor = .black
        return label
    }
    
    static func h2Label(withText text: String) -> UILabel {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.text = text
        label.textColor = .black
        return label
    }
    
    // MARK: - Text Fields
    
    static func inputField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        return textField
    }
    
    // MARK: - Views
    
    static func inputFieldContainerView(with texfield: UITextField) -> UIView {
        let view = UIView()
        let dividerView = UIView()

        dividerView.backgroundColor = AppUI.appColor(.lightGrey)
        
        view.addSubview(texfield)
        view.addSubview(dividerView)
        
        view.setDimensions(height: 40)
        texfield.anchor(allSidesPadding: 10, inView: view)
        dividerView.anchor(top: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 0.75)
        
        return view
    }
}

    // MARK: - Buttons

extension UIButton {
    func makeAttributtedString(_ firstPart: String, _ secondPart: String) -> NSMutableAttributedString {
        let attributedString =
            NSMutableAttributedString(string: firstPart,
                                      attributes:
                                        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: AppUI.buttonFontSize),
                                        NSAttributedString.Key.foregroundColor: UIColor.black])

        attributedString
            .append(NSAttributedString(string: " \(secondPart)",
                                       attributes:
                                        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: AppUI.buttonFontSize),
                                        NSAttributedString.Key.foregroundColor: AppUI.appColor(.darkGrey)]))
        return attributedString
    }
    
    func updateAttributtedTitle(_ firstPart: String, _ secondPart: String) {
        let attributedString = makeAttributtedString(firstPart, secondPart)
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

    // MARK: - Labels

extension UILabel {
    
    func titleLabel(with title: String) -> UILabel {
        self.text = title
        self.font = UIFont.boldSystemFont(ofSize: AppUI.titleFontSize)
        self.numberOfLines = 0
        self.textColor = AppUI.appColor(.customBlack)
        return self
    }
    
    var titleLabel: UILabel {
        self.font = UIFont.boldSystemFont(ofSize: AppUI.titleFontSize)
        self.numberOfLines = 0
        self.textColor = AppUI.appColor(.customBlack)
        return self
    }
    
    var nameLabel: UILabel {
        self.font = UIFont.boldSystemFont(ofSize: AppUI.boldedFontSize)
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.textColor = AppUI.appColor(.customBlack)
        return self
    }
    
    var usernameLabel: UILabel {
        self.font = UIFont.systemFont(ofSize: AppUI.smallFontSize)
        self.textColor = AppUI.appColor(.darkGrey)
        return self
    }
    
    var followersLabel: UILabel {
        self.font = UIFont.systemFont(ofSize: AppUI.smallFontSize)
        self.textColor = AppUI.appColor(.darkGrey)
        return self
    }
    
    var customButtonTitleLabel: UILabel {
        self.font = UIFont.boldSystemFont(ofSize: AppUI.customButtonTitleFontSize)
        self.textColor = AppUI.appColor(.customBlack)
        return self
    }
}

// MARK: - Views

extension UIView {
    
    func iconView(withImage image: UIImage) -> UIView {
        let view = UIView()
        let iv = UIImageView()
                
        iv.image = image
        iv.tintColor = AppUI.appColor(.darkGrey)
        view.addSubview(iv)
        iv.center(inView: view)
        iv.setDimensions(width: 30, height: 30)

        view.layer.cornerRadius = AppUI.cornerRadius
        view.backgroundColor = .white
        view.setDimensions(width: 50, height: 50)
        return view
    }
}
