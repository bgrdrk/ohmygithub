import UIKit

class GitHubUserViewController: UIViewController {

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
    
    private let followersLabel: UILabel = {
        let label = AppUI.h2Label(withText: "Number of followers")
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = AppUI.h2Label(withText: "Number of following")
        return label
    }()
    
    private let personalRepositories: UILabel = {
        let label = AppUI.h2Label(withText: "Personal repositories")
        return label
    }()
    
    private let staredRepositories: UILabel = {
        let label = AppUI.h2Label(withText: "Starred repositories: **")
        return label
    }()
    
    private let followButton: UIButton = {
        let button = AppUI.actionButton(withText: "FollowUnfollow")
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "GitHub User Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
        
        fillUIWithUserData()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchStarredRepos()
        fetchFollowedAccounts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Helpers
    
    private func fillUIWithUserData() {
        userFullName.text = appSessionManager.appUser?.name
        userName.text = appSessionManager.appUser?.login
        followersLabel.text = "Number of followers: \(appSessionManager.appUser!.followers)"
        followingLabel.text = "Number of following: \(appSessionManager.appUser!.following)"
        personalRepositories.text = "Number of personal repos: \(appSessionManager.appUser!.publicRepos)"
        staredRepositories.text = "Starred repositories: \(starredRepos.count)"
    }
    
    private func fetchStarredRepos() {
        // TODO: There must be better way to format this string
        let urlString = appSessionManager.appUser!.starredUrl.split(separator: "{")
        guard let url = URL(string: String(urlString[0])) else { return }
        
        // https://api.github.com/users/bgrdrk/starred{/owner}{/repo}
        // try to build it with URL Builder instead of using data from back-end
        networkManager.getUsersStaredRepos(token: appSessionManager.token!.accessToken,
                                           url: url) { [weak self] result in
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
        // TODO: There must be better way to format this string
        let urlString = appSessionManager.appUser!.followingUrl.split(separator: "{")
        guard let url = URL(string: String(urlString[0])) else { return }
        
        networkManager.getFollowedAccounts(token: appSessionManager.token!.accessToken,
                                           url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let followedAccounts):
                DispatchQueue.main.async {
                    self.appSessionManager.usersFollowedAccounts = followedAccounts
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
        coordinator?.presentUsersViewController()
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        
        userProfileImage.anchor(width: 100, height: 100)
        
        let stack = UIStackView(arrangedSubviews:
                                [userProfileImage, userFullName, userName, followButton,
                                 followersLabel, followingLabel, personalRepositories, staredRepositories])
        stack.axis = .vertical
        stack.spacing = 20
//        stack.distribution = .fill
        
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor, right: view.rightAnchor,
                     paddingLeft: 40, paddingRight: 40)
        stack.center(inView: view)
    }
}
