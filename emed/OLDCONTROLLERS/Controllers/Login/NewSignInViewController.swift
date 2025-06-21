
import UIKit
//import RYFloatingInput
import NVActivityIndicatorView
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields

class NewSignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UIView!
    @IBOutlet weak var passwordField: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordFieldIcon: UIButton!
    
    var emailTextField : MDCFilledTextField? = nil
    var passwordTextField : MDCFilledTextField? = nil
    var apiRequest = AccountHandler()
    var imagetoLoad = UIImage()
    var loadingIndicator : NVActivityIndicatorView? = nil
    var isVisible = true
    var passIcon : UIImageView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingFields()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showHidePass(_ sender: Any) {
        if isVisible {
            self.isVisible = false
            passwordFieldIcon.setImage(UIImage(named: "icons8-invisible"), for: .normal)
            passwordTextField?.isSecureTextEntry = false
        } else {
            self.isVisible =  true
            
            passwordFieldIcon.setImage(UIImage(named: "icons8-hide"), for: .normal)
            passwordTextField?.isSecureTextEntry = true
            
        }
    }
    
    func settingFields(){
        
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.borderWidth = 2
        loginBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        emailTextField = MDCFilledTextField(frame: emailField.frame)
        emailTextField?.label.text = "Email"
        emailTextField?.placeholder = ""
        emailTextField?.leadingView = UIImageView(image: UIImage(named: "emailicon"))
        emailTextField?.leadingViewMode = .always
        emailTextField?.setUnderlineColor(#colorLiteral(red: 0, green: 0.5607843137, blue: 0.4941176471, alpha: 1), for: .editing)
        emailTextField?.setUnderlineColor(#colorLiteral(red: 0, green: 0.5607843137, blue: 0.4941176471, alpha: 1), for: .normal)

        emailTextField?.translatesAutoresizingMaskIntoConstraints = false
        emailTextField?.font =  UIFont(name: "Nexa Light", size: 16)
        emailField.addSubview(emailTextField!)
        
        passwordTextField = MDCFilledTextField(frame: emailField.frame)
        passwordTextField?.label.text = "Password"
        passwordTextField?.placeholder = ""
        passwordTextField?.leadingView = UIImageView(image: UIImage(named: "passwordicon"))
        passwordTextField?.leadingViewMode = .always
        passwordTextField?.isSecureTextEntry = true
        passwordTextField?.setUnderlineColor(#colorLiteral(red: 0, green: 0.5607843137, blue: 0.4941176471, alpha: 1), for: .editing)
        passwordTextField?.setUnderlineColor(#colorLiteral(red: 0, green: 0.5607843137, blue: 0.4941176471, alpha: 1), for: .normal)
        passwordTextField?.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField?.font =  UIFont(name: "Nexa Light", size: 16)
        passwordField.addSubview(passwordTextField!)
        
        
        loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height/2 - 50, width: 50, height: 50), type: .ballScaleRippleMultiple, color: #colorLiteral(red: 0, green: 0.4763871481, blue: 0.4946232438, alpha: 1), padding: 1)
        
        view.addSubview(loadingIndicator!)
        self.hideKeyboardWhenTappedAround()
        
        
    }
    
    @objc func passwordShowHide() {
        if isVisible {
            self.isVisible = false
            passIcon = UIImageView(image: UIImage(named: "icons8-invisible"))
            passwordTextField?.isSecureTextEntry = false
            passwordTextField?.trailingView = passIcon
        } else {
            self.isVisible =  true
            passIcon = UIImageView(image: UIImage(named: "icons8-hide"))
            passwordTextField?.isSecureTextEntry = true
            passwordTextField?.trailingView = passIcon
        }
    }
    
    @IBAction func signUpBtnTpd(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "newSignUpViewController") as! NewSignUpViewController
        vc.imagetoLoad = imagetoLoad
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let email = emailTextField?.text, !email.isEmpty else {
            self.alertDialog(title: "Alert", message: "Please enter email" )
            return
        }
        
        guard self.validate(email: email) else {
            self.alertDialog(title: "Alert", message: "Please enter valid email address" )
            return
        }
        
        guard let password = passwordTextField?.text, !password.isEmpty else {
            self.alertDialog(title: "Alert", message: "Please enter password" )
            return
        }

        guard (passwordTextField?.text?.count) ?? 0 > 7 else {
            self.alertDialog(title: "Alert", message: "Password should be at least 8 characters" )
            return
        }
        
        self.loadingIndicator?.startAnimating()
        apiRequest.login(email: email, password: password) { (response, result) in
            if(response) {
                print("Result: ",result)
                self.loadingIndicator?.stopAnimating()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
                vc.imagetoLoad = self.imagetoLoad
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                print(result)
                self.loadingIndicator?.stopAnimating()
                self.alertDialog(title: "Error", message: result as! String)
            }
        }
    }
}
