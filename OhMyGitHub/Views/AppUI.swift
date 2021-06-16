import UIKit

struct AppUI {
    
    // MARK: - UI Constants
    
    static let cornerRadius: CGFloat = 8
    static let buttonHeight: CGFloat = 50
    
    // MARK: - App Style Buttons
    
    static func actionButton(withText text: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(20)
        button.backgroundColor = .systemRed
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.layer.cornerRadius = cornerRadius
        return button
    }
    
    // MARK: - Labels
    
    static func h1Label(withText text: String, and fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.text = text
        label.textColor = .systemBlue
        return label
    }
}
