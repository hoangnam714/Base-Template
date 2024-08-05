//___FILEHEADER___

import Foundation
import ObjectMapper

class ___FILEBASENAMEASIDENTIFIER___ {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
//    func getManga(_ completion: @escaping (Result<MangaModel, Error>) -> Void) {
//        let endpoint = Endpoint(url: "https://goole.com", method: .get, parameter: [:])
//        networkManager.requestJSON(endpoint, isLog: true) { (response) in
//            switch response {
//            case .success(let json):
//                guard let manga = Mapper<MangaModel>().map(JSON: json) else {
//                    completion(.failure(API_ERROR.invailidResponse))
//                    return
//                }
//                completion(.success(manga))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func getManga(_ success: @escaping (MangaModel) -> Void, failure: @escaping (Error) -> Void) {
//        let endpoint = Endpoint(url: "https://goole.com", method: .get, parameter: [:])
//        networkManager.requestJSON(endpoint, isLog: true) { (response) in
//            switch response {
//            case .success(let json):
//                guard let manga = Mapper<MangaModel>().map(JSON: json) else {
//                    failure(API_ERROR.invailidResponse)
//                    return
//                }
//                success(manga)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
    
}
