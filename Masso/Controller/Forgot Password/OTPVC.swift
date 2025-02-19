//
//  OTPVC.swift
//  Masso
//
//  Created by Sunil on 22/03/23.
//

import UIKit
import Toast_Swift


class OTPVC: UIViewController {
    
    @IBOutlet weak var otpView: VPMOTPView!
    var isOtpEntered:Bool = false
    var enteredOtp:String = ""
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var scrlHeight: NSLayoutConstraint!
    @IBOutlet weak var lblResendOTP: UILabel!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var scrlTop: NSLayoutConstraint!
    @IBOutlet weak var btnBackLogin: UIButton!
    
    var transID = String()
    var email = String()
    var viewModel = NewLoginViewModel()
    var timer : Timer!
    var counter : Int = 30
    
    
    // MARK: - View Life Cycle -------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupOtpView()
        self.btnContinue.isUserInteractionEnabled = false
        
        self.lblTitle.text = "Enter 4 digit code"
        self.lblTitle.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
        
        self.lblDescription.text = "Enter 4 digit code that you recieved on you email."
        self.lblDescription.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
        self.setDefaultButtonStyle()
        self.lblCounter.textColor =  UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
        self.lblTitle.font = UIFont(name: "Inter-SemiBold", size: 22)
        self.lblDescription.font = UIFont(name: "Inter-Light", size: 12)
        self.btnContinue.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
        self.lblUnderLineWithAction()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setUPMode), userInfo: nil, repeats: true)
        
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
    
    @objc func setUPMode()
    {
        
        if self.counter == 0
        {
            self.lblLine.isHidden = false
            self.lblResendOTP.isHidden = false
            self.lblCounter.isHidden = true
            self.counter = 30
            self.timer.invalidate()
            
        }
        else
        {
            self.lblLine.isHidden = true
            self.lblResendOTP.isHidden = true
            self.lblCounter.isHidden = false
            self.counter -= 1
            self.lblCounter.text = "Resend in " + "\(self.counter)" + " sec"
        }
    }
    
    func lblUnderLineWithAction()
    {
        if Device.IS_IPHONE
        {
            self.lblTitle.font = UIFont(name: "Inter-SemiBold", size: 22)
            self.lblDescription.font = UIFont(name: "Inter-Light", size: 12)
            self.lblResendOTP.font =  UIFont(name: "Inter-SemiBold", size: 14)
            self.btnContinue.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
            self.btnBackLogin.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 14)
            self.lblResendOTP.font =  UIFont(name: "Inter-SemiBold", size: 14)
            self.lblCounter.font =  UIFont(name: "Inter-SemiBold", size: 14)
        }
        else
        {
            self.lblTitle.font = UIFont(name: "Inter-SemiBold", size: 32)
            self.lblDescription.font = UIFont(name: "Inter-Light", size: 20)
            self.lblResendOTP.font =  UIFont(name: "Inter-SemiBold", size: 20)
            self.btnContinue.titleLabel?.font = UIFont(name: "Inter-Medium", size: 30)
            self.btnBackLogin.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 25)
            self.lblResendOTP.font =  UIFont(name: "Inter-SemiBold", size: 25)
            self.lblCounter.font =  UIFont(name: "Inter-SemiBold", size: 25)
        }
        
        
        
        self.lblResendOTP.text = "Resend OTP"
        
        self.lblResendOTP.textColor =  UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblResendOTP.isUserInteractionEnabled = true
        self.lblResendOTP.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapResendOTP(gesture:))))
        
        
    }
    
    @objc func tapResendOTP(gesture: UITapGestureRecognizer) {
        
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] (action) in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let dict = ["email" : self.email,"operation" : "1"]
        
        self.viewModel.forgotPasswordOTP(dictDat: dict as NSDictionary, viewController: self) { [self] errorMessage, msg, otp, transID in
            if errorMessage == "Success"
            {
                let alert = UIAlertController(title: webServices.AppName, message: webServices.msgOTP, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
                
                self.transID = transID
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setUPMode), userInfo: nil, repeats: true)
                
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
    
    func setDefaultButtonStyle()
    {
        self.btnContinue.isUserInteractionEnabled = false
        self.btnContinue.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.12)
        self.btnContinue.layer.cornerRadius = 10
        self.btnContinue.layer.borderWidth = 1
        self.btnContinue.layer.borderColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5).cgColor
        self.btnContinue.clipsToBounds = true
        self.btnContinue.setTitleColor(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.5), for: .normal)
    }
    
    func setCompleteStyle(count : Int)
    {
        self.btnContinue.backgroundColor = UIColor.init(red: 255.0/255.0, green: 159.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        self.btnContinue.layer.cornerRadius = 10
        self.btnContinue.layer.borderWidth = 0
        self.btnContinue.clipsToBounds = true
        self.btnContinue.setTitleColor(UIColor.black, for: .normal)
        self.btnContinue.isUserInteractionEnabled = true
        
    }
    
    func setupOtpView(){
        
        self.otpView.otpFieldBorderWidth = 1
        self.otpView.otpFieldDefaultBorderColor = UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        self.otpView.otpFieldEnteredBorderColor = UIColor.init(red: 74.0/255.0, green: 184.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        self.otpView.otpFieldBorderWidth = 1
        self.otpView.otpFieldsCount = 4;
        
        if Device.IS_IPHONE
        {
            if Device.IS_IPHONE_X
            {
                self.otpView.otpFieldSize = 55;
                self.otpView.otpFieldSeparatorSpace = 30
                
            }
            else
            {
                self.otpView.otpFieldSize = 50;
                self.otpView.otpFieldSeparatorSpace = 20
            }
            
            self.otpView.delegate = self
            self.otpView.cursorColor = UIColor.white
            
            
            self.otpView.initializeUI();
            
        }
        else
        {
            
                self.otpView.otpFieldSize = 50;
                self.otpView.otpFieldSeparatorSpace = 20
                self.otpView.delegate = self
                self.otpView.cursorColor = UIColor.white
                self.otpView.initializeUI();
        }
    }
    
    


    // MARK: - UIAction Method -------------
    
    @IBAction func tapBackLogin(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func tapContinue(_ sender: Any) {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        print("tapped Forgot Password")
        let dict = ["otp": self.enteredOtp,"trans_id":self.transID]
        
        self.viewModel.verifyOTP(dictDat: dict as NSDictionary, viewController: self) { errorMessage, msg, transID in
            if errorMessage == "Success"
            {
                let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC{
                        vc.token = transID
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


extension OTPVC: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        self.isOtpEntered = hasEntered;
        if hasEntered == true
        {
            self.setCompleteStyle(count: 4)
            return hasEntered
        }
        else
        {
            self.setDefaultButtonStyle()
            return false
        }
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        print(index)
        return true
    }
    
    func enteredOTP(otpString: String) {
        print("OTPString: \(otpString)")
        self.enteredOtp = otpString
    }
}

