//
//  ChangePasswordVC.swift
//  Masso
//
//  Created by Sunil on 29/03/23.
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import Toast_Swift


class ChangePasswordVC: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var lblChangepassword: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtFieldCurrentPassword: MDCOutlinedTextField!
    @IBOutlet weak var txtFielfNewPassword: MDCOutlinedTextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtFieldConfirmPassword: MDCOutlinedTextField!
    
    var viewModel = NewLoginViewModel()
    
    // MARK: - View Life Cycle ---------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTextField()
        self.setUPUI()
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        myAppDelegate.showSerial = "11"
        // Do any additional setup after loading the view.
    }
    
    func setUPUI()
    {
        self.lblTitle.text = "My Account"
        self.lblTitle.font =  UIFont(name: "Inter-SemiBold", size: 16)
        
        self.lblChangepassword.text = "Change Password"
        self.lblChangepassword.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblChangepassword.font =  UIFont(name: "Inter-SemiBold", size: 22)
        
        self.btnSubmit.layer.cornerRadius = 10
        self.btnSubmit.clipsToBounds = true
        self.btnSubmit.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        self.btnSubmit.titleLabel?.textColor = UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        
        
        self.btnBack.layer.cornerRadius = 10
        self.btnBack.layer.borderWidth = 1
        self.btnBack.layer.borderColor = UIColor.white.cgColor
        self.btnBack.clipsToBounds = true
        self.btnBack.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.12)
        self.btnBack.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        self.btnBack.setTitleColor(UIColor.white, for: .normal)
    }
    
    func setUpTextField()
    {
        
        self.txtFieldCurrentPassword.setLeadingAssistiveLabelColor(UIColor.white, for: MDCTextControlState.normal)
        self.txtFieldCurrentPassword.containerRadius = 10
        self.txtFieldCurrentPassword.label.text = "Old Password"
        self.txtFieldCurrentPassword.placeholder = "Enter old password"
        self.txtFieldCurrentPassword.setNormalLabelColor(UIColor.lightGray, for: .normal)
        self.txtFieldCurrentPassword.setNormalLabelColor(UIColor.lightGray, for: .editing)
        self.txtFieldCurrentPassword.setFloatingLabelColor(UIColor.white, for: .editing)
        self.txtFieldCurrentPassword.setFloatingLabelColor(UIColor.white, for: .normal)
        self.txtFieldCurrentPassword.label.textColor = UIColor.init(named: "White")
        self.txtFieldCurrentPassword.label.font = UIFont(name: "Roboto-Light", size: 12)
        self.txtFieldCurrentPassword.font = UIFont(name: "Roboto-Regular", size: 16)
        self.txtFieldCurrentPassword.sizeToFit()
        self.txtFieldCurrentPassword.delegate = self
        self.txtFieldCurrentPassword.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .editing)
        self.txtFieldCurrentPassword.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .normal)
        self.txtFieldCurrentPassword.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .normal)
        self.txtFieldCurrentPassword.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .editing)
        self.txtFieldCurrentPassword.attributedPlaceholder = NSAttributedString(string: self.txtFieldCurrentPassword.placeholder ?? "",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                                                  NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16)!])
        
        
        self.txtFielfNewPassword.setLeadingAssistiveLabelColor(UIColor.white, for: MDCTextControlState.normal)
        self.txtFielfNewPassword.containerRadius = 10
        self.txtFielfNewPassword.label.text = "Create New Password"
        self.txtFielfNewPassword.placeholder = "create new password"
        self.txtFielfNewPassword.setNormalLabelColor(UIColor.lightGray, for: .normal)
        self.txtFielfNewPassword.setNormalLabelColor(UIColor.lightGray, for: .editing)
        self.txtFielfNewPassword.setFloatingLabelColor(UIColor.white, for: .editing)
        self.txtFielfNewPassword.setFloatingLabelColor(UIColor.white, for: .normal)
        self.txtFielfNewPassword.label.textColor = UIColor.init(named: "White")
        self.txtFielfNewPassword.label.font = UIFont(name: "Roboto-Light", size: 12)
        self.txtFielfNewPassword.font = UIFont(name: "Roboto-Regular", size: 16)
        self.txtFielfNewPassword.sizeToFit()
        self.txtFielfNewPassword.delegate = self
        self.txtFielfNewPassword.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .editing)
        self.txtFielfNewPassword.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .normal)
        self.txtFielfNewPassword.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .normal)
        self.txtFielfNewPassword.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .editing)
        self.txtFielfNewPassword.attributedPlaceholder = NSAttributedString(string: self.txtFielfNewPassword.placeholder ?? "",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                                                  NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16)!])
        
        self.txtFieldConfirmPassword.setLeadingAssistiveLabelColor(UIColor.white, for: MDCTextControlState.normal)
        self.txtFieldConfirmPassword.containerRadius = 10
        self.txtFieldConfirmPassword.label.text = "Confirm Password"
        self.txtFieldConfirmPassword.placeholder = "Confirm password"
        self.txtFieldConfirmPassword.setNormalLabelColor(UIColor.lightGray, for: .normal)
        self.txtFieldConfirmPassword.setNormalLabelColor(UIColor.lightGray, for: .editing)
        self.txtFieldConfirmPassword.setFloatingLabelColor(UIColor.white, for: .editing)
        self.txtFieldConfirmPassword.setFloatingLabelColor(UIColor.white, for: .normal)
        self.txtFieldConfirmPassword.label.textColor = UIColor.init(named: "White")
        self.txtFieldConfirmPassword.label.font = UIFont(name: "Roboto-Light", size: 12)
        self.txtFieldConfirmPassword.font = UIFont(name: "Roboto-Regular", size: 16)
        self.txtFieldConfirmPassword.sizeToFit()
        self.txtFieldConfirmPassword.delegate = self
        self.txtFieldConfirmPassword.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .editing)
        self.txtFieldConfirmPassword.setOutlineColor(UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0), for: .normal)
        self.txtFieldConfirmPassword.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .normal)
        self.txtFieldConfirmPassword.setTextColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4), for: .editing)
        self.txtFieldConfirmPassword.attributedPlaceholder = NSAttributedString(string: self.txtFieldConfirmPassword.placeholder ?? "",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                                                  NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 16)!])
        

    }
    
    // MARK: - UIAction Method ---------

    @IBAction func tapSubmit(_ sender: Any) {
        self.callServiceForChangePassword()
        self.view.endEditing(true)
    }
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Validation Method-----
    func callServiceForChangePassword()
    {
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
            let dict = ["old" : self.txtFieldCurrentPassword.text!,"new" : self.txtFielfNewPassword.text!]
            self.viewModel.changePassword(dictDat: dict as NSDictionary, viewController: self) { errorMessage, msg in
                if errorMessage == "Success"
                {
                    
                    let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
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
                        self.view.makeToast(msg)
                    }
                }
            }
        }
    }
    
    // MARK: - Validation Method-----
    
    func checkValidation()-> Bool
    {
        if (self.txtFieldCurrentPassword.text?.isEmpty ?? true)
          {
              let alert = UIAlertController(title: webServices.AppName, message: "Please enter old password.", preferredStyle: UIAlertController.Style.alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
              }))
              self.present(alert, animated: true, completion: nil)
              return false
          }
        else if (self.txtFielfNewPassword.text?.isEmpty ?? true)
           {
               let alert = UIAlertController(title: webServices.AppName, message: "Please enter new password.", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               }))
               self.present(alert, animated: true, completion: nil)
               return false
           }
        else if (self.txtFieldConfirmPassword.text?.isEmpty ?? true)
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Please enter confirm password.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        else if self.txtFieldConfirmPassword.text! != self.txtFielfNewPassword.text!
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
