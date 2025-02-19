//
//  DetailsIdleVC.swift
//  Masso
//
//  Created by Sunil on 29/03/23.
//



import UIKit

class DetailsAlarmVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblRunningBy: UILabel!
    @IBOutlet weak var viewCircleChart: CircularProgressBarViewBlue!
    var circularViewDuration: TimeInterval = 2
    @IBOutlet weak var machineView: UIView!
    @IBOutlet weak var lblCicle: UILabel!
    @IBOutlet weak var lblTextMachine: UILabel!
    @IBOutlet weak var lblPercentageOfMachine: UILabel!
    @IBOutlet weak var btnBell: UIButton!
    @IBOutlet weak var lblMachineTimeheader: UILabel!
    @IBOutlet weak var lblMachineTime: UILabel!
    @IBOutlet weak var lblPartMade: UILabel!
    @IBOutlet weak var lblNopartMade: UILabel!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblNameOfFile: UILabel!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var lblAlert: UILabel!
    @IBOutlet weak var bellView: UIView!
    @IBOutlet weak var imgInfo: UIImageView!
    @IBOutlet weak var btnToggel: UIButton!
    @IBOutlet weak var mHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrlHeight: NSLayoutConstraint!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var btnMail: UIButton!
    
    @IBOutlet weak var imgBell: UIImageView!
    @IBOutlet weak var alarmToggelView: UIView!
    @IBOutlet weak var alarmInnerView: UIView!
    @IBOutlet weak var imgMcn: UIImageView!
    @IBOutlet weak var btnCLose: UIButton!
    @IBOutlet weak var lblAlamName: UILabel!
    @IBOutlet weak var lblAlramDetails: UILabel!
    @IBOutlet weak var btnView: UIButton!
    var toggelStatus : Int = 0
    @IBOutlet weak var machineHeight: NSLayoutConstraint!
    @IBOutlet weak var lblOperatorName: UILabel!
    var strName = String()
    var serialNumber : String = ""
    var viewModel = HomeViewModel()
    var model = String()
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var lblOtherDetails: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    
    // MARK: - View Life Cycle ----------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBottomBar()
        self.setUpDeviceToggelAlarm()
        self.setUpProAlert()
        
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else
        {
            self.callServiceForDetails()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setUPUI(obj : controllersList)
    {
        self.model = obj.model
        self.toggelStatus = obj.alarm_sub
        self.bellView.layer.cornerRadius = self.bellView.frame.size.height / 2
        self.bellView.clipsToBounds = true
        
        if obj.alarm_sub == 1
        {
            self.imgBell.image = UIImage(named: "bell")
        }
        else
        {
            self.imgBell.image = UIImage(named: "sBell")
        }
        
        self.lblPercentageOfMachine.text = AppUtils.getAlertTypeMessage(valueAlert: obj.alarm_type)

        
        self.mainView.layer.cornerRadius = 8
        self.mainView.clipsToBounds = true
        
        self.scrlView.layer.cornerRadius = 8
        self.scrlView.clipsToBounds = true
        
        if Device.IS_IPHONE_X
        {
            self.imgWidth.constant = 56
            self.imgHeight.constant = 56
            self.scrlHeight.constant =  40//200
            self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height / 2
            self.imgProfile.clipsToBounds = true
        }
        else
        {
            self.imgWidth.constant = 120
            self.imgHeight.constant = 120
            self.imgProfile.layer.cornerRadius = 60
            self.imgProfile.clipsToBounds = true
            self.scrlHeight.constant =  150//200
            self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)

        }
        
       
        self.lblAlert.text = "Machine Got Stopped, Needs Oil, you need to repair this machines as soon as possible or please contact to support for further investigation. Here is the email id of support abd@support.com, you can also call support on this number 8762728"
        
        self.lblAlert.textColor = UIColor.init(red: 255.0/255.0, green: 159.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        self.lblAlert.font = UIFont(name: "Inter-Light", size: 13)
        
        self.lblName.text = obj.name
        self.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblName.font =  UIFont(name: "Inter-SemiBold", size: 16)
        self.strName = obj.name
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 24), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 16), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        
        let attributedString1 = NSMutableAttributedString(string:obj.name , attributes:attrs1 as [NSAttributedString.Key : Any])
        
        let attributedString2 = NSMutableAttributedString(string:"  "+obj.model.capitalized + "-" +  obj.serial.capitalized , attributes:attrs2 as [NSAttributedString.Key : Any])
        
        attributedString1.append(attributedString2)
        
        self.lblDeviceName.font = UIFont(name: "Inter-SemiBold", size: 20)
        self.lblDeviceName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblDeviceName.text = obj.name
        self.strName = obj.name
        self.lblRunningBy.font = UIFont(name: "Inter-Light", size: 16)
        self.lblRunningBy.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblRunningBy.text = obj.model.capitalized + "-" +  obj.serial
        
        self.lblOperatorName.font = UIFont(name: "Inter-Bold", size: 18)
        self.lblOperatorName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblOperatorName.text = obj.operatorName
        
        
        let attrs11 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 16), NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let attrs22 = [NSAttributedString.Key.font : UIFont(name: "Inter-light", size: 16), NSAttributedString.Key.foregroundColor : UIColor.init(red: 122.0/255.0, green: 144.0/255.0, blue: 156.0/255.0, alpha: 1.0)]
        
        
        let attributedString11 = NSMutableAttributedString(string:"Running by:" , attributes:attrs22 as [NSAttributedString.Key : Any])
        
        let attributedString21 = NSMutableAttributedString(string:" "+obj.operatorName .capitalized , attributes:attrs11 as [NSAttributedString.Key : Any])
        
        attributedString11.append(attributedString21)
