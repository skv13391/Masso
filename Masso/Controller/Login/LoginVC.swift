//
//  LoginVC.swift
//  Masso
//
//  Created by Sunil on 22/03/23.
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import Toast_Swift
import FirebaseMessaging

class LoginVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var txtFieldEmail: MDCOutlinedTextField!
    @IBOutlet weak var txtFieldPassword: MDCOutlinedTextField!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var scrlHeight: NSLayoutConstraint!
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblLoginTopConstrainer: NSLayoutConstraint!
    @IBOutlet weak var passTopConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var scrlTop: NSLayoutConstraint!
    
    var viewModelHome = HomeViewModel()
    var viewModel = NewLoginViewModel()
    
    // MARK: - View Life Cycle ----------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFont()
        self.setUpTextField()
        self.lblUnderLineWithAction()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.scrlHeight.constant = 0
            self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)
        }
        else
        {
            if UIDevice.current.orientation.isLandscape {
                print("Landscape")
                self.scrlHeight.constant = (1400.0 - self.view.frame.size.width)
                self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)
               // self.lblLoginTopConstrainer.constant = 10
            } else {
                print("Portrait")
                self.scrlHeight.constant = 0
                self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)
               // self.lblLoginTopConstrainer.constant = 68

            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            self.scrlHeight.constant = (1400.0 - self.view.frame.size.width)
            self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)
        } else {
            print("Portrait")
            self.scrlHeight.constant = 0
            self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)            
        }
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            self.scrlTop.constant = 0
        } else {
            self.scrlTop.constant = -110
        }

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
          super.viewWillTransition(to: size, with: coordinator)
          if UIDevice.current.orientation.isLandscape {
              print("Landscape")
              self.scrlHeight.constant = (1200.0 - self.view.frame.size.width)
              self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)
             // self.lblLoginTopConstrainer.constant = 10
          } else {
              print("Portrait")
              self.scrlHeight.constant = 0
              self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)
             // self.lblLoginTopConstrainer.constant = 68

          }
      }
    
    
    func setFont()
    {
        let attrs1 = [NSAttributedString.Key.font : CommonFont.interSemiBold, NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]

        let attrs2 = [NSAttributedString.Key.font : CommonFont.interLight, NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
                                   
                                            
        let attributedString1 = NSMutableAttributedString(string:"Login to" + "\n", attributes:attrs1 as [NSAttributedString.Key : Any])

        let attributedString2 = NSMutableAttributedString(string:"MASSO Link", attributes:attrs2 as [NSAttributedString.Key : Any])
                    

        attributedString1.append(attributedString2)
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.lblLogin.font = CommonFont.interSemiBold
        }
        else
        {
            self.lblLogin.font = CommonFont.interSemiBoldIpad
        }
        self.lblLogin.text = "Login"
        self.lblLogin.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.btnLogin.layer.cornerRadius = 10
        self.btnLogin.clipsToBounds = true
        
        if Device.IS_IPHONE
        {
            self.btnLogin.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
            self.lblForgotPassword.font =  UIFont(name: "Inter-SemiBold", size: 14)
            self.txtFieldEmail.label.font = UIFont(name: "Roboto-Light", size: 12)
            self.txtFieldPassword.label.font = UIFont(name: "Roboto-Light", size: 12)
        }
        else
        {
            self.btnLogin.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 30)
            self.lblForgotPassword.font =  UIFont(name: "Inter-SemiBold", size: 30)
            self.txtFieldEmail.label.font = UIFont(name: "Roboto-Light", size: 30)
            self.txtFieldPassword.label.font = UIFont(name: "Roboto-Light", size: 30)
        }
        
    }

    func lblUnderLineWithAction()
    {
        
        let textLogin = "Forgot Password"

        self.lblForgotPassword.textColor =  UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblForgotPassword.text = textLogin
        let underlineAttriStringNew = NSMutableAttributedString(string: textLogin)
        let range11 = (textLogin as NSString).range(of: "Forgot Password")
        
        underlineAttriStringNew.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Inter-SemiBold", size: 14)!, range: range11)
        
        if Device.IS_IPHONE
        {
            underlineAttriStringNew.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Inter-SemiBold", size: 14)!, range: range11)
        }
        else
        {
            underlineAttriStringNew.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Inter-SemiBold", size: 25)!, range: range11)
        }
       
        underlineAttriStringNew.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range11)
        self.lblForgotPassword.attributedText = underlineAttriStringNew
        self.lblForgotPassword.isUserInteractionEnabled = true
        self.lblForgotPassword.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapForgotPassword(gesture:))))

      
    }
    
    @objc func tapForgotPassword(gesture: UITapGestureRecognizer) {
        print("tapped Forgot Password")
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setUpTextField()
    {
        self.txtFieldEmail.setLeadingAssistiveLabelColor(UIColor.white, for: MDCTextControlState.normal)
        self.txtFieldEmail.containerRadius = 10
        self.txtFieldEmail.label.text = "Email"
        self.txtFieldEmail.placeholder = "Email"
        self.txtFieldEmail.setNormalLabelColor(UIColor.lightGray, for: .normal)
        self.txtFieldEmail.setNormalLabelColor(UIColor.lightGray, for: .editing)
        self.txtFieldEmail.setFloatingLabelColor(UIColor.white, for: .editing)
        self.txtFieldEmail.setFloatingLabelColor(UIColor.white, for: .normal)
        self.txtFieldEmail.label.textColor = UIColor.init(named: "White")
        self.txtFieldEmail.font = UIFont(name: "Roboto-Regular", size: 16)
        self.txtFieldEmail.sizeToFit()
        self.txtFieldEmail.delegate = self
        self.txtFieldEmail.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .editing)
        self.txtFieldEmail.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .normal)
        self.txtFieldEmail.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .normal)
        self.txtFieldEmail.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .editing)
        self.txtFieldEmail.attributedPlaceholder = NSAttributedString(string: self.txtFieldEmail.placeholder ?? "",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                                                  NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16)!])
        
        self.txtFieldPassword.setLeadingAssistiveLabelColor(UIColor.white, for: MDCTextControlState.normal)
        self.txtFieldPassword.containerRadius = 10
        self.txtFieldPassword.label.text = "Password"
        self.txtFieldPassword.placeholder = "Password"
        self.txtFieldPassword.setNormalLabelColor(UIColor.lightGray, for: .normal)
        self.txtFieldPassword.setNormalLabelColor(UIColor.lightGray, for: .editing)
        self.txtFieldPassword.setFloatingLabelColor(UIColor.white, for: .editing)
        self.txtFieldPassword.setFloatingLabelColor(UIColor.white, for: .normal)
        self.txtFieldPassword.label.textColor = UIColor.init(named: "White")
        self.txtFieldPassword.font = UIFont(name: "Roboto-Regular", size: 16)
        self.txtFieldPassword.sizeToFit()
        self.txtFieldPassword.delegate = self
        self.txtFieldPassword.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .editing)
        self.txtFieldPassword.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .normal)
        self.txtFieldPassword.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .normal)
        self.txtFieldPassword.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .editing)
        self.txtFieldPassword.attributedPlaceholder = NSAttributedString(string: self.txtFieldPassword.placeholder ?? "",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                                                  NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16)!])
        
        
        self.txtFieldEmail.label.font = UIFont(name: "Roboto-Light", size: 12)
        self.txtFieldPassword.label.font = UIFont(name: "Roboto-Light", size: 12)
        
        if Device.IS_IPHONE
        {
            
            self.txtFieldEmail.label.font = UIFont(name: "Roboto-Light", size: 12)
            self.txtFieldPassword.label.font = UIFont(name: "Roboto-Light", size: 12)
        }
        else
        {
            
            self.txtFieldEmail.label.font = UIFont(name: "Roboto-Light", size: 16)
            self.txtFieldPassword.label.font = UIFont(name: "Roboto-Light", size: 16)
        }

    }
    
    // MARK: - UIAction Method ---------
    
    @IBAction func tapLogin(_ sender: Any) {
    
        self.view.endEditing(true)
        self.view.resignFirstResponder()
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if self.checkValidation()
        {
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("Error fetching FCM registration token: \(error)")
                } else if let token = token {
                    print("FCM registration token: \(token)")
                    print("Remote FCM registration token: \(token)")
                }
                
                let dict = ["username": self.txtFieldEmail.text!,"password" : self.txtFieldPassword.text!,"device_token" : token ?? ""]
                
                self.viewModel.getLogin(dictDat: dict as NSDictionary, viewController: self) { errorMessage, msg, serial in
                    if errorMessage == "Success"
                    {
                       /* if serial.count == 0 || serial == "many"
                        {
                            let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                            myAppDelegate.isFromLogin = true
                            UserDefaults.standard.set("true", forKey: "login")
                            UserDefaults.standard.set(self.txtFieldEmail.text!, forKey: "email")
                            UserDefaults.standard.synchronize()
                            myAppDelegate.moveToDashboard()
                        }
                        else
                        {
                            self.getstateAndPush(serial: serial)
                        }*/
                        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                        myAppDelegate.isFromLogin = true
                        UserDefaults.standard.set("true", forKey: "login")
                        UserDefaults.standard.set(self.txtFieldEmail.text!, forKey: "email")
                        UserDefaults.standard.synchronize()
                        myAppDelegate.moveToDashboard()
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
                        let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                           
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func getstateAndPush(serial : String)
    {
        self.viewModelHome.getControllersListDetails(id: Int(serial)!, viewController: self) { errorMessage, msg, list in
            if errorMessage == "Success"
            {
                let state = list.state
                let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                myAppDelegate.isFromPush = true
                myAppDelegate.comingState = state
                myAppDelegate.pushSerialNumber = serial
                
                myAppDelegate.isFromLogin = true
                UserDefaults.standard.set("true", forKey: "login")
                UserDefaults.standard.set(self.txtFieldEmail.text!, forKey: "email")
                UserDefaults.standard.synchronize()
                myAppDelegate.moveToDashboard()
            }
        }
    }
    
   
    
    func updateTokenOnServer()
    {
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
           print("Remote FCM registration token: \(token)")
          }
            
            self.viewModel.updateTokenToServer(token: token!, viewController: self) { errorMessage, msg in
                if errorMessage == "Success"
                {
                    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                    myAppDelegate.singleList = "false"
                    UserDefaults.standard.set("true", forKey: "login")
                    UserDefaults.standard.set(self.txtFieldEmail.text!, forKey: "email")
                    UserDefaults.standard.synchronize()
                    myAppDelegate.moveToDashboard()
                }
            }
        }
        
        
    }
    
    // MARK: - Validation Method-----
    
    func checkValidation()-> Bool
    {
         if (self.txtFieldEmail.text?.isEmpty ?? true)
           {
               let alert = UIAlertController(title: webServices.AppName, message: "Please enter Email Id.", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               }))
               self.present(alert, animated: true, completion: nil)
               return false
           }
//        else if !self.isValidEmailId(emailId: self.txtFieldEmail.text!)
//           {
//               let alert = UIAlertController(title: webServices.AppName, message: "Please enter Valid Email Id.", preferredStyle: UIAlertController.Style.alert)
//               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//               }))
//               self.present(alert, animated: true, completion: nil)
//               return false
//           }
        else if (self.txtFieldPassword.text?.isEmpty ?? true)
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Please enter Password.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        
        return true
    }
    
    // MARK:- Valid Email
        func isValidEmailId(emailId email:String) -> Bool{
            
            let emailFormat =  "[A-Za-z0-9._%+-]{1,}+(\\.[_A-Za-z0-9-]+)*@"
                + "[A-Za-z]+(\\.[A-Za-z]+)*(\\.[A-Za-z]{2,})$"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: email)
        }
    
    //MARK: -  UITextField Delegate

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.view.resignFirstResponder()
        return true
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.txtFieldEmail == textField 
        {
            let maxLength = 40
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        

        
        return true
    }
}

