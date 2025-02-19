//
//  ResetPasswordVC.swift
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


class ResetPasswordVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var scrlHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var txtFIeldNewPassword: MDCOutlinedTextField!
    @IBOutlet weak var txtFieldConfirmPass: MDCOutlinedTextField!
    @IBOutlet weak var btnResetPassword: UIButton!
    @IBOutlet weak var btnBackLogin: UIButton!
    var token = String()
    var viewModel = NewLoginViewModel()
    var timer = Timer()
    @IBOutlet weak var scrlTop: NSLayoutConstraint!
    
    // MARK: - View Life Cycle-----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = "Reset Password"
        self.lblTitle.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)

        
        self.lblDetails.text = "Set the new password for account so that you can login and access all the features."
        self.lblDetails.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)

        self.setUpTextField()
        self.setCompleteStyle()
        

        
        if Device.IS_IPHONE
        {
            self.lblDetails.font = UIFont(name: "Inter-Light", size: 12)
            self.lblTitle.font = UIFont(name: "Inter-SemiBold", size: 22)
            self.btnResetPassword.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
            self.btnBackLogin.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 14)

        }
        else
        {
            self.lblDetails.font = UIFont(name: "Inter-Light", size: 20)
            self.lblTitle.font = UIFont(name: "Inter-SemiBold", size: 32)
            self.btnResetPassword.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 30)
            self.btnBackLogin.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 25)
        }
    }
    
    func setCompleteStyle()
    {
        self.btnResetPassword.backgroundColor = UIColor.init(red: 255.0/255.0, green: 159.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        self.btnResetPassword.layer.cornerRadius = 10
        self.btnResetPassword.layer.borderWidth = 1
        self.btnResetPassword.clipsToBounds = true
        self.btnResetPassword.setTitleColor(UIColor.black, for: .normal)
        self.btnResetPassword.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        
        if Device.IS_IPHONE
        {
            self.lblTitle.font = UIFont(name: "Inter-SemiBold", size: 22)
            self.lblDetails.font = UIFont(name: "Inter-Light", size: 12)
            self.btnResetPassword.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
        }
        else
        {
            self.lblTitle.font = UIFont(name: "Inter-SemiBold", size: 26)
            self.lblDetails.font = UIFont(name: "Inter-Light", size: 16)
            self.btnResetPassword.titleLabel?.font = UIFont(name: "Inter-Medium", size: 26)

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
        self.txtFIeldNewPassword.setLeadingAssistiveLabelColor(UIColor.white, for: MDCTextControlState.normal)
        self.txtFIeldNewPassword.containerRadius = 10
        self.txtFIeldNewPassword.label.text = "New password"
        self.txtFIeldNewPassword.placeholder = "Enter New password"
        self.txtFIeldNewPassword.setNormalLabelColor(UIColor.lightGray, for: .normal)
        self.txtFIeldNewPassword.setNormalLabelColor(UIColor.lightGray, for: .editing)
        self.txtFIeldNewPassword.setFloatingLabelColor(UIColor.white, for: .editing)
        self.txtFIeldNewPassword.setFloatingLabelColor(UIColor.white, for: .normal)
        self.txtFIeldNewPassword.label.textColor = UIColor.init(named: "White")
        self.txtFIeldNewPassword.label.font = UIFont(name: "Roboto-Light", size: 12)
        self.txtFIeldNewPassword.font = UIFont(name: "Roboto-Regular", size: 16)
        self.txtFIeldNewPassword.sizeToFit()
        self.txtFIeldNewPassword.delegate = self
        self.txtFIeldNewPassword.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .editing)
        self.txtFIeldNewPassword.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .normal)
        self.txtFIeldNewPassword.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .normal)
        self.txtFIeldNewPassword.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .editing)
        self.txtFIeldNewPassword.attributedPlaceholder = NSAttributedString(string: self.txtFIeldNewPassword.placeholder ?? "",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                                                  NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16)!])
        
        self.txtFieldConfirmPass.setLeadingAssistiveLabelColor(UIColor.white, for: MDCTextControlState.normal)
        self.txtFieldConfirmPass.containerRadius = 10
        self.txtFieldConfirmPass.label.text = "Confirm Password"
        self.txtFieldConfirmPass.placeholder = "Confirm Password"
        self.txtFieldConfirmPass.setNormalLabelColor(UIColor.lightGray, for: .normal)
        self.txtFieldConfirmPass.setNormalLabelColor(UIColor.lightGray, for: .editing)
        self.txtFieldConfirmPass.setFloatingLabelColor(UIColor.white, for: .editing)
        self.txtFieldConfirmPass.setFloatingLabelColor(UIColor.white, for: .normal)
        self.txtFieldConfirmPass.label.textColor = UIColor.init(named: "White")
        self.txtFieldConfirmPass.label.font = UIFont(name: "Roboto-Light", size: 12)
        self.txtFieldConfirmPass.font = UIFont(name: "Roboto-Regular", size: 16)
        self.txtFieldConfirmPass.sizeToFit()
        self.txtFieldConfirmPass.delegate = self
        self.txtFieldConfirmPass.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .editing)
        self.txtFieldConfirmPass.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .normal)
        self.txtFieldConfirmPass.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .normal)
        self.txtFieldConfirmPass.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .editing)
        self.txtFieldConfirmPass.attributedPlaceholder = NSAttributedString(string: self.txtFieldConfirmPass.placeholder ?? "",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                                                  NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16)!])
        

    }

    // MARK: - UIAction Method-----

    @IBAction func tapBackLogin(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func tapResetPassword(_ sender: Any) {
        
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
            let dict = ["password":self.txtFIeldNewPassword.text!,"token":self.token]
            
            self.viewModel.resetPassword(dictDat: dict as NSDictionary, viewController: self) { [self] errorMessage, msg in
                if errorMessage == "Success"
                {
                    let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateCounterImage), userInfo: nil, repeats: true)
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
    
    @objc func updateCounterImage()
    {
        self.timer.invalidate()
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    // MARK: - Validation Method-----
    
    func checkValidation()-> Bool
    {
         if (self.txtFIeldNewPassword.text?.isEmpty ?? true)
           {
               let alert = UIAlertController(title: webServices.AppName, message: "Please enter new password.", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               }))
               self.present(alert, animated: true, completion: nil)
               return false
           }
       
        else if (self.txtFieldConfirmPass.text?.isEmpty ?? true)
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Please enter confirm password.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        else if self.txtFieldConfirmPass.text! != self.txtFIeldNewPassword.text!
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Password must be same.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
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
        
        
        
        
        return true
    }
}

