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
    
    private let sortLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort repositories by:"
        return label
    }()
    
    private let sortPicker: UISegmentedControl = {
        let items = ["Name", "Stars count"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(sortingTypeDidChange), for: .valueChanged)
        return segmentedControl
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Repositories List"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: "repositoryCell")
        
        configureUI()
        viewModel.start()
        bindViewModel()
    }
    
    // MARK: - Selectors
    
    @objc private func sortingTypeDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.sortRepositoriesByName()
        case 1:
            viewModel.sortRepositoriesByStarsCount()
        default:
            print("This will never be reached.")
        }
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        tableView.tableFooterView = UIView()
        
        let sortStack = UIStackView(arrangedSubviews: [sortLabel, sortPicker])
        sortStack.axis = .vertical
        sortStack.distribution = .fillProportionally
        sortStack.spacing = 5
        
        view.addSubview(sortStack)
        view.addSubview(tableView)
        sortStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        sortStack.setDimensions(height: 60)
        tableView.anchor(top: sortStack.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10)
    }
    
    private func bindViewModel() {
        viewModel.sortedRepositories.bind { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
}

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sortedRepositories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as? RepositoryCell
        let viewModel = RepositoryCellViewModel(repository: viewModel.sortedRepositories.value[indexPath.row])
        cell?.configureCell(with: viewModel)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.presentRepositoryViewController(for: viewModel.sortedRepositories.value[indexPath.row])
    }
}

