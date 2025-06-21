
import UIKit
import XLActionController
import WebKit
import NVActivityIndicatorView
import AlamofireImage
import InfiniteScrolling


struct Card {
    let imageUrl: String
}
extension Card: InfiniteScollingData {}


class HomeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var pickYourselfLblOuter: UIView!
    @IBOutlet weak var homedeliveryLblOuter: UIView!
    @IBOutlet weak var contactusLblOuter: UIView!
    @IBOutlet weak var shopOnlineLblOuter: UIView!
    
    @IBOutlet weak var pickyourselfOuterVu: UIView!
    @IBOutlet weak var homedelieveryOuterVu: UIView!
    @IBOutlet weak var contactusOuterVu: UIView!
    @IBOutlet weak var shoponlineOuterVu: UIView!
    
//    @IBOutlet weak var shopOnlineBtn: UIButton!
    @IBOutlet weak var prescriptionAlertOuterVu: UIView!
//    @IBOutlet weak var contactusBtn: UIButton!
    @IBOutlet weak var faqBtn: UIButton!
    @IBOutlet weak var collectionVu: UICollectionView!
    @IBOutlet weak var logoutbtn: UIButton!
    @IBOutlet weak var logoutxt: UILabel!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var faqContainer: UIView!
    @IBOutlet weak var logoutContainer: UIView!
    
    @IBOutlet weak var emedsLblBottom: UILabel!
    
    var timer: Timer?
    var currentPage = 0
    var imagetoSend = UIImage()
    var imagePicker = UIImagePickerController()
    var dict = [String: String]()
    var loadingIndicator : NVActivityIndicatorView? = nil
    var loadingIndicatorForImages : NVActivityIndicatorView? = nil
    var apiRequestForImages = GetImages()
    var imagesURLsForSlide : [String] = []
    var infiniteScrollingBehaviour: InfiniteScrollingBehaviour!
    
    var dummyCards: [Card]?  = []
    private var imageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prescriptionAlertOuterVu.isHidden = true
        settingOuterVu()
        
        let faqTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(faqTap))
        faqContainer.isUserInteractionEnabled = true
        faqContainer.addGestureRecognizer(faqTapGesture)
        
        let logoutTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(logoutTap))
        logoutContainer.isUserInteractionEnabled = true
        logoutContainer.addGestureRecognizer(logoutTapGesture)
        
        let pickYourSelfTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(pickYourselfTap))
        pickyourselfOuterVu.isUserInteractionEnabled = true
        pickyourselfOuterVu.addGestureRecognizer(pickYourSelfTapGesture)
        
        let homeServiceTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(homeServiceTap))
        homedelieveryOuterVu.isUserInteractionEnabled = true
        homedelieveryOuterVu.addGestureRecognizer(homeServiceTapGesture)
        
        let contactTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(contactusTap))
        contactusOuterVu.isUserInteractionEnabled = true
        contactusOuterVu.addGestureRecognizer(contactTapGesture)
        
        let shoponlineTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(shoponlineTap))
        shoponlineOuterVu.isUserInteractionEnabled = true
        shoponlineOuterVu.addGestureRecognizer(shoponlineTapGesture)
        
        let emedsLblBottomTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(shoponlineTap))
        emedsLblBottom.isUserInteractionEnabled = true
        emedsLblBottom.addGestureRecognizer(emedsLblBottomTapGesture)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let _ = infiniteScrollingBehaviour {}
        else {
            collectionVu.isPagingEnabled = true
            let configuration = CollectionViewConfiguration(layoutType: .numberOfCellOnScreen(1), scrollingDirection: .horizontal)
            if dummyCards?.count != 0 {
                infiniteScrollingBehaviour = InfiniteScrollingBehaviour(withCollectionView: collectionVu, andData: dummyCards! , delegate: self, configuration: configuration)
            } else {
                dummyCards? = [Card(imageUrl: "test")]
                infiniteScrollingBehaviour = InfiniteScrollingBehaviour(withCollectionView: collectionVu, andData: dummyCards! , delegate: self, configuration: configuration)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dict = UserDefaults.standard.object(forKey: "UserModal") as? [String: String] ?? [:]
        if((dict["Id"]) != nil) {
            logoutbtn.isHidden = false
            logoutxt.isHidden = false
        } else {
            logoutbtn.isHidden = true
            logoutxt.isHidden = true
        }
        
        pageController.numberOfPages = dummyCards!.count
        getImages()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification1(notification:)), name: Notification.Name("hideImagePicker"), object: nil)
        startTimer()
    }
    
    @objc func faqTap(_ tapGesture : UITapGestureRecognizer) {
        navigateFaq()
    }
    
    @objc func logoutTap(_ tapGesture : UITapGestureRecognizer) {
        logoutAccount()
    }

    @objc func methodOfReceivedNotification1(notification: Notification) {
        prescriptionAlertOuterVu.isHidden = true
//        contactusBtn.isUserInteractionEnabled = true
//        shopOnlineBtn.isUserInteractionEnabled = true
        faqBtn.isUserInteractionEnabled = true
    }
    
   @objc func pickYourselfTap(_ sender: UITapGestureRecognizer) {
       
       prescriptionAlertOuterVu.isHidden = false
       prescriptionAlertOuterVu.layer.cornerRadius = 8
       prescriptionAlertOuterVu.layer.masksToBounds = false
       prescriptionAlertOuterVu.layer.shadowColor = UIColor.black.cgColor
       prescriptionAlertOuterVu.layer.shadowOpacity = 0.23
       prescriptionAlertOuterVu.layer.shadowRadius = 4
       prescriptionAlertOuterVu.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
       
       
       UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
           
           self.prescriptionAlertOuterVu.transform = .identity
       })
