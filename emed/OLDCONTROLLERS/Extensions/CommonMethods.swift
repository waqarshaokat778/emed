
import Foundation
import UIKit

extension UIViewController{
    
    func writeDataIntoPList(preferences: User){
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("User.plist")
        do {
            let data = try encoder.encode(preferences)
            try data.write(to: path)
            print(path,data)
        } catch {
            print(error)
        }
    }
    
    func readDataFromPList(){
        let pathh = Bundle.main
        let pat = Bundle.main.path(forResource: "User", ofType: "plist")
        if  let path = Bundle.main.path(forResource: "User", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let preferences = try? PropertyListDecoder().decode(User.self, from: xml){
        }
        else {
            print("not found")
        }
    }
    
    func alertDialog(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func validate(email: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: email)
    }
}
