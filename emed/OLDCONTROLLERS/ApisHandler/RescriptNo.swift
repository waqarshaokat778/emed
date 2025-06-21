
import Foundation
import Alamofire


class RescriptNo {
    
    func getOrderNumber (rescriptId: String, order_id: String, completion: @escaping (Bool, String) -> Void){

        guard let url = URL(string: "https://www.emeds.pk/api02/getOrderRecipt") else {
          completion(false, "Url not exist. Please contact with spport")
          return
        }
        var parameters: [String:Any] = [:]
        parameters["ID"] = rescriptId
        parameters["order_id"] = order_id
        
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: orderResponseModal.self) { (response) in
            let modal = response.value
            switch response.result {
                case .success(_):
                    if modal?.status ?? false {
                        completion(true, (modal?.data?.Order_Number)!)
                    } else {
                        completion(false, modal?.action ?? "Something want wrong")
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

struct orderResponseModal: Decodable {
    let action: String?
    let status: Bool?
    let data: orderResponse?
}

struct orderResponse: Decodable{
    let Order_Number: String?
    let Payment_Mode: String?
    let Invoice_Date: String?
    let Name: String?
    let Address: String?
    let Subtotal: String?
}
