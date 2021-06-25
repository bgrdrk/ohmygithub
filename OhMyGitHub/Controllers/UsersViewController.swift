import UIKit

class UsersViewController: UIViewController {
    
    // MARK: - Properties

    weak var coordinator: MainCoordinator?
    
    var accounts: [GitHubAccount] = []
    
    private let tableView = UITableView()
    
    init(accounts: [GitHubAccount]) {
        self.accounts = accounts
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
        tableView.addConstraintsToFillView(view)
    }
}


extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell? else { return UITableViewCell() }
        cell.textLabel?.text = accounts[indexPath.row].login
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.presentPublicGitHubUserViewController(for: accounts[indexPath.row])
    }
}
