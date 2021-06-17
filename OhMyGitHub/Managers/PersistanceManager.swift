import Foundation

final class PersistanceManager {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let userDefaults = UserDefaults.standard
    private let keychain = KeychainSwift()
    
    public func save<T: Codable>(_ data: T, title: String) throws {
        let data = try encoder.encode(data)
        keychain.set(data, forKey: title)
    }
    
    public func load<T: Codable>(title: String) throws -> T {
        guard let data = keychain.getData(title),
              let decodedData = try? decoder.decode(T.self, from: data)
        else {
            throw Error.dataNotFound
        }
        return decodedData
    }
    
    public func deletePersistedUserData() {
        keychain.clear()
    }
    
    enum Error: Swift.Error {
        case dataNotFound
    }
}
