

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import NVActivityIndicatorView

class NewLoginViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionVu: UICollectionView!
    @IBOutlet weak var facebookbtn: FBLoginButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var imagetoLoad = UIImage()
    let imagesArray = ["image-2","image-1"]
    var apiRequest = AccountHandler()
    var dict = [String: String]()
    var loadingIndicator : NVActivityIndicatorView? = nil
    
    var isNewUser = false
    var userName : String = ""
    var email : String = ""
    var indexLoad = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionVu.delegate = self
        collectionVu.dataSource = self
        
        setCollectionLayout()
        setUpLayout()
        cornerRadius()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        facebookbtn.permissions = ["public_profile", "email","public_profile", "email","public_profile", "email"]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    @objc func scrollAutomatically(_ timer1: Timer) {
           
           for cell in collectionVu.visibleCells {
                let indexPath: IndexPath = collectionVu.indexPath(for: cell)!
                print(indexLoad, indexPath, indexPath.row)
                if (indexLoad <= imagesArray.count - 1){
                    collectionVu.scrollToItem(at: IndexPath(row: indexLoad, section: 0), at: .left, animated: true)
                    collectionVu.reloadData()
                    indexLoad = indexLoad + 1
                } else{
                    indexLoad = 0
                    collectionVu.scrollToItem(at:  IndexPath.init(row: indexLoad, section: 0), at: .right, animated: true)
                    collectionVu.reloadData()
                   }
                   
               }
           
       }
    
    func setCollectionLayout() {
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        collectionVu.isPagingEnabled = true
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionVu.collectionViewLayout = layout
//        self.collectionVu.scrollInterval = 2
//        self.collectionVu.startScrolling()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionVu.dequeueReusableCell(withReuseIdentifier: "NewLoginCollectionViewCell", for: indexPath) as! NewLoginCollectionViewCell
        if indexLoad <= imagesArray.count - 1 {
            cell.imgVu.image = UIImage(named: imagesArray[indexLoad])
        }
        return cell
    }
    
    @IBAction func navigateBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedGoogleLoginBtn(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func signUpBtnTpd(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "newSignUpViewController") as! NewSignUpViewController
        vc.imagetoLoad = imagetoLoad
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func facebookBtnTpd(_ sender: Any) {
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            self.loadingIndicator?.startAnimating()
            guard let accessToken = FBSDKLoginKit.AccessToken.current else { return }
            
            let graphRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                        parameters: ["fields": "email, name"],
                                                          tokenString: accessToken.tokenString,
                                                          version: nil,
                                                          httpMethod: .get)
            graphRequest.start { (connection, result, error) -> Void in
                if error == nil {
                    
                    let loginManager = LoginManager()
                    loginManager.logOut()
                    
                    let modal = result as? [String: String]
                    print(modal!)
                    guard modal!["email"] != nil else {
                        self.alertDialog(title: "error", message: "Email not exist. Please SignUp")
                        return
                    }
                    self.email = (modal?["email"])!
                    self.userName = (modal?["name"])!
                    self.checkLogin(email: modal?["email"] ?? "test@gmail.com")
                }
                else {
                    self.loadingIndicator?.stopAnimating()
                    print("error \(String(describing: error))")
                }
            }
            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        }

    }
    
    @IBAction func loginBtnTpd(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "newSignInViewController") as! NewSignInViewController
        vc.imagetoLoad = imagetoLoad
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkLogin(email: String) {
        print(email)
        apiRequest.login(email: email, password: "qwerty12345") { (response, result) in
            if(response) {
                print("Result: ",result)
                let modal = result as? [String: Any]
                self.loadingIndicator?.stopAnimating()
                if (modal?["Id"] != nil) {
                    self.isNewUser = false
                } else {
                    self.isNewUser = true
                }
            } else {
                self.isNewUser = true
                self.loadingIndicator?.stopAnimating()
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
            vc.isNewUser = self.isNewUser
            print(self.isNewUser)
            vc.imagetoLoad = self.imagetoLoad
            vc.userName = self.userName
            vc.email = self.email
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setUpLayout() {
        loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height/2 - 50, width: 50, height: 50), type: .ballScaleRippleMultiple, color: #colorLiteral(red: 0, green: 0.5589933991, blue: 0.4947264194, alpha: 1), padding: 1)
        view.addSubview(loadingIndicator!)
        
//        facebookbtn.translatesAutoresizingMaskIntoConstraints = true
//        facebookbtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
//        facebookbtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
//        facebookbtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    func cornerRadius (){
        signUpBtn.layer.cornerRadius = 3.0
        loginBtn.layer.cornerRadius = 3.0
        facebookbtn.layer.cornerRadius = 3.0
        googleBtn.layer.cornerRadius = 3.0
    }
    
   
}


extension NewLoginViewController: GIDSignInDelegate {
    
    //MARK:Google SignIn Delegate
     func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
      // myActivityIndicator.stopAnimating()
        }

    // Present a view that prompts the user to sign in with Google
       func sign(_ signIn: GIDSignIn!,
                  present viewController: UIViewController!) {
            self.present(viewController, animated: true, completion: nil)
        }

    // Dismiss the "Sign in with Google" view
     func sign(_ signIn: GIDSignIn!,
                  dismiss viewController: UIViewController!) {
            self.dismiss(animated: true, completion: nil)
        }

    //completed sign In
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        loadingIndicator?.startAnimating()
            if (error == nil) {
                self.email = user.profile.email
                self.userName = user.profile.name
                checkLogin(email: user.profile.email ?? "test@gmail.com")
            } else {
                loadingIndicator?.stopAnimating()
                print("\(error.localizedDescription)")
            }
        }
}
