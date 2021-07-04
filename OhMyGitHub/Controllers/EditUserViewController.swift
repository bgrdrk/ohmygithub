import UIKit

class EditUserViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: EditUserViewModel
    
    weak var coordinator: MainCoordinator?
    
    init(viewModel: EditUserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private let nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "New name"
        return field
    }()
    
    private let companyTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "New company name"
        return field
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return button
    }()
 
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Edit User Data"
        viewModel.start()
        configureUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Helpers
    
    private func bindViewModel() {
        viewModel.onUserUpdate = { [weak self] in
            guard let self = self else { return }
            self.coordinator?.restart()
        }
    }

    // MARK: - Selectors
        
    @objc private func handleTap() {
        print("tapped....")
        viewModel.handleUserUpdate()
    }
    
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        
        let stack = UIStackView(arrangedSubviews: [nameTextField, companyTextField, submitButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 30, paddingRight: 30)
        stack.center(inView: view)
    }
}

