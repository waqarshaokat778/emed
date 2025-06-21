
import Foundation

struct UserModal: Decodable {
    let action: String?
    let status: Bool?
    let data: Data?
}

struct Data: Decodable{
    let Id: String?
    let email: String?
    let name: String?
    let mobileno: String?
}