//       contactusBtn.isUserInteractionEnabled = false
//       shopOnlineBtn.isUserInteractionEnabled = false
       faqBtn.isUserInteractionEnabled = false
   }
   
   @objc func homeServiceTap(_ sender: UITapGestureRecognizer) {
       prescriptionAlertOuterVu.isHidden = false
       prescriptionAlertOuterVu.layer.cornerRadius = 8
       prescriptionAlertOuterVu.layer.masksToBounds = false
       prescriptionAlertOuterVu.layer.shadowColor = UIColor.black.cgColor
       prescriptionAlertOuterVu.layer.shadowOpacity = 0.23
       prescriptionAlertOuterVu.layer.shadowRadius = 4
       prescriptionAlertOuterVu.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
       
       
       UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
           
           self.prescriptionAlertOuterVu.transform = .identity
       })
       
//       contactusBtn.isUserInteractionEnabled = false
//       shopOnlineBtn.isUserInteractionEnabled = false
       faqBtn.isUserInteractionEnabled = false
   }
   
   @objc func contactusTap(_ sender: UITapGestureRecognizer) {
       let actionController = YoutubeActionController()
       
       actionController.addAction(Action(ActionData(title: "Phone Call", image: UIImage(named: "call")!), style: .default, handler: { action in
           guard let number = URL(string: "tel://" + "+923111136337") else { return }
           UIApplication.shared.open(number)
       }))
       actionController.addAction(Action(ActionData(title: "Open Messenger", image: UIImage(named: "messenger")!), style: .default, handler: { action in
           guard let messenger = URL(string: "fb-messenger://user-thread/445321472516197") else { return }
            UIApplication.shared.open(messenger)
       }))
       actionController.addAction(Action(ActionData(title: "Open Whatsapp", image: UIImage(named: "whatsapp")!), style: .default, handler: { action in
           print("in whats app ")
           let phoneNumber =  "+923111136337" // you need to change this number
           let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
           if UIApplication.shared.canOpenURL(appURL) {
               if #available(iOS 10.0, *) {
                   UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
               }
               else {
                   UIApplication.shared.openURL(appURL)
               }
           } else {
               // WhatsApp is not installed
           }
       }))
       actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .cancel, handler: nil))
       
       present(actionController, animated: true, completion: nil)
   }
   
   @objc func shoponlineTap(_ sender: UITapGestureRecognizer) {
    
       guard let url = URL(string: "https://www.emeds.pk") else {
           return //be safe
       }
       
       if #available(iOS 10.0, *) {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
       } else {
           UIApplication.shared.openURL(url)
       }
   }
    
    @IBAction func logout(_ sender: Any) {
        logoutAccount()
    }
    
    func logoutAccount() {
        UserDefaults.standard.removeObject(forKey: "UserModal")
        self.loadingIndicator?.startAnimating()
        self.logoutbtn.isHidden = true
        self.logoutxt.isHidden = true
        self.loadingIndicator?.stopAnimating()
    }
    
    @IBAction func callNow(_ sender: Any) {
        
        guard let number = URL(string: "tel://" + "+923111136337") else {
            print("error: while opening phone no")
            return
        }
        UIApplication.shared.open(number)
    }
    
    func settingOuterVu(){
        roundBottomShap(wholeContainer: pickyourselfOuterVu, labelContainer: pickYourselfLblOuter)
        roundBottomShap(wholeContainer: homedelieveryOuterVu, labelContainer: homedeliveryLblOuter)
        roundBottomShap(wholeContainer: contactusOuterVu, labelContainer: contactusLblOuter)
        roundBottomShap(wholeContainer: shoponlineOuterVu, labelContainer: shopOnlineLblOuter)
    }
    
    func roundBottomShap(wholeContainer: UIView, labelContainer: UIView) {
        
        wholeContainer.layer.cornerRadius = 8
        wholeContainer.layer.masksToBounds = false
        wholeContainer.layer.shadowColor = UIColor.gray.cgColor
        wholeContainer.layer.shadowOpacity = 0.2
        wholeContainer.layer.shadowRadius = 4
        wholeContainer.layer.borderColor = UIColor().colorForHax("#FFFFFF").cgColor
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = labelContainer.frame
        rectShape.position = labelContainer.center
        rectShape.path = UIBezierPath(roundedRect: labelContainer.bounds, byRoundingCorners: [.bottomLeft , .bottomRight ], cornerRadii: CGSize(width: 8, height: 8)).cgPath

        labelContainer.layer.mask = rectShape
    }
    
    func setCollectionLayout() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        _ = ((screenSize.height) / 2)
        let width = ((screenSize.width))
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width:width, height: 300)
        collectionVu.isPagingEnabled = true
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionVu.collectionViewLayout = layout
        
    }
     
    
    @IBAction func openGalleryBtnTpd(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagetoSend = image
            print(image)
            prescriptionAlertOuterVu.isHidden = true
            self.performSegue(withIdentifier: "imageloader", sender: self)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func openCameraBtnTpd(_ sender: Any) {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self .present(imagePicker, animated: true, completion: nil)
        } else {
            print("you cant use camera")
        }
    }
    
    @IBAction func cancelBtnTpd(_ sender: Any) {
        prescriptionAlertOuterVu.isHidden = true
//        contactusBtn.isUserInteractionEnabled = true
//        shopOnlineBtn.isUserInteractionEnabled = true
        faqBtn.isUserInteractionEnabled = true
    }
    
    func openWhatsapp(){
        let urlWhats = "whatsapp://send?phone=+923111136337"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
    
    @IBAction func faqBtnTpd(_ sender: Any) {
        navigateFaq()
    }
    
    func navigateFaq() {
        guard let url = URL(string: "https://www.emeds.pk/faq") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "imageloader") {
            let vc = segue.destination as! ImagePickerViewController
            vc.imagetoLoad = imagetoSend
            print(imagetoSend,type(of: imagetoSend))
            
        }
    }
    
    func getImages()  {
        
        apiRequestForImages.get { (response, result) in
            print(result)
            if(response) {
                let arrayData =  result as! [String]
                self.imagesURLsForSlide = arrayData
                DispatchQueue.main.async {
                    self.pageController.numberOfPages = arrayData.count
                    if  arrayData.count != 0  {
                        self.dummyCards = []
                        
                        for item in arrayData {
                            self.dummyCards?.append(Card(imageUrl: item))
                        }
                    } else {
                        self.dummyCards = [Card(imageUrl: "test")]
                    }
                    self.infiniteScrollingBehaviour.reload(withData:  self.dummyCards ?? [])
                }

            } else {
                print(result)
            }
        }
    }
    
    func slideImages() {
        if imagesURLsForSlide.count > 0 {
            timer = Timer.scheduledTimer(timeInterval: 3,
                                         target: self,
                                         selector: #selector(timerTriggered(_:)),
                                         userInfo: nil,
                                         repeats: true)
            RunLoop.main.add(timer!, forMode: .common)
        }
    }
    
    @objc func timerTriggered(_ sender: Timer) {
        self.imageIndex += 1
        if self.imageIndex >= self.imagesURLsForSlide.count {
            self.imageIndex = 0
        }
    }
    
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(scrollAutomatically), userInfo: nil, repeats: true)
    }


    @objc func scrollAutomatically(_ timer1: Timer) {
        for cell in collectionVu.visibleCells {
            if dummyCards?.count == 1 {
                return
            }
            let indexPath = collectionVu.indexPath(for: cell)!
            if indexPath.row < (dummyCards!.count) {
                let indexPath1 = IndexPath.init(row: indexPath.row + 1, section: indexPath.section)
                collectionVu.scrollToItem(at: indexPath1, at: .right, animated: true)
                pageController.currentPage = indexPath1.row
            } else if  indexPath.row == (dummyCards!.count ) {
                let indexPath1 = IndexPath.init(row: 1, section: indexPath.section)
                collectionVu.scrollToItem(at: indexPath1, at: .right, animated: true)
                pageController.currentPage = indexPath1.row
            }  else {
                let indexPath1 = IndexPath.init(row: 0, section: indexPath.section)
                collectionVu.scrollToItem(at: indexPath1, at: .left, animated: true)
                pageController.currentPage = indexPath1.row
            }
        }
    }
    
    
}

extension HomeViewController {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    

}

extension HomeViewController: InfiniteScrollingBehaviourDelegate {
    
    func configuredCell(forItemAtIndexPath indexPath: IndexPath, originalIndex: Int, andData data: InfiniteScollingData, forInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> UICollectionViewCell {
        
        let cell = collectionVu.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell

        if let _ = cell as? UICollectionViewCell,
            let card = data as? Card {
            
            if dummyCards?.count ?? -1 > 1 {
                if dummyCards?[0].imageUrl != "test"  {
                    print(originalIndex, indexPath.row)
                    self.pageController.currentPage = indexPath.row - 2
                    let productImageUrl = card.imageUrl
                    cell.imgVu.af.setImage(withURL: URL(string: productImageUrl)!,placeholderImage: UIImage(named: ""))
                }

            }
        }
        
        return cell
    }

    func didSelectItem(atIndexPath indexPath: IndexPath, originalIndex: Int, andData data: InfiniteScollingData, inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> Void {

    }

}
