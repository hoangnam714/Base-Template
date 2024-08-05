//___FILEHEADER___

import Foundation

struct API_ERROR {
    static let invalidURL = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "URL invalid"])
    static let invailidResponse = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Respose invalid"])
    static let invailidData = NSError(domain: "", code: 422, userInfo: [NSLocalizedDescriptionKey: "Data response invalid"])
    static let noInternet = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unable to connect to the Internet, please check your connection again!"])
    static let unknown = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Something error"])
}
