import UIKit

final class SectionTitleView: UIView {
    private var icon: UIView
    private var sectionTitleLabel: UILabel
    
    init(icon: UIImage, title: String) {
        self.icon = UIView().iconView(withImage: icon)
        self.sectionTitleLabel = UILabel().titleLabel(with: title)
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    
    private func configure() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        self.addSubview(icon)
        self.addSubview(sectionTitleLabel)
        
        icon.anchor(top: self.topAnchor,
                    left: self.leftAnchor,
                    bottom: self.bottomAnchor)
        
        sectionTitleLabel.anchor(left: icon.rightAnchor, paddingLeft: AppUI.spacing)
        sectionTitleLabel.centerY(inView: self)
    }
    
}
