import UIKit

class PublicUserViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: PublicUserViewModel
    
    weak var coordinator: MainCoordinator?
    
    init(viewModel: PublicUserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private let userProfileImage: UIImageView = {
        let image = UIImage(named: "github_avatar")!
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
//        imageView.layer.cornerRadius = 16
//        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let userFullName: UILabel = {
        let label = AppUI.h1Label(withText: "userFullName")
        return label
    }()
    
    private let userName: UILabel = {
        let label = AppUI.h1Label(withText: "username")
        return label
    }()
    
    private let followButton: UIButton = {
        let button = AppUI.actionButton(withText: "FollowUnfollow")
        button.addTarget(self, action: #selector(handleFollowTap), for: .touchUpInside)
        return button
    }()
    
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
        
        view.backgroundColor = .white
        navigationItem.title = "Public GitHub User"
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
        
        viewModel.profileImage.bind { [weak self] image in
            guard let self = self else { return }
            self.userProfileImage.image = image
        }
        
        viewModel.onUserIsAppUser = { [weak self] isAppUser in
            guard let self = self else { return }
            self.followButton.isHidden = isAppUser
        }
        
        viewModel.account.bind { [weak self] account in
            guard let account = account,
                  let self = self
            else { return }
            self.userName.text = account.login
        }
        
        viewModel.user.bind { [weak self] user in
            guard let user = user,
                  let self = self
            else { return }
            self.userFullName.text = user.name ?? ""
            self.userName.text = user.login
            self.followersButton.updateAttributtedTitle("Followers:", "\(user.followers)")
            self.followingButton.updateAttributtedTitle("Following:", "\(user.following)")
            self.personalReposButton.updateAttributtedTitle("Personal repos:", "\(user.publicRepos)")
        }
        
        viewModel.starredRepos.bind { [weak self] starred in
            self?.starredReposButton.updateAttributtedTitle("Starred repositories:", "\(starred.count)")
        }
        
        viewModel.presentedUserIsFolloweByAppUser.bind { [weak self] isFollowed in
            let buttonName = isFollowed ? "Unfollow" : "Follow"
            self?.followButton.updateAttributtedTitle(buttonName, "")
        }
    }

    // MARK: - Selectors
        
    @objc private func handleFollowTap() {
        viewModel.followUnfollowUser()
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
    
    private func configureUI() {
        
        userProfileImage.setDimensions(width: 100, height: 100)
        
        let stack = UIStackView(arrangedSubviews:
                                [userProfileImage, userFullName, userName, followButton,
                                 followersButton, followingButton, personalReposButton, starredReposButton])
        stack.axis = .vertical
        stack.spacing = 20
//        stack.distribution = .fill
        
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor, right: view.rightAnchor,
                     paddingLeft: 40, paddingRight: 40)
        stack.center(inView: view)
    }
}
