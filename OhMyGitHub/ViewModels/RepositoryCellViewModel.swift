import UIKit

class RepositoryCellViewModel {
    
    var repository = Observable<Repository?>(nil)
    
    init(repository: Repository) {
        self.repository.value = repository
    }
    
    func start() {
        setFollowersCount()
    }
    
    private func setFollowersCount() {

    }
}

