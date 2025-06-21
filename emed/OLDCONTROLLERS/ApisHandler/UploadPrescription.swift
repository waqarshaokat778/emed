
import Foundation
import Alamofire

class UploadPrescription {
    
    func uploadImage(imageData : UIImage, completion: @escaping (Bool, Any) -> Void){
        print(type(of: imageData))
        let imgData = imageData.jpegData(compressionQuality: 0.2)!
        print(imgData,type(of: imgData))
        let dict = UserDefaults.standard.object(forKey: "UserModal") as? [String: String] ?? [:]
        let parameters = ["id": dict["Id"] ?? "-1"]
        print(parameters)
        AF.upload(multipartFormData: { multipartFormData in
               multipartFormData.append(imgData, withName: "photo",fileName: "file.jpg", mimeType: "image/jpg/png")
               for (key, value) in parameters {
                       multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                   } //Optional for extra parameters
           },
        to:"https://www.emeds.pk/api02/uploadprescription").responseDecodable(of: recepitResponseModal.self) { (response) in
            let modal = response.value
            switch response.result {
                case .success(_):
                    if modal?.status ?? false {
                        completion(true, modal?.data?.order_id)
                    } else {
                        completion(false, modal?.action)
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

struct recepitResponseModal: Decodable {
    let action: String?
    let status: Bool?
    let data: orderModal?
}

struct orderModal: Decodable{
    let message: String?
    let order_id: String?
    let name: String?
    let order_id_simple: String?
}
