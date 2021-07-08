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

    private let indicator = IndicatorView()
    private let userCell = UserCellView()
    private let followersTitle = SectionTitleView(icon: UIImage(systemName: "person.2.circle")!, title: "Followers")
    private let repositoriesTitle = SectionTitleView(icon: UIImage(systemName: "folder.circle")!, title: "Repositories")
    
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
        configureNavigationBar()
        bindViewModel()
        viewModel.start()
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
            self.followersButton.changeTitle(to: "\(user.followers)")
            self.followingButton.changeTitle(to: "\(user.following)")
            self.personalReposButton.changeTitle(to: "\(user.publicRepos)")
            self.userCell.setName(user.name ?? "")
            self.userCell.setUsername(user.login)
        }
        
        viewModel.starredRepos.bind { [weak self] starred in
            self?.starredReposButton.changeTitle(to: "\(starred.count)")
        }

        viewModel.profileImage.bind { [weak self] image in
            guard let self = self,
                  let image = image else { return }
            self.userCell.setImage(image: image.roundedImage)
        }

        viewModel.dataFetchCounter.bind { [weak self] count in
            self?.indicator.isHidden = count == 5
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
        let logoutIcon = UIImage(systemName: "xmark.circle")!
        let logoutBarButtonItem = UIBarButtonItem(image: logoutIcon,
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(handleLogout))
        
        navigationItem.leftBarButtonItem = logoutBarButtonItem
        
        let settingsIcon = UIImage(systemName: "gearshape.fill")!
        let settingsBarButtonItem = UIBarButtonItem(image: settingsIcon,
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(handleEdit))
        
        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }
    
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
        
        let stack = UIStackView(arrangedSubviews: [userCell, followersTitle, followersStack,
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
