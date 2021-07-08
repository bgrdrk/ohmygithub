import UIKit

final class IndicatorView: UIView {

    private let indicator = UIActivityIndicatorView(style: .large)
    private let background = UIView()

    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func start() {
        indicator.startAnimating()
    }
    // MARK: - Configuration

    private func configure() {
        background.backgroundColor = AppUI.appColor(.customBlack)
        background.isUserInteractionEnabled = true
        background.alpha = 0.15
        setupConstraints()
    }

    private func setupConstraints() {

        addSubview(background)
        addSubview(indicator)

        background.addConstraintsToFillView(self)
        indicator.center(inView: background)
    }
}

