import UIKit

class AppUserViewController: UIViewController {

    // MARK: - Properties
    
    var starredRepos: [Repository] = []
    
    weak var coordinator: MainCoordinator?
    // viewModel
    var appSessionManager: AppSessionManager!
    var networkManager: NetworkManager!
    
    init(networkManager: NetworkManager, appSessionManager: AppSessionManager) {
        self.appSessionManager = appSessionManager
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private let userProfileImage: UIImageView = {
        let image = UIImage(named: "github_avatar")!
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
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
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
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
        navigationItem.title = "GitHub User Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
        
        configureUI()
        
        fetchStarredRepos()
        fetchFollowedAccounts()
        fetchFollowers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fillUIWithUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Helpers
    
    private func fillUIWithUserData() {
        userFullName.text = appSessionManager.appUser?.name
        userName.text = appSessionManager.appUser?.login
        followersButton.updateAttributtedTitle("Followers:", "\(appSessionManager.appUser!.followers)")
        followingButton.updateAttributtedTitle("Following:", "\(appSessionManager.appUser!.following)")
        personalReposButton.updateAttributtedTitle("Personal repos:", "\(appSessionManager.appUser!.publicRepos)")
        starredReposButton.updateAttributtedTitle("Starred repositories:", "\(starredRepos.count)")
    }
    
    private func fetchStarredRepos() {
        let userLogin = appSessionManager.appUser?.login
        let endpoint = EndpointCases.getUsersStarredRepos(login: userLogin!)
        networkManager.getUsersStaredRepos(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let repos):
                DispatchQueue.main.async {
                    self.starredRepos = repos
                    self.fillUIWithUserData()
                }
            }
        }
    }
    
    private func fetchFollowedAccounts() {
        let userLogin = appSessionManager.appUser?.login
        let endpoint = EndpointCases.getUsersFollowedAccounts(login: userLogin!)
        networkManager.getFollowedAccounts(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let followedAccounts):
                self.appSessionManager.usersFollowedAccounts = followedAccounts
                DispatchQueue.main.async {
                    self.fillUIWithUserData()
                }
            }
        }
    }
    
    private func fetchFollowers() {
        let userLogin = appSessionManager.appUser?.login
        let endpoint = EndpointCases.getUsersFollowers(login: userLogin!)
        networkManager.getFollowers(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let followers):
                self.appSessionManager.usersFollowers = followers
                DispatchQueue.main.async {
                    self.fillUIWithUserData()
                }
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc private func handleButtonPress() {
        print("DEBUG: Button just got pressed")
    }
    
    @objc private func handleLogout() {
        appSessionManager.logUserOut()
        coordinator?.restart()
    }
    
    @objc private func handleEdit() {
        print("DEBUG: Will edit profile from here")
    }
    
    @objc private func handleButtonTap() {
        print((#function))
    }
    
    @objc private func handleFollowersTap() {
        coordinator?.presentFollowersViewController()
    }
    
    @objc private func handleFollowingTap() {
        coordinator?.presentFollowingAccountsViewController()
    }
    
    @objc private func handlePersonalReposTap() {
        print((#function))
    }
    
    @objc private func handleStarredReposTap() {
        print((#function))
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
