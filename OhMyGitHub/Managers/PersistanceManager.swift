import Foundation

protocol PersistanceCoordinator {
    func save<T: Codable>(_ data: T, title: String) throws
    func load<T: Codable>(title: String) throws -> T
    func deletePersistedUserData()
}

final class PersistanceManager: PersistanceCoordinator {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let userDefaults = UserDefaults.standard
    private let keychain = KeychainSwift()
    
    public func save<T: Codable>(_ data: T, title: String) throws {
        let data = try encoder.encode(data)
        userDefaults.set(data, forKey: title)
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
        userDefaults.removeObject(forKey: "Token Data")
    }
    
    enum Error: Swift.Error {
        case dataNotFound
    }
}
