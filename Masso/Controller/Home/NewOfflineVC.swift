//
//  NewOfflineVC.swift
//  Masso
//
//  Created by Sunil on 30/03/23.
//

import UIKit

class NewOfflineVC: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblRunningBy: UILabel!
    @IBOutlet weak var viewCircleChart: CircularProgressBarView!
    var circularViewDuration: TimeInterval = 2
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblMachineSataus: UILabel!
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
    @IBOutlet weak var btnMail: UIButton!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var lblOtherDetails: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var imgBell: UIImageView!
    @IBOutlet weak var toggleView: UIView!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var lblOperatorName: UILabel!
    var serialNumber : String = ""
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    var viewModel = HomeViewModel()
    
    // MARK: - View Life Cycle ----------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBottomBar()
        self.setUpProAlert()
        self.toggleView.layer.cornerRadius = self.toggleView.frame.size.height / 2
        self.toggleView.clipsToBounds = true
        
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
    
    func setUpProAlert()
    {
        self.otherView.layer.cornerRadius = 20
        self.otherView.clipsToBounds = true
        
        let strOne = "To get the "
        let strTwo = "Live Controller view," + "\n"
        let strThree = "please subscribe to  "
        let strFour = "PRO"
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 12), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 13), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 13), NSAttributedString.Key.foregroundColor : UIColor.init(red: 255.0/255.0, green: 159.0/255.0, blue: 41.0/255.0, alpha: 1.0)]
        
        
        let attributedString1 = NSMutableAttributedString(string:strOne , attributes:attrs1 as [NSAttributedString.Key : Any])
        
        let attributedString2 = NSMutableAttributedString(string:strTwo , attributes:attrs2 as [NSAttributedString.Key : Any])
        
        let attributedString3 = NSMutableAttributedString(string:strThree , attributes:attrs1 as [NSAttributedString.Key : Any])
        
        let attributedString4 = NSMutableAttributedString(string:strFour , attributes:attrs3 as [NSAttributedString.Key : Any])
        
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        attributedString1.append(attributedString4)
    
        self.lblOtherDetails.textColor = UIColor.init(red: 255.0/255.0, green: 159.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        self.lblOtherDetails.font = UIFont(name: "Inter-SemiBold", size: 13)
        self.lblOtherDetails.text = "Get a myWorkshop PRO subscription for this controller to view the live data view in real time"
        
      
        
        self.btnOK.layer.cornerRadius = 12
        self.btnOK.setTitle("OK", for: .normal)
        self.btnOK.backgroundColor = UIColor.init(red: 255.0/255.0, green: 159.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        self.btnOK.setTitleColor(UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0), for: .normal)
        self.btnOK.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 14)

    }
    
    func setUPUI(obj : controllersList)
    {
        
        self.mainView.layer.cornerRadius = 8
        self.mainView.clipsToBounds = true
        
        
        if Device.IS_IPHONE_X
        {
            self.imgWidth.constant = 56
            self.imgHeight.constant = 56
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height / 2
            self.imgProfile.clipsToBounds = true
        }
        else
        {
            self.imgWidth.constant = 120
            self.imgHeight.constant = 120
            self.imgProfile.layer.cornerRadius = 60
            self.imgProfile.clipsToBounds = true
        }
        
        self.lblName.text = obj.name
        self.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblName.font =  UIFont(name: "Inter-SemiBold", size: 16)

        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 24), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 16), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        
        let attributedString1 = NSMutableAttributedString(string:obj.name , attributes:attrs1 as [NSAttributedString.Key : Any])
        
        let attributedString2 = NSMutableAttributedString(string:"  " + obj.model.capitalized , attributes:attrs2 as [NSAttributedString.Key : Any])
        
        attributedString1.append(attributedString2)
        
        self.lblDeviceName.font = UIFont(name: "Inter-SemiBold", size: 20)
        self.lblDeviceName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblDeviceName.text = obj.name
        
        self.lblRunningBy.font = UIFont(name: "Inter-Light", size: 16)
        self.lblRunningBy.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblRunningBy.text = obj.model.capitalized + "-" +  obj.serial
        
        self.lblOperatorName.font = UIFont(name: "Inter-Bold", size: 18)
        self.lblOperatorName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblOperatorName.text = obj.operatorName
        
        self.lblOtherDetails.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblOtherDetails.font = UIFont(name: "Inter-SemiBold", size: 13)
        self.lblOtherDetails.text = "Get a myWorkshop PRO subscription for this controller to view the live data view in real time"
        
        
        let attrs11 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 16), NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let attrs22 = [NSAttributedString.Key.font : UIFont(name: "Inter-light", size: 16), NSAttributedString.Key.foregroundColor : UIColor.init(red: 122.0/255.0, green: 144.0/255.0, blue: 156.0/255.0, alpha: 1.0)]
        
        
        let attributedString11 = NSMutableAttributedString(string:"Running by:" , attributes:attrs22 as [NSAttributedString.Key : Any])
        
        let attributedString21 = NSMutableAttributedString(string:" " + obj.operatorName.capitalized , attributes:attrs11 as [NSAttributedString.Key : Any])
        
        attributedString11.append(attributedString21)
        self.lblPercent.text = "0%"
        self.lblPercent.textColor = UIColor.init(red: 11.0/255.0, green: 160.0/255.0, blue: 107.0/255.0, alpha: 0.3)
        self.lblPercent.font = UIFont(name: "Inter-Bold", size: 30)
        
        self.lblMachineSataus.text = "GOOD"
        self.lblMachineSataus.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblMachineSataus.font = UIFont(name: "Inter-Regular", size: 12)
    
        self.viewCircleChart.progressAnimation(duration: circularViewDuration,toValue: 0.0,from: "Machine",fromValue: 0.0)
        
        
        self.lblTextMachine.text = "Unsubscribed"
        self.lblTextMachine.textColor = UIColor.init(red: 11.0/255.0, green: 160.0/255.0, blue: 107.0/255.0, alpha: 0.3)
        self.lblTextMachine.font = UIFont(name: "Inter-Regular", size: 16)
    

        self.lblCicle.layer.cornerRadius = self.lblCicle.frame.size.height / 2
        self.lblCicle.clipsToBounds = true
        self.lblCicle.backgroundColor = UIColor.init(red: 11.0/255.0, green: 160.0/255.0, blue: 107.0/255.0, alpha: 0.3)
        
        self.machineView.layer.cornerRadius = self.machineView.frame.size.height / 2
        self.machineView.clipsToBounds = true
        
        self.btnBell.layer.cornerRadius = self.btnBell.frame.size.height / 2
        self.btnBell.clipsToBounds = true
        
        let origImage = UIImage(named: "bell")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        self.btnBell.setImage(tintedImage, for: .normal)
        self.btnBell.tintColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.3)
        
        
        
        self.btnMail.layer.cornerRadius = self.btnMail.frame.size.height / 2
        self.btnMail.clipsToBounds = true
        
        let origImageB = UIImage(named: "mail")
        let tintedImageB = origImageB?.withRenderingMode(.alwaysTemplate)
        self.btnMail.setImage(tintedImageB, for: .normal)
        self.btnMail.tintColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.3)
        
        
        self.imgBell.image = self.imgBell.image?.withRenderingMode(.alwaysTemplate)
        self.imgBell.tintColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.3)
        
        self.machineView.layer.cornerRadius = self.machineView.frame.size.height / 2
        self.machineView.clipsToBounds = true
        
        self.lblPercentageOfMachine.text = "12 hr"
        self.lblPercentageOfMachine.textColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.3)
        self.lblPercentageOfMachine.font = UIFont(name: "Inter-Medium", size: 16)
        
        self.lblMachineTimeheader.text = "Machining Time"
        self.lblMachineTimeheader.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.3)
        self.lblMachineTimeheader.font = UIFont(name: "Inter-SemiBold", size: 14)
        
        self.lblMachineTime.text = "xxxxx xxxx "
        self.lblMachineTime.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.3)
        self.lblMachineTime.font = UIFont(name: "Inter-Light", size: 12)
        self.lblMachineTime.textAlignment = .center
        
        self.lblPartMade.text = "Parts Made"
        self.lblPartMade.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.3)
        self.lblPartMade.font = UIFont(name: "Inter-SemiBold", size: 14)
        
        self.lblNopartMade.text = "xxxxxx"
        self.lblNopartMade.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.3)
        self.lblNopartMade.font = UIFont(name: "Inter-Light", size: 12)
        self.lblNopartMade.textAlignment = .center

        
        self.lblFileName.text = "File Name"
        self.lblFileName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.3)
        self.lblFileName.font = UIFont(name: "Inter-SemiBold", size: 14)
        
        self.lblNameOfFile.text = "xxxxxx"
        self.lblNameOfFile.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.3)
        self.lblNameOfFile.font = UIFont(name: "Inter-Light", size: 12)
        self.lblNameOfFile.textAlignment = .center

        self.btnReset.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        self.btnReset.layer.cornerRadius = 12
        self.btnReset.clipsToBounds = true
        
        let imgPath = (obj.img as AnyObject).replacingOccurrences(of: "'\'", with: "").stringByAddingPercentEncodingForRFC3986()
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

    // MARK: - UIAction Method ----------

    @IBAction func tapBell(_ sender: Any) {
    }
    
    @IBAction func tapMail(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MesageVC") as? MesageVC{
            vc.isFromHome = true
            vc.strSerialNumber = self.serialNumber
            let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
            myAppDelegate.isFromMsg = true
            myAppDelegate.serialNumber = self.serialNumber
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func tapReset(_ sender: Any) {
    }
    
    @IBAction func tapOk(_ sender: Any) {
        self.otherView.isHidden = true
    }
    
    @IBAction func tapToggel(_ sender: Any) {
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
