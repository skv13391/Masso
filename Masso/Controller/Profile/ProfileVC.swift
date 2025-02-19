//
//  ProfileVC.swift
//  Masso
//
//  Created by Sunil on 29/03/23.
//

import UIKit
import Photos
import Toast_Swift

class ProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var loadNNView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var innerUpperView: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblNewProfile: UILabel!
    @IBOutlet weak var lblRemvoeImage: UILabel!
    let myPickerController = UIImagePickerController()
    var viewModel = HomeViewModel()
    var viewLogout = NewLoginViewModel()
    @IBOutlet weak var mainWidth: NSLayoutConstraint!
    @IBOutlet weak var mainHeight: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var editWidth: NSLayoutConstraint!
    @IBOutlet weak var editHeight: NSLayoutConstraint!
    @IBOutlet weak var editTop: NSLayoutConstraint!
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate

    // MARK: - View Life Cycle --------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    
        self.myAppDelegate.presentViewCr = "true"
        self.myAppDelegate.showSerial = "11"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
       
    }
    
    func setUpUI()
    {
        var imgUrl = UserDefaults.standard.object(forKey: "dpp") as? String
       
        
        if imgUrl == "" || imgUrl == nil
        {
            self.userImage.image = UIImage(named: "picPlaceholder")?.withRenderingMode(.alwaysOriginal)
        }
        else
        {
            let url = URL(string: imgUrl!)!

              // Create Data Task
              let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                  if let data = data {
                      // Create Image and Update Image View
                      DispatchQueue.main.async {
                                    // Create Image and Update Image View
                          self?.userImage.image = UIImage(data: data)
                          self?.userImage.contentMode = .scaleToFill
                    }
                  }
              }
            dataTask.resume()
        }

        
        if Device.IS_IPHONE
        {
            self.lblTitle.font =  UIFont(name: "Inter-SemiBold", size: 16)
            self.mainWidth.constant = 287
            self.mainHeight.constant = 279
            self.imgWidth.constant = 84
            self.imgHeight.constant = 84
            self.userImage.layer.cornerRadius = self.userImage.frame.size.height / 2
            self.userImage.clipsToBounds = true
            self.editTop.constant = 22
            self.editWidth.constant = 32
            self.editHeight.constant = 32
        }
        else
        {
            self.lblTitle.font =  UIFont(name: "Inter-SemiBold", size: 28)
            self.lblName.font =  UIFont(name: "Inter-SemiBold", size: 28)
            self.lblEmail.font =  UIFont(name: "Inter-SemiBold", size: 28)
            self.mainWidth.constant = 400
            self.mainHeight.constant = 400
            self.imgWidth.constant = 200
            self.imgHeight.constant = 200
            self.userImage.layer.cornerRadius = 100
            self.userImage.clipsToBounds = true
            self.editTop.constant = 50
            self.editWidth.constant = 40
            self.editHeight.constant = 40
        }
        
        
        
       
        
        self.loadNNView.layer.cornerRadius = 20
        self.loadNNView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.1)
        self.loadNNView.clipsToBounds = true
        
        self.btnLogout.layer.cornerRadius = 10
        self.btnLogout.clipsToBounds = true
        self.btnLogout.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        
        let name = UserDefaults.standard.object(forKey: "name") as? String

        self.lblName.text = name?.capitalized
        self.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblName.font =  UIFont(name: "Inter-SemiBold", size: 24)
        
        self.lblTitle.text = "My Account"
        self.lblTitle.font =  UIFont(name: "Inter-SemiBold", size: 16)
        
        
        self.lblEmail.text = UserDefaults.standard.object(forKey: "email") as? String
        self.lblEmail.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7)
        self.lblEmail.font =  UIFont(name: "Inter-Medium", size: 16)
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        myAppDelegate.serialNumber = ""
        
        self.btnChangePassword.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.btnChangePassword.setTitle("Change Password", for: .normal)
        self.btnChangePassword.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 14)
        self.btnChangePassword.titleLabel?.textColor = UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        self.btnChangePassword.layer.cornerRadius = 12
        self.btnChangePassword.clipsToBounds = true
        
        self.btnCancel.layer.cornerRadius = 16
        self.btnCancel.setTitleColor(UIColor.white, for: .normal)
        self.btnCancel.setTitle("Cancel", for: .normal)
        
        self.innerUpperView.layer.cornerRadius = 20
        self.lblNewProfile.text = "New profile picture"
        self.lblNewProfile.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblNewProfile.font =  UIFont(name: "Inter-Regular", size: 18)
        
        self.lblRemvoeImage.text = "Remove current picture"
        self.lblRemvoeImage.textColor = UIColor.init(red: 255.0/255.0, green: 159.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        self.lblRemvoeImage.font =  UIFont(name: "Inter-Regular", size: 18)
        
        
    }
    
    // MARK: - UIAction Method --------
    @IBAction func tapEdit(_ sender: Any) {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        self.mainView.isHidden = false
        self.hideBottomBar()
    }
    
    @IBAction func tapNewProfile(_ sender: Any) {
        if Device.IS_IPHONE
        {
            self.mainView.isHidden = true
            self.showBottomBar()
            let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
                print("User click Approve button")
                self.CameraPressed()
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
                print("User click Edit button")
                self.GalleryPressed()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default , handler:{ (UIAlertAction)in
                self.dismiss(animated: true)
            }))
            
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            
        }
        else
        {
            self.mainView.isHidden = true
            self.showBottomBar()
            let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
                print("User click Approve button")
                self.CameraPressed()
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
                print("User click Edit button")
                self.GalleryPressed()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default , handler:{ (UIAlertAction)in
                self.dismiss(animated: true)
            }))
            
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        }
       
    }
    @IBAction func tapLogout(_ sender: Any) {
        
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: webServices.AppName, message: "Are you sure, you want to logout?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action) in
        }))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
            self.viewLogout.logoutUser(viewController: self, isLoaderRequired: true) { errorString, msg in
                if errorString == "Success"
                {
                    self.mainView.isHidden = true
                    self.showBottomBar()
                    self.resetDefaults()
                    UserDefaults.standard.set("false", forKey: "login")
                    UserDefaults.standard.synchronize()
                    
                    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                    if myAppDelegate.isfromInactiveMode == "true"
                    {
                        let navRoot = self.storyboard!.instantiateViewController(withIdentifier: "RootNavigationController")
                        myAppDelegate.window?.rootViewController = navRoot
                        myAppDelegate.window?.makeKeyAndVisible()
                    }
                    else
                    {
                        myAppDelegate.setRootNavigation()
                    }
                  
                }
                else if errorString == "failT"
                {
                    let alert = UIAlertController(title: webServices.AppName, message: webServices.msgInternet, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                       
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    self.resetDefaults()
                    UserDefaults.standard.set("false", forKey: "login")
                    UserDefaults.standard.synchronize()
                    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                    myAppDelegate.setRootNavigation()
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func resetDefaults() {
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                if key == "email" ||  key == "pass"
                {
                    
                }
                else
                {
                    defaults.removeObject(forKey: key)
                }
            }
        }
    
    @IBAction func tapRemoveImage(_ sender: Any) {
       
        
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.viewLogout.removeUserProfile(viewController: self, isLoaderRequired: true) { errorString, msg in
            if errorString == "Success"
            {
                self.mainView.isHidden = true
                UserDefaults.standard.removeObject(forKey: "dpp")
                UserDefaults.standard.synchronize()
                self.userImage.image = UIImage(named: "picPlaceholder")?.withRenderingMode(.alwaysOriginal)
                self.showBottomBar()
                //self.view.makeToast(msg)
                self.tabBarController?.addSubviewToLastTabItem("",ischeck: true)


            }
            else if errorString == "failT"
            {
                let alert = UIAlertController(title: webServices.AppName, message: webServices.msgInternet, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                if msg == "Token is not valid"
                {
                    let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                      
                        UserDefaults.standard.set("false", forKey: "login")
                        UserDefaults.standard.synchronize()
                        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                        myAppDelegate.setRootNavigation()
                        myAppDelegate.resetDefaults()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    //self.view.makeToast(msg)
                }
            }
        }
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        self.mainView.isHidden = true
        self.showBottomBar()
    }
    
    @IBAction func tapChangePassword(_ sender: Any) {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Internal Action Methods
    
    @objc private func CameraPressed(){
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status{
        case .authorized: // The user has previously granted access to the camera.
            self.openCamera()
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.openCamera()
                }
            }
            //denied - The user has previously denied access.
            //restricted - The user can't grant access due to restrictions.
        case .denied, .restricted:
            CommonFunctions.sharedInstance.alertForSettings(title: "Camera Usage Permission", msg: Message.alertForCameraAccessMessage, vc: self)
            return
            
        default:
            break
        }
        
    }
    
    
    @objc private func GalleryPressed(){
        let status = PHPhotoLibrary.authorizationStatus()
        print("photo status:- \(status)");
        switch status{
        case .authorized: // The user has previously granted access to the camera.
            self.openphotoLibrary()
            
        case .notDetermined: // The user has not yet been asked for camera access.
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.openphotoLibrary()
                }
            }
            //denied - The user has previously denied access.
            //restricted - The user can't grant access due to restrictions.
        case .denied, .restricted:
            print("denied permission");
            CommonFunctions.sharedInstance.alertForSettings(title: "Photo Library Usage Permission", msg: Message.alertForPhotoLibraryMessage,vc:self)
            return
            
        default:
            break
        }
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            DispatchQueue.main.async { [self] in
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                self.present(myPickerController, animated: true, completion: nil)
            }
            
        }
    }
    
    func openphotoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            DispatchQueue.main.async { [self] in
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                self.present(myPickerController, animated: true, completion: nil)
                
            }
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.userImage.contentMode = .scaleAspectFill
            let scaledImage:UIImage = resizeImage(image: image, newWidth: 500)
           
            if image.jpeg(.lowest) != nil {
            }

            self.viewModel.uploadProfileImage(img: scaledImage, viewController: self) { errorMessage, msg, image in
                if errorMessage == "Success"
                {
                    self.userImage.image = scaledImage
                    UserDefaults.standard.removeObject(forKey: "dpp")
                    UserDefaults.standard.set(image, forKey: "dpp")
                    UserDefaults.standard.synchronize()
                    self.tabBarController?.addSubviewToLastTabItem(image,ischeck: true)
                    //self.view.makeToast(msg)
                }
                else if errorMessage == "failT"
                {
                    let alert = UIAlertController(title: webServices.AppName, message: webServices.msgInternet, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                       
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    if msg == "Token is not valid"
                    {
                        let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                          
                            UserDefaults.standard.set("false", forKey: "login")
                            UserDefaults.standard.synchronize()
                            let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                            myAppDelegate.setRootNavigation()
                            myAppDelegate.resetDefaults()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        //self.view.makeToast(msg)
                    }
                }
            }

        }
        // call service for upload image to server
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("cancelled called");
        self.dismiss(animated: false, completion: nil)
    }
}

extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
}


extension UITabBarController {
    
    func addSubviewToLastTabItem(_ image: String?, ischeck : Bool) {
       
        if let lastTabBarButton = self.tabBar.subviews.last, let tabItemImageView = lastTabBarButton.subviews.first {
            if let accountTabBarItem = self.tabBar.items?.last {
                accountTabBarItem.selectedImage = nil
                accountTabBarItem.image = nil
            }
            
            for cview in self.tabBar.subviews.last!.subviews {
                if cview.tag == 4500
                {
                    cview.removeFromSuperview()
                }
            }
            
            
            
            let imgView = UIImageView()
            imgView.tag = 4500
            if Device.IS_IPHONE
            {
                imgView.image = nil
                imgView.frame = tabItemImageView.frame
            }
            else
            {
                if UIDevice.current.orientation.isLandscape
                {
                    imgView.frame = CGRect(x: 60, y: 11, width: 26, height: 26)
                }
                else
                {
                    imgView.frame = CGRect(x: 30, y: 11, width: 26, height: 26)
                }
                
            }
            imgView.layer.cornerRadius = tabItemImageView.frame.height/2
            imgView.layer.masksToBounds = true
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            
            if ischeck == false || ischeck == true
            {
                if image == "" || image == nil{
                    imgView.image = UIImage(named: "picPlaceholder")?.withRenderingMode(.alwaysOriginal)
                }
                else
                {
                    imgView.image = UIImage(named: "picPlaceholder")?.withRenderingMode(.alwaysOriginal)
                    let url = URL(string: image!)!

                      // Create Data Task
                      let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                          if let data = data {
                              // Create Image and Update Image View
                              DispatchQueue.main.async {
                                            // Create Image and Update Image View
                                  imgView.image = UIImage(data: data)
                                  imgView.contentMode = .scaleToFill
                            }
                          }
                      }
                    dataTask.resume()
                }
                
                self.tabBar.subviews.last?.addSubview(imgView)
            }
        }
        
    }
}
