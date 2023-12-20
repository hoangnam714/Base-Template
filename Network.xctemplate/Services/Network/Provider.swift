//___FILEHEADER___
import Foundation

class Provider {
    
    static let share = Provider()
    private init(){}
    private let networkManager = NetworkManager()
    
    //TODO:- Service 
    //Ex:
    // var homeService: HomeService {
    //     get { return HomeService(networkManager: networkManager) }
    // }
}
