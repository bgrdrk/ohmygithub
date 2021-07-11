import UIKit

class EditUserViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: EditUserViewModel
    weak var coordinator: MainCoordinator?

    private var allFieldsAreEmpty: Bool {
        nameTextField.text!.isEmpty
        && companyTextField.text!.isEmpty
        && nameTextField.text!.isEmpty
        && twitterUsernameTextField.text!.isEmpty
    }
    
    init(viewModel: EditUserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    private lazy var nameTextField = AppUI.inputField(placeholder: "Enter new name")
    private lazy var companyTextField = AppUI.inputField(placeholder: "Company name")
    private lazy var locationTextField = AppUI.inputField(placeholder: "Current location")
    private lazy var twitterUsernameTextField = AppUI.inputField(placeholder: "Twitter account username")
    
    private lazy var nameContainer = AppUI.inputFieldContainerView(with: nameTextField)
    private lazy var companyContainer = AppUI.inputFieldContainerView(with: companyTextField)
    private lazy var locationContainer = AppUI.inputFieldContainerView(with: locationTextField)
    private lazy var twitterContainer = AppUI.inputFieldContainerView(with: twitterUsernameTextField)
    private let spacer = UIView()
    
    private let submitButton: UIButton = {
        let button = AppUI.actionButton(withText: "Submit")
        button.addTarget(self, action: #selector(handleSubmitTap), for: .touchUpInside)
        return button
    }()
 
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Edit User Data"

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
//            TODO: - update app user data
//            self.coordinator?.updateAppUser()
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Selectors
        
    @objc private func handleSubmitTap() {

        guard !allFieldsAreEmpty else {
            coordinator?.presentAlert(title: "All fields are empty", message: "Please fill at least one property to update")
            return
        }
        
        let name = nameTextField.text!.isEmpty ? nil : nameTextField.text!
        let company = companyTextField.text!.isEmpty ? nil : companyTextField.text!
        let location = locationTextField.text!.isEmpty ? nil : locationTextField.text!
        let twitterUsername = twitterUsernameTextField.text!.isEmpty ? nil : twitterUsernameTextField.text!
        
        let newUserData = UpdatedUser(name: name,
                                      company: company,
                                      location: location,
                                      twitterUsername: twitterUsername)
        
        viewModel.handleUserUpdate(newUserData)
    }
    
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        let spacing = AppUI.spacing + 10
        spacer.setDimensions(height: 3)
        view.backgroundColor = AppUI.appColor(.lightGrey)
        let stack = UIStackView(arrangedSubviews: [nameContainer, companyContainer,
                                                   locationContainer, twitterContainer, spacer])
        stack.axis = .vertical
        stack.spacing = 10
        stack.backgroundColor = .white
        stack.layer.cornerRadius = AppUI.cornerRadius
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: spacing,
                     paddingLeft: spacing,
                     paddingRight: spacing)

        view.addSubview(submitButton)
        submitButton.anchor(top: stack.bottomAnchor,
                            left: stack.leftAnchor,
                            right: stack.rightAnchor,
                            paddingTop: spacing)
    }
}

