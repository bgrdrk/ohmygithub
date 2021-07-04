import Foundation

class SearchViewModel {
    private(set) var searchOptions: [String]!
    private(set) var networkManager: NetworkManager
    
    var testArrayOfString = Observable([String]())
    
    init(networkManager: NetworkManager)
    {
        self.networkManager = networkManager
    }
    
    // TODO: Refactor here
    func start() {
        print("Starting the search VC")
        testArrayOfString.value = ["Repos", "People"]
    }
    
    // MARK: - Helpers
    
}
