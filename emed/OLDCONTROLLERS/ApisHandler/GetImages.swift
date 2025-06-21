
import Foundation
import Alamofire

class GetImages {
    
    func get(completion: @escaping (Bool, Any) -> Void){
        
        guard let url = URL(string: "https://www.emeds.pk/api02/banners") else {
          completion(false, "Url not exist. Please contact with spport")
          return
        }
        
        AF.request(url, method: .get).responseDecodable(of: GetImagesModal.self) { (response) in
            let modal = response.value
            switch response.result {
                case .success(_):
                    if modal?.status ?? false {
                        var imagesArray: [String] = []
                        for object in modal!.data {
                            let url = object?.ImageURL
                            imagesArray.append(url!)
                        }
                        completion(true, imagesArray)
                    } else {
                        completion(false, modal?.action ?? "error.")
                    }
                    break
                case .failure(let error):
                    print("Update api error", error)
                    completion(false, error.errorDescription ?? "error Occure")
                    break
            }
          }
    }
    
}

struct GetImagesModal: Decodable {
    var status: Bool
    var action: String?
    var data: [ImagesData?]
    
}
struct ImagesData:Decodable {
    var Slide: Int?
    var ImageURL: String?
}
