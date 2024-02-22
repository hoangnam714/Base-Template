//___FILEHEADER___

import Foundation
import OSLog

typealias JSON = [String:Any]

class NetworkManager {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Network")
    
    func restAPI(url: String, method: RestApiMethod, parameter: JSON? = nil, isLog: Bool = false , _ completion: @escaping (Result<JSON, Error>) -> Void){
        if Reachability.isConnectedToNetwork() == false {
            completion(.failure(API_ERROR.noInternet))
            return
        }
        guard let url = URL(string: url) else {
            //            completion(.failure(API_ERROR.invalidURL))
            //            self.exportLog(isLog: isLog, result: .failure(API_ERROR.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue
        if let parameter = parameter {
            let data = try? JSONSerialization.data(withJSONObject: parameter)
            request.httpBody = data
        }
        
        URLSession.shared.dataTask(with: request) { data, respons, error in
            if let error = error  {
                completion(.failure(error))
                self.exportLog(isLog: isLog,result: .failure(error))
                return
            }
            if let data = data {
                do {
                    guard let json =  try JSONSerialization.jsonObject(with: data) as? JSON  else {
                        completion(.failure(API_ERROR.invailidData))
                        self.exportLog(isLog: isLog, result: .failure(API_ERROR.invailidData))
                        return
                    }
                    completion(.success(json))
                    self.exportLog(isLog: isLog, result: .success(json))
                    
                } catch {
                    completion(.failure(API_ERROR.invailidData))
                    self.exportLog(isLog: isLog,result: .failure(API_ERROR.invailidData))
                }
            }
        }.resume()
    }
    
    private func exportLog(isLog: Bool, message: String? = nil, result: Result<JSON, Error>) {
#if DEBUG
        if isLog == false {
            return
        }
        var description = ""
        if let message = message {
            description.append("Message: \(message)\n")
        }
        switch result {
        case .success(let json):
            description.append("JSON: \(String(describing: json))")
            logger.debug("\(description)")
        case .failure(let error):
            description.append("ERROR: \(error.localizedDescription)")
            logger.error("\(description)")
        }
#endif
    }

    //MARK: - Only work with alamofire
// func requestJSON(_ endpoint: Endpoint ,isLog: Bool = false, _ completion: @escaping (Result<JSON, Error>) -> Void){
//         if Reachability.isConnectedToNetwork() == false {
//             completion(.failure(API_ERROR.noInternet))
//             return
//         }
//         guard let url = URL(string: endpoint.url) else {
//             completion(.failure(API_ERROR.invalidURL))
//             self.exportLog(isLog: isLog, result: .failure(API_ERROR.invalidURL))
//             return
//         }
//         AF.request(url, method: endpoint.method, parameters: endpoint.parameter, encoding: getEndcoding(endpoint.method), headers: endpoint.header ).responseData { response in
//             switch response.result {
//             case .success(let data):
//                 do {
//                     guard let json =  try JSONSerialization.jsonObject(with: data) as? JSON  else {
//                         completion(.failure(API_ERROR.invailidData))
//                         self.exportLog(isLog: isLog, result: .failure(API_ERROR.invailidData))
//                         return
//                     }
//                     completion(.success(json))
//                     self.exportLog(isLog: isLog, result: .success(json))
                    
//                 } catch {
//                     completion(.failure(API_ERROR.invailidData))
//                     self.exportLog(isLog: isLog, result: .failure(API_ERROR.invailidData))
//                 }
//             case .failure(let error):
//                 completion(.failure(error))
//                 self.exportLog(isLog: isLog, result: .failure(error))
//             }
//         }.cURLDescription { description in
//             if isLog {
//                 self.logger.debug("\(description)")
//             }
//         }
//     }
    
//     func requestData(_ endpoint: Endpoint, isLog: Bool = false , _ completion: @escaping (Result<Data, Error>) -> Void){
//         if Reachability.isConnectedToNetwork() == false {
//             completion(.failure(API_ERROR.noInternet))
//             return
//         }
//         guard let url = URL(string: endpoint.url) else {
//             completion(.failure(API_ERROR.invalidURL))
//             self.exportLog(isLog: isLog, result: .failure(API_ERROR.invalidURL))
//             return
//         }
//         AF.request(url, method: HTTPMethod.get, parameters: endpoint.parameter, encoding: getEndcoding(endpoint.method), headers: endpoint.header ).responseData { response in
//             switch response.result {
//             case .success(let data):
//                 do {
//                     guard let json =  try JSONSerialization.jsonObject(with: data) as? JSON  else {
//                         completion(.failure(API_ERROR.invailidData))
//                         self.exportLog(isLog: isLog, result: .failure(API_ERROR.invailidData))
//                         return
//                     }
//                     completion(.success(data))
//                     self.exportLog(isLog: isLog, result: .success(json))
                    
//                 } catch {
//                     completion(.failure(API_ERROR.invailidData))
//                     self.exportLog(isLog: isLog,result: .failure(API_ERROR.invailidData))
//                 }
//             case .failure(let error):
//                 completion(.failure(API_ERROR.invailidResponse))
//                 self.exportLog(isLog: isLog,result: .failure(error))
//             }
//         }.cURLDescription { description in
//             if isLog {
//                 self.logger.debug("\(description)")
//             }
//         }
//     }
    
//    private func getEndcoding(_ method: HTTPMethod) -> ParameterEncoding {
//        switch method {
//        case .get :
//            return URLEncoding.default
//        default :
//            return JSONEncoding.default
//        }
//    }

}

//struct Endpoint {
//    var url: String
//    var method: HTTPMethod
//    var parameter: JSON? = nil
//    var header: HTTPHeaders? = nil
//}

enum RestApiMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct API_ERROR {
    static let invalidURL = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "URL invalid"])
    static let invailidResponse = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "Respose invalid"])
    static let invailidData = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "Data response invalid"])
    static let noInternet = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "Unable to connect to the Internet, please check your connection again!"])
    static let unknown = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "Something error"])
}