//        self.lblRunningBy.font = UIFont(name: "Inter-light", size: 16)
//        self.lblRunningBy.text = obj.operatorName.capitalized
       
        self.viewCircleChart.progressAnimation(duration: circularViewDuration,toValue: 0.45)
        self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 230)

        
        self.lblTextMachine.text = "Alarm"
        self.lblTextMachine.textColor = UIColor.init(red: 1.0/255.0, green: 133.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.lblTextMachine.font = UIFont(name: "Inter-Regular", size: 16)
    

        self.lblCicle.layer.cornerRadius = self.lblCicle.frame.size.height / 2
        self.lblCicle.clipsToBounds = true
        
        self.machineView.layer.cornerRadius = self.machineView.frame.size.height / 2
        self.machineView.clipsToBounds = true
        
        self.btnBell.layer.cornerRadius = self.btnBell.frame.size.height / 2
        self.btnBell.clipsToBounds = true
        
        self.btnMail.layer.cornerRadius = self.btnMail.frame.size.height / 2
        self.btnMail.clipsToBounds = true
        
        self.machineView.layer.cornerRadius = self.machineView.frame.size.height / 2
        self.machineView.clipsToBounds = true
        
        //self.lblPercentageOfMachine.text = "Motor Alarm"
        self.lblPercentageOfMachine.textColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.lblPercentageOfMachine.font = UIFont(name: "Inter-Medium", size: 16)
        
        self.lblMachineTimeheader.text = "Machining Time"
        self.lblMachineTimeheader.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
        self.lblMachineTime.text = AppUtils.getDateForPaymentInfo(paymentDate: obj.last_response)
        self.lblMachineTime.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
    
        self.lblPartMade.text = "Parts Made"
        self.lblPartMade.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblPartMade.textAlignment = .center
        self.lblNopartMade.text = String(obj.parts)
        self.lblNopartMade.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblNopartMade.textAlignment = .center

        
        self.lblFileName.text = "File Name"
        self.lblFileName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblFileName.textAlignment = .center

        self.lblNameOfFile.text = obj.filename
        self.lblNameOfFile.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblNameOfFile.textAlignment = .center

        self.btnReset.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        self.btnReset.layer.cornerRadius = 12
        self.btnReset.clipsToBounds = true
        
        let imgUrl = obj.img.replacingOccurrences(of: "http", with: "https")

        let imgPath = (imgUrl as AnyObject).replacingOccurrences(of: "'\'", with: "").stringByAddingPercentEncodingForRFC3986()
               if(imgPath != nil && imgPath != ""){
                   self.imgProfile.kf.setImage(
                       with: URL(string: imgPath ?? ""),
                       placeholder: UIImage(named: "rechargeGobblyLogo"),
                       options: nil){
                           result in
                           switch result {
                           case .success(_):
                               self.imgProfile.contentMode = .scaleAspectFill;
                               
                           case .failure(_):
                               self.imgProfile.contentMode = .scaleAspectFill;
                           }
                   }
               }
        
        if Device.IS_IPHONE_X
        {
            self.imgWidth.constant = 56
            self.imgHeight.constant = 56
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height / 2
            self.imgProfile.clipsToBounds = true
            self.mHeight.constant = 35
            self.lblMachineTimeheader.font = UIFont(name: "Inter-SemiBold", size: 14)
            self.lblPartMade.font = UIFont(name: "Inter-SemiBold", size: 14)
            self.lblMachineTime.font = UIFont(name: "Inter-Light", size: 12)
            self.lblNopartMade.font = UIFont(name: "Inter-Light", size: 12)
            self.lblFileName.font = UIFont(name: "Inter-SemiBold", size: 14)
            self.lblNameOfFile.font = UIFont(name: "Inter-Light", size: 12)

        }
        else
        {
            self.imgWidth.constant = 120
            self.imgHeight.constant = 120
            self.imgProfile.layer.cornerRadius = 60
            self.imgProfile.clipsToBounds = true
            self.scrlHeight.constant =  150//200
            self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)
            self.mHeight.constant = 60
            
            self.lblMachineTimeheader.font = UIFont(name: "Inter-SemiBold", size: 18)
            self.lblPartMade.font = UIFont(name: "Inter-SemiBold", size: 18)
            self.lblMachineTime.font = UIFont(name: "Inter-Light", size: 16)
            self.lblNopartMade.font = UIFont(name: "Inter-Light", size: 16)
            self.lblFileName.font = UIFont(name: "Inter-SemiBold", size: 18)
            self.lblNameOfFile.font = UIFont(name: "Inter-Light", size: 16)
            
        }
        
