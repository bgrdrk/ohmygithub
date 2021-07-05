import UIKit

class EditUserViewModel {
    private let networkManager: NetworkManager!
    private let appSessionManager: AppSessionManager!
    
    var onUserUpdate: (() -> Void)?
    
    init(networkManager: NetworkManager, appSessionManager: AppSessionManager)
    {
        self.networkManager = networkManager
        self.appSessionManager = appSessionManager
    }
    
    func start() {
        
    }
    
    // MARK: - Helpers
    
    func handleUserUpdate(_ newData: UpdatedUser) {
        
        networkManager.updateAppUser(newData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // TODO: Handle error swiftly
                print("DEBUG: error -> \(error.description)")
            case .success(let updatedUser):
                self.appSessionManager.saveUserData(updatedUser)
                DispatchQueue.main.async {
                    self.onUserUpdate?()
                }
            }
        }
    }

}

    // MARK: - Network calls

private extension EditUserViewModel {
    
    
}

