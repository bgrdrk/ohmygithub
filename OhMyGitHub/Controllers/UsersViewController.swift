import UIKit

class UsersViewController: UIViewController {
    
    // MARK: - Properties

    weak var coordinator: MainCoordinator?
    var networkManager: NetworkManager!
    var appSessionManager: AppSessionManager!
    
    private let tableView = UITableView()
    
    init(networkManager: NetworkManager, appSessionManager: AppSessionManager) {
        self.networkManager = networkManager
        self.appSessionManager = appSessionManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Users List"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        configureUI()
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.safeAreaLayoutGuide.rightAnchor)
    }
}


extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appSessionManager.usersFollowedAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell? else { return UITableViewCell() }
        cell.textLabel?.text = appSessionManager.usersFollowedAccounts[indexPath.row].login
        return cell
    }
}
