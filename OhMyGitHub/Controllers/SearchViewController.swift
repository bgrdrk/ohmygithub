import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: SearchViewModel
    private let tableView = UITableView()
    weak var coordinator: MainCoordinator?
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let sortLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort by: "
        return label
    }()
    
    private let sortPicker: UISegmentedControl = {
        let items = ["Option 01", "Option 02"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(sortingTypeDidChange), for: .valueChanged)
        return segmentedControl
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Search Controller"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        configureUI()
        viewModel.start()
        bindViewModel()
    }
    
    // MARK: - Selectors
    
    @objc private func sortingTypeDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("Labas 01")
        case 1:
            print("Labas 02")
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
        viewModel.testArrayOfString.bind { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.testArrayOfString.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.largeContentTitle = viewModel.testArrayOfString.value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
//        coordinator?.presentPublicGitHubUserViewController(for: viewModel.sortedAccounts.value[indexPath.row])
    }
}

