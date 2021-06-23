import UIKit

struct AppUI {
    
    // MARK: - UI Constants
    
    static let cornerRadius: CGFloat = 8
    static let buttonHeight: CGFloat = 60
    static let buttonFontSize: CGFloat = 20
    
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
}


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
