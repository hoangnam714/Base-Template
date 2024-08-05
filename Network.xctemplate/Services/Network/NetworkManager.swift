//___FILEHEADER___

import Foundation
import Alamofire
import OSLog

typealias JSON = [String:Any]

class NetworkManager {
    
    //MARK: - Only work with alamofire
    func requestJSON(_ endpoint: Endpoint, isLog: Bool = false, _ completion: @escaping (Result<JSON, Error>) -> Void){
        if Reachability.isConnectedToNetwork() == false {
            completion(.failure(API_ERROR.noInternet))
            return
        }
        guard let url = URL(string: endpoint.url) else {
            completion(.failure(API_ERROR.invalidURL))
            self.exportLog(isLog: isLog, result: .failure(API_ERROR.invalidURL))
            return
        }
        AF.request(url, method: endpoint.method, parameters: endpoint.parameter, encoding: getEndcoding(endpoint.method), headers: endpoint.header ).responseData { response in
            switch response.result {
            case .success(let data):
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
                    self.exportLog(isLog: isLog, result: .failure(API_ERROR.invailidData))
                }
            case .failure(let error):
                completion(.failure(error))
                self.exportLog(isLog: isLog, result: .failure(error))
            }
        }.cURLDescription { description in
            if isLog {
                self.logger.debug("\(description)")
            }
        }
    }
    
    func download(destinationURL: URL, fileURl: URL?, isLog: Bool = false, dowloadProgress: @escaping (Double) -> Void, _ completion: @escaping (Result<URL?, Error>) -> Void){
        let downloadDestination: DownloadRequest.Destination = { _, _ in
            return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        if Reachability.isConnectedToNetwork() == false {
            completion(.failure(API_ERROR.noInternet))
            return
        }
        guard let fileURl = fileURl else {
            completion(.failure(API_ERROR.invalidURL))
            self.exportLog(isLog: isLog, result: .failure(API_ERROR.invalidURL))
            return
        }
        DispatchQueue(label: "com.app.download", qos: .background).async {
            AF.download(fileURl, to: downloadDestination).response { response in
                switch response.result {
                case .success(let url):
                    DispatchQueue.main.async {
                        completion(.success(url))
                        self.exportLog(isLog: isLog, result: .success(url!))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        self.exportLog(isLog: isLog, result: .failure(error))
                    }
                }
            }
            .downloadProgress { progress in
                DispatchQueue.main.async {
                    dowloadProgress(progress.fractionCompleted)
                }
            }
            .cURLDescription { description in
                if isLog {
                    self.logger.debug("\(description)")
                }
            }
        }
    }
    
    func requestData(_ endpoint: Endpoint, isLog: Bool = false , _ completion: @escaping (Result<Data, Error>) -> Void){
        if Reachability.isConnectedToNetwork() == false {
            completion(.failure(API_ERROR.noInternet))
            return
        }
        guard let url = URL(string: endpoint.url) else {
            completion(.failure(API_ERROR.invalidURL))
            self.exportLog(isLog: isLog, result: .failure(API_ERROR.invalidURL))
            return
        }
        AF.request(url, method: HTTPMethod.get, parameters: endpoint.parameter, encoding: getEndcoding(endpoint.method), headers: endpoint.header ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    guard let json =  try JSONSerialization.jsonObject(with: data) as? JSON  else {
                        completion(.failure(API_ERROR.invailidData))
                        self.exportLog(isLog: isLog, result: .failure(API_ERROR.invailidData))
                        return
                    }
                    completion(.success(data))
                    self.exportLog(isLog: isLog, result: .success(json))
                    
                } catch {
                    completion(.failure(API_ERROR.invailidData))
                    self.exportLog(isLog: isLog,result: .failure(API_ERROR.invailidData))
                }
            case .failure(let error):
                completion(.failure(API_ERROR.invailidResponse))
                self.exportLog(isLog: isLog,result: .failure(error))
            }
        }.cURLDescription { description in
            if isLog {
                self.logger.debug("\(description)")
            }
        }
    }
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Network")

    private func exportLog(isLog: Bool, message: String? = nil, result: Result<Any, Error>) {
        #if DEBUG
        if isLog == false {
            return
        }
        var description = ""
        if let message = message {
            description.append("Message: \(message)\n")
        }
        switch result {
        case .success(let response):
            description.append("Response: \(String(describing: response))")
            logger.debug("\(description)")
        case .failure(let error):
            description.append("ERROR: \(error.localizedDescription)")
            logger.error("\(description)")
        }
        #endif
    }

    private func getEndcoding(_ method: HTTPMethod) -> ParameterEncoding {
        switch method {
        case .get :
            return URLEncoding.default
        default :
            return JSONEncoding.default
        }
    }
    
    //    func restAPI(url: String, method: RestApiMethod, parameter: JSON? = nil, isLog: Bool = false , _ completion: @escaping (Result<JSON, Error>) -> Void){
    //        if Reachability.isConnectedToNetwork() == false {
    //            completion(.failure(API_ERROR.noInternet))
    //            return
    //        }
    //        guard let url = URL(string: url) else {
    //            //            completion(.failure(API_ERROR.invalidURL))
    //            //            self.exportLog(isLog: isLog, result: .failure(API_ERROR.invalidURL))
    //            return
    //        }
    //        var request = URLRequest(url: url)
    //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    //        request.setValue("application/json", forHTTPHeaderField: "Accept")
    //        request.httpMethod = method.rawValue
    //        if let parameter = parameter {
    //            let data = try? JSONSerialization.data(withJSONObject: parameter)
    //            request.httpBody = data
    //        }
    //
    //        URLSession.shared.dataTask(with: request) { data, respons, error in
    //            if let error = error  {
    //                completion(.failure(error))
    //                self.exportLog(isLog: isLog,result: .failure(error))
    //                return
    //            }
    //            if let data = data {
    //                do {
    //                    guard let json =  try JSONSerialization.jsonObject(with: data) as? JSON  else {
    //                        completion(.failure(API_ERROR.invailidData))
    //                        self.exportLog(isLog: isLog, result: .failure(API_ERROR.invailidData))
    //                        return
    //                    }
    //                    completion(.success(json))
    //                    self.exportLog(isLog: isLog, result: .success(json))
    //
    //                } catch {
    //                    completion(.failure(API_ERROR.invailidData))
    //                    self.exportLog(isLog: isLog,result: .failure(API_ERROR.invailidData))
    //                }
    //            }
    //        }.resume()
    //    }
    //
}
