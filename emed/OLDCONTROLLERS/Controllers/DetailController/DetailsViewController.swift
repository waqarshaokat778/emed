

import UIKit
import NVActivityIndicatorView


class DetailsViewController: UIViewController {
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userPhoneNoField: UITextField!
    @IBOutlet weak var mainLabel: UILabel!
    
    var imagetoLoad = UIImage()
    var isChangeFields = false
    var apiRequest = AccountHandler()
    var loadingIndicator : NVActivityIndicatorView? = nil
    var isNewUser = false
    var email: String = ""
    var userName: String = ""
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    @IBAction func nextBtnTpd(_ sender: Any) {
        guard let userName = userNameField.text, !userName.isEmpty else {
            self.alertDialog(title: "Alert", message: "Please Enter Name" )
            return
        }
        
        guard  userNameField.text!.count > 2 else {
            self.alertDialog(title: "Alert", message: "Name should be at least 3 characters" )
            return
        }
        
        guard let phoneNo = userPhoneNoField.text, !phoneNo.isEmpty else {
            self.alertDialog(title: "Alert", message: "Please Enter Phone Number" )
            return
        }
        
        guard userPhoneNoField.text!.count > 9 else {
            self.alertDialog(title: "Alert", message: "Phone Number should be at least 10 characters" )
            return
        }
        
        if(userPhoneNoField.text == "qwerty12345" || userPhoneNoField.text == "") {
            self.alertDialog(title: "Alert", message: "Please Enter Correct Phone No" )
            return
        }
        
        if isNewUser {
            loadingIndicator?.startAnimating()
            signUp(email: self.email, userName: userName, phoneNumber: phoneNo)
        } else if (isChangeFields && !isNewUser) {
            loadingIndicator?.startAnimating()
            apiRequest.updateProfile(id: userId, userName: userName, mobileno: phoneNo) { (response, result) in
                if(response) {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "addressViewController") as! AddressViewController
                    self.loadingIndicator?.stopAnimating()
                    vc.imagetoLoad = self.imagetoLoad
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.loadingIndicator?.stopAnimating()
                    self.alertDialog(title: "Alert", message: result as! String)
                }
            }
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "addressViewController") as! AddressViewController
            vc.imagetoLoad = imagetoLoad
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange() {
        self.isChangeFields = true
    }
    
    func setUpUI() {
        
        nextBtn.layer.cornerRadius = 8
        loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height/2 - 50, width: 50, height: 50), type: .ballScaleRippleMultiple, color: #colorLiteral(red: 0, green: 0.5589933991, blue: 0.4947264194, alpha: 1), padding: 1)
        view.addSubview(loadingIndicator!)
        userNameField.layer.borderColor = #colorLiteral(red: 0, green: 0.5589933991, blue: 0.4947264194, alpha: 1)
        userPhoneNoField.layer.borderColor = #colorLiteral(red: 0, green: 0.5589933991, blue: 0.4947264194, alpha: 1)
        
        if isNewUser {
            userNameField.text = self.userName
            userPhoneNoField.text = ""
        } else {
            let dict = UserDefaults.standard.object(forKey: "UserModal") as? [String: String] ?? [:]
            userNameField.text = dict["name"]
            userPhoneNoField.text = dict["mobileno"]
            userId = dict["Id"]!
        }
        
        userNameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        userPhoneNoField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.hideKeyboardWhenTappedAround()
    }
    
    func showAlertWith(title: String, message: String, onSuccess closure: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .`default`, handler: { _ in
            closure()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func signUp(email: String, userName: String, phoneNumber: String) {
        self.apiRequest.signUpWithSocialMedia(email: email, userName: userName, phoneNumber: phoneNumber) { (response, result) in
            if(response) {
                self.showAlertWith(title: "", message: result as! String) {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "addressViewController") as! AddressViewController
                    self.loadingIndicator?.stopAnimating()
                    vc.imagetoLoad = self.imagetoLoad
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            } else {
                self.loadingIndicator?.stopAnimating()
                print(result)
                self.alertDialog(title: "Error", message: result as! String)
            }
        }
    }
}
