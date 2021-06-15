enum AppError: Error {
    
    case firstError
    case decodingFailed
    
    var message: String {
        switch self {
        case .firstError:
            return "First error delivered."
        case .decodingFailed:
            return "Decoding of data to Model failed"
        }
    }
}
