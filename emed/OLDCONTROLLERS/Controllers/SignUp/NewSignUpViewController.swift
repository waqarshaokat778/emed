
import UIKit
//import RYFloatingInput
import NVActivityIndicatorView
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields


class NewSignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UIView!
    @IBOutlet weak var emailField: UIView!
    @IBOutlet weak var phoneNumberField: UIView!
    @IBOutlet weak var passwordField: UIView!
    @IBOutlet weak var confirmPasswordField: UIView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var passIcon: UIButton!
    @IBOutlet weak var confirmPassIcon: UIButton!
    
    var nameTextField : MDCFilledTextField? = nil
    var emailTextField : MDCFilledTextField? = nil
    var numberTextField : MDCFilledTextField? = nil
    var passwordTextField : MDCFilledTextField? = nil
    var confirmPassTextField : MDCFilledTextField? = nil
    
    
    var isVisibleForConfirmPass = true
    var isVisible = true
    var apiRequest = AccountHandler()
    var imagetoLoad = UIImage()
    var loadingIndicator : NVActivityIndicatorView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()
    }
    
    func setupFields(){
        
        signUpBtn.layer.cornerRadius = 5
        signUpBtn.layer.borderWidth = 2
        signUpBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//
//        nameField.layer.cornerRadius = 5
//        nameField.layer.masksToBounds = false
//        nameField.layer.shadowColor = UIColor.black.cgColor
//        nameField.layer.shadowOpacity = 0.23
//        nameField.layer.shadowRadius = 4
//        let nameField1 = RYFloatingInputSetting.Builder.instance()
//            .theme(.standard).iconImage(UIImage(named: "nameicon")!).placeholer("Full Name")
//            .secure(false)
//            .build()
//        nameField.setup(setting: nameField1)
        
        
        nameTextField = MDCFilledTextField(frame: emailField.frame)
        nameTextField?.label.text = "Full Name"
        nameTextField?.placeholder = ""
        nameTextField?.leadingView = UIImageView(image: UIImage(named: "icons8-user"))
        nameTextField?.leadingViewMode = .always
        nameTextField?.setUnderlineColor(#colorLiteral(red: 0, green: 0.5607843137, blue: 0.4941176471, alpha: 1), for: .editing)
        nameTextField?.setUnderlineColor(#colorLiteral(red: 0, green: 0.5607843137, blue: 0.4941176471, alpha: 1), for: .normal)
        nameTextField?.translatesAutoresizingMaskIntoConstraints = false
        nameTextField?.font =  UIFont(name: "Nexa Light", size: 16)
        nameField.addSubview(nameTextField!)
        nameField.layer.cornerRadius = 2
        
        
        
        
        
//        emailField.layer.cornerRadius = 5
//        emailField.layer.masksToBounds = false
//        emailField.layer.shadowColor = UIColor.black.cgColor
//        emailField.layer.shadowOpacity = 0.23
//        emailField.layer.shadowRadius = 4
//        let email_regex_pattern = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
//            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
//            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
//            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
//            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
//            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
//        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
//        emailField.setup(setting:
//            RYFloatingInputSetting.Builder.instance()
//                .placeholer("Email ")
//                .iconImage(UIImage(named: "emailicon")!)
//                .inputType(.regex(pattern: email_regex_pattern), onViolated: (message: "Invalid Email Format", callback: nil))
//                .build()
//        )
        
        
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
        emailField.layer.cornerRadius = 2
        
        
//        phoneNumberField.layer.cornerRadius = 5
//        phoneNumberField.layer.masksToBounds = false
//        phoneNumberField.layer.backgroundColor = UIColor.white.cgColor
//        phoneNumberField.layer.shadowColor = UIColor.black.cgColor
//        phoneNumberField.layer.shadowOpacity = 0.23
//        phoneNumberField.layer.shadowRadius = 4
//        let phoneNumberFieldSetting = RYFloatingInputSetting.Builder.instance()
//            .theme(.standard).iconImage(UIImage(named: "passwordicon")!)
//            .placeholer("Phone Number")
//            .secure(false)
//            .build()
//        phoneNumberField.setup(setting: phoneNumberFieldSetting)
        
        
        
        numberTextField = MDCFilledTextField(frame: emailField.frame)
        numberTextField?.label.text = "Phone Number "
        numberTextField?.placeholder = ""
        numberTextField?.leadingView = UIImageView(image: UIImage(named: "icons8-touchscreen_smartphone_filled"))
        numberTextField?.leadingViewMode = .always
        numberTextField?.setUnderlineColor(#colorLiteral(red: 0, green: 0.5607843137, blue: 0.4941176471, alpha: 1), for: .editing)
        numberTextField?.setUnderlineColor(#colorLiteral(red: 0, green: 0.5607843137, blue: 0.4941176471, alpha: 1), for: .normal)
        numberTextField?.translatesAutoresizingMaskIntoConstraints = false
        numberTextField?.font =  UIFont(name: "Nexa Light", size: 16)
        numberTextField?.keyboardType = .phonePad
        phoneNumberField.addSubview(numberTextField!)
        phoneNumberField.layer.cornerRadius = 2
        
//        passwordField.layer.cornerRadius = 5
//        passwordField.layer.masksToBounds = false
//        passwordField.layer.shadowColor = UIColor.black.cgColor
//        passwordField.layer.shadowOpacity = 0.23
//        passwordField.layer.shadowRadius = 4
//        let passwordFieldSetting = RYFloatingInputSetting.Builder.instance()
//            .theme(.standard).iconImage(UIImage(named: "passwordicon")!)
//            .placeholer("Password")
//            .secure(true)
//            .build()
//        passwordField.setup(setting: passwordFieldSetting)
        
        
        
        
        passwordTextField = MDCFilledTextField(frame: emailField.frame)
        passwordTextField?.label.text = "Password"
        passwordTextField?.placeholder = ""
        passwordTextField?.leadingView = UIImageView(image: UIImage(named: "passwordicon"))
        passwordTextField?.leadingViewMode = .always
        passwordTextField?.setUnderlineColor(#colorLiteral(red: 0, green: 0.5607843137, blue: 0.4941176471, alpha: 1), for: .editing)
        passwordTextField?.setUnderlineColor(#colorLiteral(red: 0, green: 0.5607843137, blue: 0.4941176471, alpha: 1), for: .normal)
        passwordTextField?.isSecureTextEntry = true
        passwordTextField?.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField?.font =  UIFont(name: "Nexa Light", size: 16)
        passwordField.addSubview(passwordTextField!)
        passwordField.layer.cornerRadius = 2
        
        
        
        confirmPassTextField = MDCFilledTextField(frame: emailField.frame)
        confirmPassTextField?.label.text = "Confirm Password"
        confirmPassTextField?.placeholder = ""
        confirmPassTextField?.leadingView = UIImageView(image: UIImage(named: "passwordicon"))
        confirmPassTextField?.leadingViewMode = .always
        confirmPassTextField?.setUnderlineColor(#colorLiteral(red: 0, green: 0.5607843137, blue: 0.4941176471, alpha: 1), for: .editing)
        confirmPassTextField?.setUnderlineColor(#colorLiteral(red: 0, green: 0.5607843137, blue: 0.4941176471, alpha: 1), for: .normal)
        confirmPassTextField?.isSecureTextEntry = true
        confirmPassTextField?.translatesAutoresizingMaskIntoConstraints = false
        confirmPassTextField?.font =  UIFont(name: "Nexa Light", size: 16)
        confirmPasswordField.addSubview(confirmPassTextField!)
        confirmPasswordField.layer.cornerRadius = 2
    
       
//
//        confirmPasswordField.layer.cornerRadius = 5
//        confirmPasswordField.layer.masksToBounds = false
//        confirmPasswordField.layer.shadowColor = UIColor.black.cgColor
//        confirmPasswordField.layer.shadowOpacity = 0.23
//        confirmPasswordField.layer.shadowRadius = 4
//        let confirmPasswordFieldSetting = RYFloatingInputSetting.Builder.instance()
//            .theme(.standard).iconImage(UIImage(named: "passwordicon")!)
//            .placeholer("Confirm Password")
//            .secure(true)
//            .build()
//        confirmPasswordField.setup(setting: confirmPasswordFieldSetting)
//
        loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height/2 - 50, width: 50, height: 50), type: .ballScaleRippleMultiple, color: #colorLiteral(red: 0, green: 0.4763871481, blue: 0.4946232438, alpha: 1), padding: 1)
        view.addSubview(loadingIndicator!)
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func passwordHideShow(_ sender: Any) {
        if isVisible {
            self.isVisible = false
            passIcon.setImage(UIImage(named: "icons8-invisible"), for: .normal)
            passwordTextField?.isSecureTextEntry = false
        } else {
            self.isVisible =  true
            
            passIcon.setImage(UIImage(named: "icons8-hide"), for: .normal)
            passwordTextField?.isSecureTextEntry = true
            
        }
    }
    
    @IBAction func confirmPassHideShow(_ sender: Any) {
        if isVisibleForConfirmPass {
            self.isVisibleForConfirmPass = false
            confirmPassIcon.setImage(UIImage(named: "icons8-invisible"), for: .normal)
            confirmPassTextField?.isSecureTextEntry = false
        } else {
            self.isVisibleForConfirmPass =  true
            
            confirmPassIcon.setImage(UIImage(named: "icons8-hide"), for: .normal)
            confirmPassTextField?.isSecureTextEntry = true
            
        }
        
    }
    @IBAction func signUpBtnTpd(_ sender: Any) {
        
        guard let userName = nameTextField?.text, !userName.isEmpty else {
            self.alertDialog(title: "Alert", message: "Please enter name" )
            return
        }
        
        guard  nameTextField?.text?.count ?? 0 > 2 else {
            self.alertDialog(title: "Alert", message: "Name should be at least 3 characters" )
            return
        }
        
        guard let email = emailTextField?.text, !email.isEmpty else {
            self.alertDialog(title: "Alert", message: "Please enter email" )
            return
        }
        
        guard self.validate(email: email) else {
            self.alertDialog(title: "Alert", message: "Please enter valid email address" )
            return
        }
        
        guard let phoneNumber = numberTextField?.text, !phoneNumber.isEmpty else {
            self.alertDialog(title: "Alert", message: "Please enter phone number" )
            return
        }
        
        guard numberTextField?.text?.count ?? 0 > 9 else {
            self.alertDialog(title: "Alert", message: "Phone number should be at least 10 characters" )
            return
        }
        
        guard let password = passwordTextField?.text, !password.isEmpty else {
            self.alertDialog(title: "Alert", message: "Please enter password" )
            return
        }

        guard passwordTextField?.text!.count ?? 0 > 7 else {
            self.alertDialog(title: "Alert", message: "Password should be at least 8 characters" )
            return
        }
        
        guard passwordTextField?.text == confirmPassTextField?.text else {
            self.alertDialog(title: "Alert", message: "Password Mismatch" )
            return
        }
        
        loadingIndicator?.startAnimating()
        apiRequest.signUp(email: email, userName: userName, phoneNumber: phoneNumber, password: password, deviceType: "IOS") { (response, result) in
            if(response) {
                self.apiRequest.login(email: email, password: password) { (response, result) in
                    if(response) {
                        print("Result: ",result)
                        self.loadingIndicator?.stopAnimating()
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
                        vc.isNewUser = false
                        vc.imagetoLoad = self.imagetoLoad
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.loadingIndicator?.stopAnimating()
                        self.alertDialog(title: "Error", message: "Something want wrong")
                    }
                }
                
            } else {
                print(result)
                self.loadingIndicator?.stopAnimating()
                self.alertDialog(title: "Error", message: result as! String)
            }
        }
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
}

