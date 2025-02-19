//
//  ForgotPasswordVC.swift
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

class ForgotPasswordVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var scrlHeight: NSLayoutConstraint!
    @IBOutlet weak var txtFieldEmail: MDCOutlinedTextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var scrlTop: NSLayoutConstraint!
    @IBOutlet weak var btnBackLogin: UIButton!
    
    var viewModel = NewLoginViewModel()
    
    // MARK: - View Life Cycle ----------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTextField()
        self.btnContinue.layer.cornerRadius = 10
        self.btnContinue.clipsToBounds = true
        self.btnContinue.setTitleColor(UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0), for: .normal)
        //self.txtFieldEmail.text = "aman123@gmail.com"
        self.lblTitle.text = "Forgot password"
        self.lblTitle.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
        self.lblDescription.text = "Enter your email for verification process, we will send 4 digit code to your email."
       
        self.lblDescription.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)

        
        if Device.IS_IPHONE
        {
            self.lblDescription.font = UIFont(name: "Inter-Light", size: 12)
            self.lblTitle.font = UIFont(name: "Inter-SemiBold", size: 22)
            self.btnContinue.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
            self.btnBackLogin.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 14)

        }
        else
        {
            self.lblDescription.font = UIFont(name: "Inter-Light", size: 20)
            self.lblTitle.font = UIFont(name: "Inter-SemiBold", size: 32)
            self.btnContinue.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 30)
            self.btnBackLogin.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 25)
        }
        
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            self.scrlHeight.constant = (1400.0 - self.view.frame.size.width)
            self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)
        } else {
            print("Portrait")
            self.scrlHeight.constant = 0
            self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)

        }

        // Do any additional setup after loading the view.
    }
  
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
          super.viewWillTransition(to: size, with: coordinator)
          if UIDevice.current.orientation.isLandscape {
              print("Landscape")
              self.scrlHeight.constant = (1200.0 - self.view.frame.size.width)
              self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)
          } else {
              print("Portrait")
              self.scrlHeight.constant = 0
              self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)

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
        self.txtFieldEmail.label.font = UIFont(name: "Roboto-Light", size: 12)
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
    }
    // MARK: - UIAction Method ----------
    
    @IBAction func tapBackLogin(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    @IBAction func tapContinue(_ sender: Any) {
        print("tapped Forgot Password")
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
            let dict = ["email" : self.txtFieldEmail.text!,"operation" : "1"]
            
            self.viewModel.forgotPasswordOTP(dictDat: dict as NSDictionary, viewController: self) { errorMessage, msg, otp, transID in
                if errorMessage == "Success"
                {
                    let alert = UIAlertController(title: webServices.AppName, message: webServices.msgOTP, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as? OTPVC{
                            vc.email = self.txtFieldEmail.text!
                            vc.transID = transID
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
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
        else if !self.isValidEmailId(emailId: self.txtFieldEmail.text!)
           {
               let alert = UIAlertController(title: webServices.AppName, message: "Please enter Valid Email Id.", preferredStyle: UIAlertController.Style.alert)
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
