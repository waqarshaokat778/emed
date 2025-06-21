
import UIKit
import NVActivityIndicatorView

class AddressViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var tbvu: UITableView!
    var apiRequest = UploadPrescription()
    var imagetoLoad = UIImage()
    var loadingIndicator : NVActivityIndicatorView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.hideKeyboardWhenTappedAround()
        
        tbvu.delegate = self
        tbvu.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
       
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddressTableViewCell
        cell.outerVu.layer.cornerRadius = 8
        cell.outerVu.layer.masksToBounds = false
        cell.outerVu.layer.shadowColor = UIColor.gray.cgColor
        cell.outerVu.layer.shadowOpacity = 0.2
        cell.outerVu.layer.shadowRadius = 4
        cell.selectionStyle = .none

        return cell
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tbvu.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section)) as! AddressTableViewCell
//        cell.checkImgVu.image = UIImage(named: "TickIcon")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tbvu.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section)) as! AddressTableViewCell
//               cell.checkImgVu.image = UIImage(named: "frame")
    }
    
    @IBAction func saveBtnTpd(_ sender: Any) {
        loadingIndicator?.startAnimating()
        apiRequest.uploadImage(imageData: imagetoLoad, completion: { (response, result) in
            if(response) {
                print(result,"result")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "orderSuccessfulViewController") as! OrderSuccessfulViewController
                self.loadingIndicator?.stopAnimating()
                vc.orderNo = result as! String
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.loadingIndicator?.stopAnimating()
                self.alertDialog(title: "Error", message: result as! String)
            }
        })
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    func setUpUI() {
        saveBtn.layer.cornerRadius = 8
        loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height/2 - 50, width: 50, height: 50), type: .ballScaleRippleMultiple, color: #colorLiteral(red: 0, green: 0.5589933991, blue: 0.4947264194, alpha: 1), padding: 1)
        view.addSubview(loadingIndicator!)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
