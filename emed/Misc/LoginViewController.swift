
import UIKit
import JEKScrollableSectionCollectionViewLayout
import SwiftEntryKit

class LoginViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var signinFbBtn: UIButton!
    
    @IBOutlet weak var signInGmailBtn: UIButton!
    
    @IBOutlet weak var collectionVu: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        signinFbBtn.layer.cornerRadius = 8
        signinFbBtn.layer.borderWidth = 3
        signinFbBtn.layer.borderColor = UIColor().colorForHax("#448D3B").cgColor
        signInGmailBtn.layer.cornerRadius = 8
               signInGmailBtn.layer.borderWidth = 3
               signInGmailBtn.layer.borderColor = UIColor().colorForHax("#448D3B").cgColor
        collectionVu.delegate = self
        collectionVu.dataSource = self
        setupcollectionvuLayout()
        configurePageControl()
        
        // Do any additional setup after loading the view.
    }
    
    
    func setupcollectionvuLayout(){
        
//        let layout = JEKScrollableSectionCollectionViewLayout()
//        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//
//        layout.itemSize = CGSize(width: collectionVu.frame.width, height: collectionVu.frame.height);
//
////        layout.headerReferenceSize = CGSize(width: 0, height: 22)
//               layout.minimumInteritemSpacing = 0
//        collectionVu.collectionViewLayout = layout
//        collectionVu.isPagingEnabled = true
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = collectionVu.frame.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10

        collectionVu.setCollectionViewLayout(layout, animated: false)
        collectionVu.isPagingEnabled = true
        collectionVu.alwaysBounceVertical = false
        
    }
    func configurePageControl() {
        self.pageControl.numberOfPages = 5
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.view.addSubview(pageControl)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionVu.dequeueReusableCell(withReuseIdentifier: "LoginCollectionViewCell", for: indexPath) as! LoginCollectionViewCell
        
        
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
   
    @IBAction func backBtnTpd(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signUpBtnTpd(_ sender: Any) {
    
    }
    @IBAction func loginBtnTpd(_ sender: Any) {
    }
    
    
    
    
}


extension UIColor {
    
    func colorForHax(_ rgba:String)->UIColor{
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index   = rgba.index(rgba.startIndex, offsetBy: 1)
            let hex     = rgba.substring(from: index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                    break
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                    break
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                    break
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                    break
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
                    break
                }
            } else {
                print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix", terminator: "")
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
}

