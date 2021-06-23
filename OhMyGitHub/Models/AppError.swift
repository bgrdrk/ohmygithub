enum AppError: Error {
    
    case firstError
    case decodingFailed
    
    var description: String {
        switch self {
        case .firstError:
            return "First error delivered."
        case .decodingFailed:
            return "Decoding of data to Model failed"
        }
    }
}
