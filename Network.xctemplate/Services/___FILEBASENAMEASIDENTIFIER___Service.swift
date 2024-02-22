//___FILEHEADER___

import Foundation

class ___FILEBASENAMEASIDENTIFIER___ {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
//    func get_Example(_ success: @escaping (BlogModel) -> Void, failure: @escaping (Error) -> Void) {
//        let endpoint = Endpoint(url: "https://goole.com", method: .get, parameter: [:])
//        networkManager.requestJSON(endpoint, isLog: true) { (response) in
//            switch response {
//            case .success(let json):
//                guard let artcile = Mapper<Model>().map(JSON: json) else {
//                    failure(ResponseError.invailidJSON)
//                    return
//                }
//                success(artcile)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
    
}
