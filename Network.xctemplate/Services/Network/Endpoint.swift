//___FILEHEADER___

import Foundation
import Alamofire

struct Endpoint {
    var url: String
    var method: HTTPMethod
    var parameter: JSON? = nil
    var header: HTTPHeaders? = nil
}