//        self.imgInfo.image = self.imgInfo.image?.withRenderingMode(.alwaysTemplate)
//        self.imgInfo.tintColor = UIColor.init(red: 1.0/255.0, green: 133.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }

    
    // MARK: - Call Service ----------
    
    func callServiceForDetails()
    {
        self.viewModel.getControllersListDetails(id: Int(self.serialNumber)!, viewController: self) { errorMessage, msg, list in
            if errorMessage == "Success"
            {
                self.setUPUI(obj: list)
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
    
    func setUpDeviceToggelAlarm()
    {
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 14), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 14), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        
        let attributedString1 = NSMutableAttributedString(string:"Mill 5 Axis" , attributes:attrs1 as [NSAttributedString.Key : Any])
        
        let attributedString2 = NSMutableAttributedString(string:"  Has been stoped".capitalized , attributes:attrs2 as [NSAttributedString.Key : Any])
        
        attributedString1.append(attributedString2)
        
        self.lblAlamName.attributedText = attributedString1
        
        let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 12), NSAttributedString.Key.foregroundColor : UIColor.init(red: 198.0/255.0, green: 149.0/255.0, blue: 24.0/255.0, alpha: 1.0)]
        
        let attributed1 = NSMutableAttributedString(string:"G3-7001 •" , attributes:attrs2 as [NSAttributedString.Key : Any])
        
        let attributed2 = NSMutableAttributedString(string:" 65%".capitalized , attributes:attrs3 as [NSAttributedString.Key : Any])
        
        attributed1.append(attributed2)
        
        self.lblAlramDetails.attributedText = attributed1
        
        self.alarmInnerView.layer.cornerRadius = 20
        self.alarmInnerView.clipsToBounds = true
        
        
        self.btnView.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        self.btnView.layer.cornerRadius = 12
        self.btnView.clipsToBounds = true
        self.btnView.setTitle("View", for: .normal)
        self.btnView.setTitleColor(UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0), for: .normal)
        self.btnView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 159.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        
    }
    
    // MARK: - UIAction Method ----------

    @IBAction func tapBell(_ sender: Any) {
    }
    
    @IBAction func tapView(_ sender: Any) {
    }
    
    @IBAction func tapCLose(_ sender: Any) {
        self.alarmToggelView.isHidden = true

    }
    
    @IBAction func tapMail(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MesageVC") as? MesageVC{
            vc.isFromHome = true
            vc.strSerialNumber = self.serialNumber
            let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
            myAppDelegate.isFromMsg = true
            myAppDelegate.serialNumber = self.serialNumber
            myAppDelegate.strName = self.strName
            myAppDelegate.model = self.model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func tapReset(_ sender: Any) {
        let dict = ["serial" : self.serialNumber]
        self.viewModel.setResetPart(dictDat: dict as NSDictionary, viewController: self) { errorMessage, msg in
            if errorMessage == "Success"
            {
                self.view.makeToast(msg)
                //self.callServiceForDetails()
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
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    @IBAction func taptoggel(_ sender: Any) {
      //  self.alarmToggelView.isHidden = false
        if self.toggelStatus == 0
        {
            self.toggelStatus = 1
        }
        else
        {
            self.toggelStatus = 0
        }
        let dict = ["serial" : self.serialNumber,"alarm" : String(self.toggelStatus)]
        self.viewModel.setAlertState(dictDat: dict as NSDictionary, viewController: self) { errorMessage, msg in
            if errorMessage == "Success"
            {
                //self.view.makeToast(msg)

                if self.toggelStatus == 1
                {
                    self.otherView.isHidden = false
                }
                else
                {
                    self.otherView.isHidden = true
                }
                if self.toggelStatus == 1
                {
                    self.imgBell.image = UIImage(named: "bell")
                }
                else
                {
                    self.imgBell.image = UIImage(named: "sBell")
                }
                
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
    
    @IBAction func tapOK(_ sender: Any) {
        self.otherView.isHidden = true
    }
    
    func setUpProAlert()
    {
        self.otherView.layer.cornerRadius = 20
        self.otherView.clipsToBounds = true
        
        let strOne = "You will get an Alarm Notification," + "\n" + "while app is not active"
    
        self.lblOtherDetails.text = strOne
        self.lblOtherDetails.font = UIFont(name: "Inter-Medium", size: 12)
        self.lblOtherDetails.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
        
        self.btnOK.layer.cornerRadius = 12
        self.btnOK.setTitle("OK", for: .normal)
        self.btnOK.backgroundColor = UIColor.init(red: 255.0/255.0, green: 159.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        self.btnOK.setTitleColor(UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0), for: .normal)
        self.btnOK.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 14)

    }
    
}

