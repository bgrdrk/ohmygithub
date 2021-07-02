import UIKit

class UsersViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: UsersViewModel
    private let tableView = UITableView()
    weak var coordinator: MainCoordinator?
    
    init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
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
        tableView.register(UserCellTableViewCell.self, forCellReuseIdentifier: "userCell")
        
        configureUI()
        bindViewModel()
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.addConstraintsToFillView(view)
    }
    
    private func bindViewModel() {
        viewModel.accounts.bind { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.accounts.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCellTableViewCell
        let viewModel = UserCellViewModel(networkManager: viewModel.networkManager,
                                          account: viewModel.accounts.value[indexPath.row])
        cell?.configureCell(with: viewModel)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.presentPublicGitHubUserViewController(for: viewModel.accounts.value[indexPath.row])
    }
}
