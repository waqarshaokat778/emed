

import UIKit

class OrderSuccessfulViewController: UIViewController {

    @IBOutlet weak var backtohomeBtn: UIButton!
    @IBOutlet weak var oderText: UILabel!
    @IBOutlet weak var thankyouTintColor: UIImageView!
    @IBOutlet weak var thankyouBgTintColor: UIImageView!
    @IBOutlet weak var locationOnMap: UIImageView!
    
    var orderNo : String = ""
    let apiRequest = RescriptNo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        locationOnMap.isUserInteractionEnabled = true
        locationOnMap.addGestureRecognizer(tapGestureRecognizer)

        let distionary = UserDefaults.standard.object(forKey: "UserModal") as? [String: String] ?? [:]
        apiRequest.getOrderNumber(rescriptId: distionary["Id"]!, order_id: orderNo) { (response, result) in
            if(response) {
                self.oderText.text = "ORDER NO:" + result
            } else {
                print(result)
                self.alertDialog(title: "Error", message: result )
            }
        }
        
    }
    
    @IBAction func backtohomeBtnTpd(_ sender: Any) {
       self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        openGoogleMap(latDouble: "31.4834154", longDouble: "74.4035834")
    }
    
    func setUpUI() {
        
        backtohomeBtn.layer.cornerRadius = 8
       
        thankyouTintColor.image = thankyouTintColor.image?.withRenderingMode(.alwaysTemplate)
        thankyouTintColor.tintColor = #colorLiteral(red: 0, green: 0.5589933991, blue: 0.4947264194, alpha: 1)
            
        thankyouBgTintColor.image = thankyouBgTintColor.image?.withRenderingMode(.alwaysTemplate)
        thankyouBgTintColor.tintColor = #colorLiteral(red: 0, green: 0.5589933991, blue: 0.4947264194, alpha: 1)
        
        locationOnMap.image = locationOnMap.image?.withRenderingMode(.alwaysTemplate)
        locationOnMap.tintColor = #colorLiteral(red: 0, green: 0.5589933991, blue: 0.4947264194, alpha: 1)
        
    }
    func openGoogleMap(latDouble: String, longDouble: String) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
          if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latDouble),\(longDouble)&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
            print(url)
          }
      } else {
        if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latDouble),\(longDouble)&directionsmode=driving") {
               UIApplication.shared.open(urlDestination)
            print(urlDestination)
        }
      }
    }
}
