import UIKit

struct AppUI {
    
    // MARK: - UI Constants
    
    static let boldedFontSize: CGFloat = 20
    static let smallFontSize: CGFloat = 16
    
    static let cornerRadius: CGFloat = 8
    static let spacing: CGFloat = 10
    static let buttonHeight: CGFloat = 60
    static let buttonFontSize: CGFloat = 20
    
    // MARK: - Colors
    
    static let appLightGreyColor: UIColor = .systemGray5
    static let appDarkerGreyColor: UIColor = .systemGray4
    
    // MARK: - App Style Buttons
    
    static func actionButton(withText text: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(buttonFontSize)
        button.backgroundColor = .systemOrange
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.layer.cornerRadius = cornerRadius
        return button
    }
    
    static func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemTeal
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
    
    static func containerView(with texfield: UITextField) -> UIView {
        let view = UIView()
        let dividerView = UIView()

        dividerView.backgroundColor = appLightGreyColor
        
        view.addSubview(texfield)
        view.addSubview(dividerView)
        
        view.setDimensions(height: 40)
        texfield.anchor(allSidesPadding: 10, inView: view)
        dividerView.anchor(top: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 0.75)
        
        return view
    }
}

    // MARK: - UIKit Extensions

extension UIButton {
    func makeAttributtedString(_ firstPart: String, _ secondPart: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: firstPart, attributes:
                                                            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: AppUI.buttonFontSize),
                                                             NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedString.append(NSAttributedString(string: " \(secondPart)", attributes:
                                                    [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: AppUI.buttonFontSize),
                                                     NSAttributedString.Key.foregroundColor: UIColor.black]))
        return attributedString
    }
    
    func updateAttributtedTitle(_ firstPart: String, _ secondPart: String) {
        let attributedString = makeAttributtedString(firstPart, secondPart)
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UILabel {
    
    var nameLabel: UILabel {
        self.font = UIFont.boldSystemFont(ofSize: AppUI.boldedFontSize)
        self.numberOfLines = 0
        self.textColor = .black
        return self
    }
    
    var usernameLabel: UILabel {
        self.font = UIFont.systemFont(ofSize: AppUI.smallFontSize)
        self.numberOfLines = 0
        self.textColor = AppUI.appDarkerGreyColor
        return self
    }
    
}
