
import Foundation
import Alamofire

class AccountHandler: UIViewController {
    
    func signUp(email: String, userName: String, phoneNumber: String, password: String, deviceType: String, completion: @escaping (Bool, Any) -> Void){
        
        guard let url = URL(string: "https://www.emeds.pk/api02/register") else {
          return
        }
        var parameters: [String:Any] = [:]
        parameters["name"] = userName
        parameters["email"] = email
        parameters["password"] = password
        parameters["mobileno"] = phoneNumber
        parameters["DeviceType"] = deviceType
        
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: UserModal.self) { (response) in
            let modal = response.value
            switch response.result {
                case .success(_):
                    if modal?.status ?? false {
                        let dict = ["Id": modal?.data?.Id, "email": modal?.data?.email,"name": modal?.data?.name, "mobileno": modal?.data?.mobileno,]
                        UserDefaults.standard.set(dict, forKey: "UserModal")
                        completion(true, modal?.data)
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
    
    func signUpWithSocialMedia(email: String, userName: String, phoneNumber: String, completion: @escaping (Bool, Any) -> Void){
        
        guard let url = URL(string: "https://www.emeds.pk/api02/socialmedia-register") else {
          return
        }
        var parameters: [String:Any] = [:]
        parameters["name"] = userName
        parameters["email"] = email
        parameters["mobileno"] = phoneNumber
        
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: UserModal.self) { (response) in
            let modal = response.value
            switch response.result {
                case .success(_):
                    if modal?.status ?? false {
                        let dict = ["Id": modal?.data?.Id, "email": modal?.data?.email,"name": modal?.data?.name, "mobileno": modal?.data?.mobileno,]
                        UserDefaults.standard.set(dict, forKey: "UserModal")
                        completion(true, modal?.action)
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
    
    func login(email: String, password: String, completion: @escaping (Bool, Any) -> Void){

        guard let url = URL(string: "https://www.emeds.pk/api02/login") else {
          completion(false, "Url not exist. Please contact with spport")
          return
        }
        var parameters: [String:Any] = [:]
        parameters["email"] = email
        parameters["password"] = password

        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: UserModal.self) { (response) in
            let modal = response.value
            switch response.result {
                case .success(_):
                    if modal?.status ?? false {
                        let dict = ["Id": modal?.data?.Id, "email": modal?.data?.email,"name": modal?.data?.name, "mobileno": modal?.data?.mobileno,]
                        UserDefaults.standard.set(dict, forKey: "UserModal")
                        completion(true, dict )
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
    
    func updateProfile(id: String, userName: String, mobileno: String, completion: @escaping (Bool, Any) -> Void){
        
        guard let url = URL(string: "https://www.emeds.pk/api02/UpdateProfileNameAndMobile") else {
          completion(false, "Url not exist. Please contact with spport")
          return
        }
        var parameters: [String:Any] = [:]
        parameters["ID"] = id
        parameters["name"] = userName
        parameters["mobileno"] = mobileno
        
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: UserModal.self) { (response) in
            let modal = response.value
            switch response.result {
                case .success(_):
                    if modal?.status ?? false {
                        let dict = ["Id": modal?.data?.Id, "email": modal?.data?.email,"name": modal?.data?.name, "mobileno": modal?.data?.mobileno,]
                        UserDefaults.standard.set(dict, forKey: "UserModal")
                        completion(true, modal?.data)
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

