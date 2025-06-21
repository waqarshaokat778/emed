

import UIKit

class ImagePickerViewController: UIViewController {
    
    var imagetoLoad = UIImage()
    
    @IBOutlet weak var imgVu: UIImageView!
    var isUserLoginIn: Bool = false
    var dict = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgVu.image = imagetoLoad
        dict = UserDefaults.standard.object(forKey: "UserModal") as? [String: String] ?? [:]
        if((dict["Id"]) != nil) {
            isUserLoginIn = true
        }
    }
    
    @IBAction func sendBtnTpd(_ sender: Any) {
        if isUserLoginIn {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
            vc.imagetoLoad = imagetoLoad
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "newLoginViewController") as! NewLoginViewController
            vc.imagetoLoad = imagetoLoad
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideImagePicker"), object: nil, userInfo: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
