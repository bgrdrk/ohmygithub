import UIKit

final class CustomButtonView: CustomButton {
    
    private let numberLabel = UILabel().customButtonTitleLabel
    private let textLabel = UILabel().usernameLabel
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, description: String) {
        numberLabel.text = title
        textLabel.text = description
    }
    
    func changeTitle(to title: String) {
        numberLabel.text = title
    }
    
    private func start() {
        self.backgroundColor = AppUI.appColor(.customWhite)
        self.layer.cornerRadius = AppUI.cornerRadius
        
        self.addSubview(numberLabel)
        self.addSubview(textLabel)
        
        numberLabel.centerX(inView: self)
        numberLabel.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: AppUI.spacing, paddingLeft: 10, paddingRight: 10)
        numberLabel.setDimensions(height: AppUI.customButtonTitleFontSize - 10)
        
        textLabel.centerX(inView: self)
        textLabel.anchor(top: numberLabel.bottomAnchor, paddingTop: AppUI.spacing)
        textLabel.isUserInteractionEnabled = false
        
        self.anchor(bottom: textLabel.bottomAnchor, paddingBottom: -AppUI.spacing)
    }
}
