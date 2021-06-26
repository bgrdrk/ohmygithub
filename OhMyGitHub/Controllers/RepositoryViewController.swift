import UIKit

class RepositoryViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: RepositoryViewModel
    weak var coordinator: MainCoordinator?
    
    init(viewModel: RepositoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
       
    private let ownerNameButton: UIButton = {
        let button = AppUI.attributedButton("Owner Name", "")
        button.addTarget(self, action: #selector(handleOwnerTap), for: .touchUpInside)
        return button
    }()
    
    private let repositoryName: UILabel = {
        let label = AppUI.h1Label(withText: "Repository name")
        return label
    }()
    
    private let repositoryDescription: UILabel = {
        let label = AppUI.h2Label(withText: "Repository description")
        return label
    }()
    
    private let programmingLanguage: UILabel = {
        let label = AppUI.h2Label(withText: "Programing language")
        return label
    }()
    
    private let starsButton: UIButton = {
        let button = AppUI.attributedButton("Stars count:", "0")
        button.addTarget(self, action: #selector(handleStarTap), for: .touchUpInside)
        return button
    }()
    
    private let contributorsButton: UIButton = {
        let button = AppUI.attributedButton("Contributors:", "0")
        button.addTarget(self, action: #selector(handleContributorsTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Selected Repository"
        
        configureUI()
        bindViewModel()
        viewModel.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    // MARK: - Helpers
    
    private func bindViewModel() {
        viewModel.contributors.bind { [weak self] contributors in
            self?.contributorsButton.updateAttributtedTitle("Contributors", "\(contributors.count)")
        }
        
        viewModel.repository.bind { [weak self] repository in
            guard let repository = repository,
                  let self = self else { return }
            self.ownerNameButton.updateAttributtedTitle((repository.owner.login), "")
            self.repositoryName.text = repository.name
            self.repositoryDescription.text = repository.description ?? "No description"
            self.programmingLanguage.text = repository.language ?? "No language specified"
            self.starsButton.updateAttributtedTitle("Stars count", "\(repository.stargazersCount)")
        }
    }

    // MARK: - Selectors
        
    @objc private func handleOwnerTap() {
        print((#function))
    }
    
    @objc private func handleContributorsTap() {
        coordinator?.presentAccountsViewController(accounts: viewModel.contributors.value)
    }
    
    @objc private func handleStarTap() {

    }
   
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        
        let stack = UIStackView(arrangedSubviews: [ownerNameButton, repositoryName, repositoryDescription,
                                                   programmingLanguage, starsButton, contributorsButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor, right: view.rightAnchor,
                     paddingLeft: 40, paddingRight: 40)
        stack.center(inView: view)
    }
}
