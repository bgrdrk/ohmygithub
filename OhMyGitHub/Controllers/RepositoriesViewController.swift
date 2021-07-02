import UIKit

class RepositoriesViewController: UIViewController {
    
    // MARK: - Properties

    weak var coordinator: MainCoordinator?
    private let tableView = UITableView()
    private let viewModel: RepositoriesViewModel
    
    init(viewModel: RepositoriesViewModel) {
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
        navigationItem.title = "Repositories List"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        configureUI()
        bindViewModel()
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.addConstraintsToFillView(view)
    }
    
    private func bindViewModel() {
        viewModel.repositories.bind { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
}

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.repositories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell? else { return UITableViewCell() }
        cell.textLabel?.text = viewModel.repositories.value[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.presentRepositoryViewController(for: viewModel.repositories.value[indexPath.row])
    }
}

