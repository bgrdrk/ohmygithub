import UIKit

class PublicGitHubUserViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: PublicGitHubUserViewModel
    
    weak var coordinator: MainCoordinator?
    
    init(viewModel: PublicGitHubUserViewModel) {
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
        navigationItem.title = "Public GitHub User"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
        
        configureUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.start()
    }
    
    // MARK: - Helpers
    
    private func bindViewModel() {
        
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
        
        viewModel.followers.bind { [weak self] followers in
            self?.followersButton.updateAttributtedTitle("Followers:", "\(followers.count)")
        }

    }

    // MARK: - Selectors
    
    @objc private func handleButtonPress() {
        print((#function))
    }
    
    @objc private func handleLogout() {
        print((#function))
    }
    
    @objc private func handleEdit() {
        print((#function))
    }
    
    @objc private func handleButtonTap() {
        print((#function))
    }
    
    @objc private func handleFollowersTap() {
        print((#function))
    }
    
    @objc private func handleFollowingTap() {
        print((#function))
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
