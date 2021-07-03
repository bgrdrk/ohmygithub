import UIKit

protocol PersistanceCoordinator {
    var cache: NSCache<NSString, UIImage> { get }
    func save<T: Codable>(_ data: T, title: String)
    func load<T: Codable>(title: String) throws -> T
    func deleteAllPersistedData()
    func deletePersistedUserData()
    func deletePersistedTokenData()
}

final class PersistanceManager: PersistanceCoordinator {
    
    let cache = NSCache<NSString, UIImage>()
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let userDefaults = UserDefaults.standard
    private let keychain = KeychainSwift()
    
    public func save<T: Codable>(_ data: T, title: String) {
        do {
            let data = try encoder.encode(data)
            userDefaults.set(data, forKey: title)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    public func load<T: Codable>(title: String) throws -> T {
        guard let data = userDefaults.data(forKey: title),
              let decodedData = try? decoder.decode(T.self, from: data)
        else {
            throw Error.dataNotFound
        }
        return decodedData
    }
    
    public func deletePersistedUserData() {
        userDefaults.removeObject(forKey: "User Data")
    }
    
    public func deletePersistedTokenData() {
        userDefaults.removeObject(forKey: "User Data")
    }
    
    public func deleteAllPersistedData() {
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
        userDefaults.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
    
    enum Error: Swift.Error {
        case dataNotFound
    }
}
