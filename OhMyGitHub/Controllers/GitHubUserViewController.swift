import UIKit

class GitHubUserViewController: UIViewController {

    // MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var appSessionManager: AppSessionManager!
    
    init(appSessionManager: AppSessionManager) {
        self.appSessionManager = appSessionManager
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
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray2
        navigationItem.title = "GitHub User Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
        
        fillTheUserData()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Helpers
    
    private func fillTheUserData() {
        userFullName.text = appSessionManager.appUser?.name
        userName.text = appSessionManager.appUser?.login
        followersLabel.text = "Number of followers: \(appSessionManager.appUser!.followers)"
        followingLabel.text = "Number of following: \(appSessionManager.appUser!.following)"
        personalRepositories.text = "Number of personal repos: \(appSessionManager.appUser!.publicRepos)"
//        staredRepositories
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
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        
        userProfileImage.anchor(width: 120, height: 120)
        
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
