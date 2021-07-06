import UIKit

class AppUserViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: AppUserViewModel
    weak var coordinator: MainCoordinator?
    
    init(viewModel: AppUserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private let userCell = UserCellView()
    
    private let followersButton: UIButton = {
        let button = AppUI.attributedButton("Number of followers:", "0")
        button.addTarget(self, action: #selector(handleFollowersTap), for: .touchUpInside)
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = AppUI.attributedButton("Following:", "0")
        button.addTarget(self, action: #selector(handleFollowingTap), for: .touchUpInside)
        return button
    }()
    
    private let personalReposButton: UIButton = {
        let button = AppUI.attributedButton("Personal repositories:", "0")
        button.addTarget(self, action: #selector(handlePersonalReposTap), for: .touchUpInside)
        button.backgroundColor = .systemGreen
        return button
    }()
    
    private let starredReposButton: UIButton = {
        let button = AppUI.attributedButton("Starred repositories:", "0")
        button.addTarget(self, action: #selector(handleStarredReposTap), for: .touchUpInside)
        button.backgroundColor = .systemGreen
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        bindViewModel()
//        viewModel.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Helpers
    
    private func bindViewModel() {
        
        viewModel.appUser.bind { [weak self] user in
            guard let user = user,
                  let self = self
            else { return }
            self.followersButton.updateAttributtedTitle("Followers:", "\(user.followers)")
            self.followingButton.updateAttributtedTitle("Following:", "\(user.following)")
            self.personalReposButton.updateAttributtedTitle("Personal repos:", "\(user.publicRepos)")
            self.userCell.setName(user.name ?? "")
            self.userCell.setUsername(user.login)
        }
        
        viewModel.starredRepos.bind { [weak self] starred in
            self?.starredReposButton.updateAttributtedTitle("Starred repositories:", "\(starred.count)")
        }

        viewModel.profileImage.bind { [weak self] image in
            guard let self = self,
                  let image = image else { return }
            self.userCell.setImage(image: image.roundedImage)
        }
    }
    
    // MARK: - Selectors
    
    @objc private func handleLogout() {
        viewModel.logUserOut()
        coordinator?.start()
    }
    
    @objc private func handleEdit() {
        coordinator?.presentEditUserViewController()
    }
    
    @objc private func handleButtonTap() {
        print((#function))
    }
    
    @objc private func handleFollowersTap() {
        coordinator?.presentAccountsViewController(accounts: viewModel.followers.value)
    }
    
    @objc private func handleFollowingTap() {
        coordinator?.presentAccountsViewController(accounts: viewModel.following.value)
    }
    
    @objc private func handlePersonalReposTap() {
        coordinator?.presentRepositoriesViewController(repositories: viewModel.publicRepos.value)
    }
    
    @objc private func handleStarredReposTap() {
        coordinator?.presentRepositoriesViewController(repositories: viewModel.starredRepos.value)
    }
    
    
    // MARK: - UI Configuration
    
    private func configureNavigationBar() {
        navigationItem.title = "GitHub User Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
    }
    
    private func configureUI() {
        view.backgroundColor = AppUI.appLightGreyColor
        let stack = UIStackView(arrangedSubviews: [userCell, followersButton, followingButton,
                                                   personalReposButton, starredReposButton])
        stack.axis = .vertical
        stack.spacing = AppUI.spacing
        stack.distribution = .fillProportionally
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: AppUI.spacing, paddingLeft: AppUI.spacing, paddingRight: AppUI.spacing)
    }
}
