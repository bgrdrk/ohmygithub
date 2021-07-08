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

    private let indicator = IndicatorView()
    private let userCell = UserCellView()
    private let followersTitle = SectionTitleView(icon: UIImage(systemName: "person.2.circle")!, title: "Followers")
    private let repositoriesTitle = SectionTitleView(icon: UIImage(systemName: "folder.circle")!, title: "Repositories")
    
    private let followButton: UIButton = {
        let button = AppUI.actionButton(withText: "")
        button.addTarget(self, action: #selector(handleFollowTap), for: .touchUpInside)
        return button
    }()
    
    private let followersButton: CustomButtonView = {
        let buttonView = CustomButtonView(frame: .zero)
        buttonView.configure(title: "0", description: "followers")
        buttonView.addTarget(self, action: #selector(handleFollowersTap), for: .touchUpInside)
        return buttonView
    }()
    
    private let followingButton: CustomButtonView = {
        let buttonView = CustomButtonView(frame: .zero)
        buttonView.configure(title: "0", description: "following")
        buttonView.addTarget(self, action: #selector(handleFollowingTap), for: .touchUpInside)
        return buttonView
    }()
    
    private let personalReposButton: CustomButtonView = {
        let buttonView = CustomButtonView(frame: .zero)
        buttonView.configure(title: "0", description: "personal")
        buttonView.addTarget(self, action: #selector(handlePersonalReposTap), for: .touchUpInside)
        return buttonView
    }()
    
    private let starredReposButton: CustomButtonView = {
        let buttonView = CustomButtonView(frame: .zero)
        buttonView.configure(title: "0", description: "starred")
        buttonView.addTarget(self, action: #selector(handleStarredReposTap), for: .touchUpInside)
        return buttonView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.userCell.setImage(image: image.roundedImage)
        }
        
        viewModel.onUserIsAppUser = { [weak self] isAppUser in
            guard let self = self else { return }
            self.followButton.isHidden = isAppUser
        }
        
        viewModel.user.bind { [weak self] user in
            guard let user = user,
                  let self = self
            else { return }
            self.followersButton.changeTitle(to: "\(user.followers)")
            self.followingButton.changeTitle(to: "\(user.following)")
            self.personalReposButton.changeTitle(to: "\(user.publicRepos)")
            self.userCell.setName(user.name ?? "")
            self.userCell.setUsername(user.login)
        }
        
        viewModel.starredRepos.bind { [weak self] starred in
            self?.starredReposButton.changeTitle(to: "\(starred.count)")
        }
        
        viewModel.presentedUserIsFolloweByAppUser.bind { [weak self] isFollowed in
            var buttonName = ""
            if let isFollowed = isFollowed {
                buttonName = isFollowed ? "Unfollow" : "Follow"
            } 
            self?.followButton.updateAttributtedTitle(buttonName, "")
        }

        viewModel.dataFetchCounter.bind { [weak self] count in
            self?.indicator.isHidden = count == 5
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
        indicator.start()
        view.backgroundColor = AppUI.appColor(.lightGrey)
        let followersStack = UIStackView(arrangedSubviews: [followersButton, followingButton])
        followersStack.axis = .horizontal
        followersStack.spacing = AppUI.spacing
        followersStack.distribution = .fillEqually
        
        let reposStack = UIStackView(arrangedSubviews: [personalReposButton, starredReposButton])
        reposStack.axis = .horizontal
        reposStack.spacing = AppUI.spacing
        reposStack.distribution = .fillEqually
        
        let stack = UIStackView(arrangedSubviews: [userCell, followButton, followersTitle, followersStack,
                                                   repositoriesTitle, reposStack])
        stack.axis = .vertical
        stack.spacing = AppUI.spacing
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: AppUI.spacing + 10, paddingLeft: AppUI.spacing + 10, paddingRight: AppUI.spacing + 10)

        view.addSubview(indicator)
        indicator.addConstraintsToFillView(view)
    }
}
