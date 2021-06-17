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
        return imageView
    }()
    
    private let userFullName: UILabel = {
        let label = AppUI.h1Label(withText: "userFullName", and: 15)
        return label
    }()
    
    private let userName: UILabel = {
        let label = AppUI.h1Label(withText: "username", and: 15)
        return label
    }()
    
    private let temporaryButton: UIButton = {
        let button = AppUI.actionButton(withText: "Press me please")
        button.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray2
        navigationItem.title = "GitHub User Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleLogout))
        
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
    }
    
    // MARK: - Selectors
    
    @objc private func handleButtonPress() {
        print("DEBUG: Button just got pressed")
    }
    
    @objc private func handleLogout() {
        appSessionManager.logUserOut()
        coordinator?.restart()
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        
        let stack = UIStackView(arrangedSubviews: [userProfileImage, userFullName, userName, temporaryButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillProportionally
        
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor, right: view.rightAnchor,
                     paddingLeft: 40, paddingRight: 40)
        stack.center(inView: view)
    }
}
