import UIKit

final class RepositoryCellView: UIView {
    
    private let ownerNameLabel = UILabel()
    private let repositoryNameLabel = UILabel()
    private let languageLabel = UILabel()
    private let starsLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property Setters
    
    func configure(with repository: Repository) {
        ownerNameLabel.text = repository.owner.login
        repositoryNameLabel.text = repository.name
        languageLabel.text = "Language: \(repository.language ?? "No data")"
        starsLabel.text = "Stars: \(repository.stargazersCount)"
    }
    
    // MARK: - Configuration
    
    private func setup() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        let labelsStack = UIStackView(arrangedSubviews: [ownerNameLabel, repositoryNameLabel, languageLabel, starsLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 5
        labelsStack.distribution = .fillEqually

        self.addSubview(labelsStack)
        
        labelsStack.addConstraintsToFillView(self)
    }
}

