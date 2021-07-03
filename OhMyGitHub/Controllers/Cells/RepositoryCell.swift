import UIKit

class RepositoryCell: UITableViewCell {
    
    private let repositoryCellView = RepositoryCellView()
    private var viewModel: RepositoryCellViewModel!
    
    // MARK: - Lifecycle
    
    override init(style: RepositoryCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Configuration
    
    func configureCell(with viewModel: RepositoryCellViewModel) {
        self.viewModel = viewModel
        self.viewModel.start()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        self.addSubview(repositoryCellView)
        repositoryCellView.anchor(allSidesPadding: 5, inView: self)
    }
    
    private func bindViewModel() {
        viewModel.repository.bind { [weak self] repository in
            guard let self = self,
                  let repository = repository else { return }
            self.repositoryCellView.configure(with: repository)
        }
    }
}
