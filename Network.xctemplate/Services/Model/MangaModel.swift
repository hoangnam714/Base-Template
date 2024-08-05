//___FILEHEADER___

import Foundation
import ObjectMapper

struct MangaModel: Mappable {
    var id: String
    
    init?(map: Map) {
        self.id = ""
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["id"]
    }
}
