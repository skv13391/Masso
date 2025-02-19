//
//  DetailsVC.swift
//  Masso
//
//  Created by Sunil on 28/03/23.
//

import UIKit

class DetailsVC: UIViewController {

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
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var scrlHeight: NSLayoutConstraint!
    @IBOutlet weak var toggelView: UIView!
    @IBOutlet weak var btnToggel: UIButton!
    @IBOutlet weak var lblOperatorName: UILabel!
    @IBOutlet weak var imgBell: UIImageView!
    @IBOutlet weak var machineHeight: NSLayoutConstraint!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var mHeight: NSLayoutConstraint!
    @IBOutlet weak var lblStateNameWidth: NSLayoutConstraint!
    @IBOutlet weak var viewAlarm: UIView!
    @IBOutlet weak var lblAlram: UILabel!
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var btnMail: UIButton!
    var serialNumber : String = ""
    var model = String()
    var viewModel = HomeViewModel()
    var toggelStatus : Int = 0
    var strName = String()
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var lblOtherDetails: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    var globalcontrollersList = controllersList()
    var fromValue : CGFloat = 0.0
    var updateProgress : Int = 0
    
    
    
    // MARK: - View Life Cycle ----------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.myAppDelegate.presentViewCr = "true"
        
        
        self.showBottomBar()
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

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        let dict = notification.object as? NSDictionary
        let arrayList = dict!.object(forKey: "data") as? NSArray
        
        for i in 0...(arrayList!.count - 1) {
            let updatedDict = arrayList![i] as? NSDictionary
            let serial = updatedDict!.object(forKey: "serial") as? Int
            if self.serialNumber == String(serial!)
            {
                let machineNAme = updatedDict!.object(forKey: "machine_name") as? String
                print(machineNAme)
                let serial = updatedDict!.object(forKey: "serial") as? String
                let state = updatedDict!.object(forKey: "state") as? Int
                let operatorName = updatedDict!.object(forKey: "operator_name") as? String
                let alarmType = updatedDict!.object(forKey: "alarm_type") as? Int
                let filename = updatedDict!.object(forKey: "filename") as? String
                let last_response = updatedDict!.object(forKey: "last_response") as? String
                let mName = updatedDict!.object(forKey: "machine_name") as? String
                let parts = updatedDict!.object(forKey: "parts") as? Int
                let progress = updatedDict!.object(forKey: "progress") as? Double
                let alarmSub = updatedDict!.object(forKey: "alarm_sub") as? Int

                
                self.globalcontrollersList.name = mName!
                self.globalcontrollersList.state = String(state!)
                self.globalcontrollersList.operatorName = operatorName!
                self.globalcontrollersList.progress = String(progress!)
                self.globalcontrollersList.alarm_type = alarmType!
                self.globalcontrollersList.last_response = last_response!
                self.globalcontrollersList.parts = parts!
                self.globalcontrollersList.filename = filename!
                self.globalcontrollersList.alarm_sub = alarmSub!
                
                DispatchQueue.main.async {
                    if self.globalcontrollersList.state == "2"
                    {
                        self.setUPUIForMachine(obj: self.globalcontrollersList)
                    }
                    else if self.globalcontrollersList.state == "1"
                    {
                        self.setUPUIForIdle(obj: self.globalcontrollersList)
                    }
                    else if self.globalcontrollersList.state == "4"
                    {
                        self.setUPUIAlarm(obj: self.globalcontrollersList)
                    }
                    else if self.globalcontrollersList.state == "3"
                    {
                        self.setUPUIOffline(obj: self.globalcontrollersList)
                    }
                    else
                    {
                        self.setUPUIUnsubscribe(obj: self.globalcontrollersList)
                    }
                }
            }
        }
        
        
        
    }
    
    func setUPUIForMachine(obj : controllersList)
    {
        self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 0)

        self.btnReset.isHidden = false
        self.btnToggel.isUserInteractionEnabled = true
        self.btnReset.backgroundColor = UIColor.init(red: 248.0/255.0, green: 173.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        self.btnReset.isUserInteractionEnabled = true
        self.myAppDelegate.progressFrom = "Machine"
        self.viewAlarm.isHidden = true
        self.model = obj.model
        if self.toggelStatus == 1
        { 
            self.imgBell.image = UIImage(named: "bell")
        }
        else
        {
            self.imgBell.image = UIImage(named: "sBell")
        }
        
        
        self.mainView.layer.cornerRadius = 8
        self.mainView.clipsToBounds = true
        
        self.lblCicle.backgroundColor = UIColor.init(red: 11.0/255.0, green: 169.0/255.0, blue: 107.0/255.0, alpha: 1.0)
        self.lblTextMachine.textColor = UIColor.init(red: 11.0/255.0, green: 169.0/255.0, blue: 107.0/255.0, alpha: 1.0)
        self.machineView.backgroundColor = UIColor.init(red: 11.0/255.0, green: 169.0/255.0, blue: 107.0/255.0, alpha: 0.16)
        
        
        self.lblStateNameWidth.constant = 112
        
        self.lblName.text = obj.name
        self.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblName.font =  UIFont(name: "Inter-SemiBold", size: 16)
        self.strName = obj.name
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 24), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 16), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        
        let attributedString1 = NSMutableAttributedString(string:obj.name , attributes:attrs1 as [NSAttributedString.Key : Any])
        
        let attributedString2 = NSMutableAttributedString(string:"  " + obj.model.capitalized + "-" +  obj.serial.capitalized, attributes:attrs2 as [NSAttributedString.Key : Any])
        
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
        
        
        let heightCalu = obj.name.heightWithConstrainedWidth(width: CGFloat(332), font: UIFont(name: "Inter-SemiBold", size: 24)!)
        
        if heightCalu > 30
        {
            machineHeight.constant = 60
        }
        else
        {
            machineHeight.constant = 35
        }
        
        let attrs11 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 16), NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let attrs22 = [NSAttributedString.Key.font : UIFont(name: "Inter-light", size: 16), NSAttributedString.Key.foregroundColor : UIColor.init(red: 122.0/255.0, green: 144.0/255.0, blue: 156.0/255.0, alpha: 1.0)]
        
        
        let attributedString11 = NSMutableAttributedString(string:"Running by:" , attributes:attrs22 as [NSAttributedString.Key : Any])
        
        let attributedString21 = NSMutableAttributedString(string:" " + obj.operatorName.capitalized , attributes:attrs11 as [NSAttributedString.Key : Any])
        
        attributedString11.append(attributedString21)
      
        
        let last2 = String(obj.progress.suffix(2))
        if last2 == "00" || last2 == ".0"
        {
            if obj.progress == "0.00" || obj.progress == "0.0" || obj.progress == "0"
            {
                self.lblPercent.text = "0%"
            }
            else
            {
                let first2 = Int(Double(obj.progress)!)
                self.lblPercent.text = String(first2) + "%"
            }
        }
        else
        {
            self.lblPercent.text = obj.progress + "%"
        }
            
         
        self.lblPercent.textColor = UIColor.init(red: 11.0/255.0, green: 169.0/255.0, blue: 107.0/255.0, alpha: 1.0)
        self.lblPercent.font = UIFont(name: "Inter-Bold", size: 30)
        
        self.lblMachineSataus.text = "GOOD"
        self.lblMachineSataus.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblMachineSataus.font = UIFont(name: "Inter-Regular", size: 12)
        var progressValue = 0.0
        
        
        
        
        if obj.progress.toDouble()! >= 80.0 && obj.progress.toDouble()! < 85.0
        {
            progressValue = 0.80
        }
        else if obj.progress.toDouble()! >= 85 && obj.progress.toDouble()! < 90.0
        {
            progressValue = 0.85
        }
        else if obj.progress.toDouble()! >= 90.0 && obj.progress.toDouble()! < 95.0
        {
            progressValue = 0.88
        }
        else if obj.progress.toDouble()! == 95.0
        {
            progressValue = 0.90
        }
        else if obj.progress.toDouble()! == 96.0
        {
            progressValue = 0.92
        }
        else if obj.progress.toDouble()! == 97.0
        {
            progressValue = 0.93
        }
        else if obj.progress.toDouble()! == 98.0
        {
            progressValue = 0.94
        }
        else if obj.progress.toDouble()! == 99.0
        {
            progressValue = 0.95
        }
        else if obj.progress.toDouble()! == 100.0
        {
            progressValue = 0.96
        }
        else
        {
            progressValue = Double((obj.progress).toDouble()! / 100)
        }
       
       
        print(self.updateProgress)
        
        if self.updateProgress == 0
        {
            self.updateProgress = self.updateProgress + 1
            self.viewCircleChart.progressAnimation(duration: circularViewDuration,toValue: progressValue,from: "Machine",fromValue: 0.0)
            self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 230)
            self.fromValue = progressValue
        }
        else
        {
            self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 0)
            self.updateProgress = self.updateProgress + 1
            self.viewCircleChart.progressAnimation(duration: 0.0,toValue: progressValue,from: "Machine",fromValue: self.fromValue)
            self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 230)
            self.fromValue = progressValue
        }
       
       
        
        self.lblTextMachine.text = "Machining"
        self.lblTextMachine.textColor = UIColor.init(red: 11.0/255.0, green: 169.0/255.0, blue: 107.0/255.0, alpha: 1.0)
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
        
        
        
        self.lblPercentageOfMachine.text = obj.progress + "%"
        self.lblPercentageOfMachine.textColor = UIColor.init(red: 11.0/255.0, green: 169.0/255.0, blue: 107.0/255.0, alpha: 1.0)
        self.lblPercentageOfMachine.font = UIFont(name: "Inter-Medium", size: 16)
        
        self.lblMachineTimeheader.text = "Machining Time"
        self.lblMachineTimeheader.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
        self.lblMachineTime.text = obj.last_response//AppUtils.getDateForPaymentInfo(paymentDate: obj.last_response)
        self.lblMachineTime.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
    
        self.lblPartMade.text = "Parts Made"
        self.lblPartMade.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
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
        
        
        self.toggelView.layer.cornerRadius = self.toggelView.frame.size.height / 2
        self.toggelView.clipsToBounds = true
        
        let imgUrl = obj.img//.replacingOccurrences(of: "http", with: "https")

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
        
       
    }

    func setUPUIForIdle(obj : controllersList)
    {
        //self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 0)
        self.btnReset.isHidden = false
        self.btnToggel.isUserInteractionEnabled = true
        self.myAppDelegate.progressFrom = "Idle"
        self.btnReset.backgroundColor = UIColor.init(red: 248.0/255.0, green: 173.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        self.btnReset.isUserInteractionEnabled = true
        self.viewAlarm.isHidden = true
        self.model = obj.model
        self.imgBell.image = self.imgBell.image?.withRenderingMode(.alwaysTemplate)
        self.imgBell.tintColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
        self.viewAlarm.isHidden = true
        
        self.toggelView.layer.cornerRadius = self.toggelView.frame.size.height / 2
        self.toggelView.clipsToBounds = true
        
        if self.toggelStatus == 1
        {
            self.imgBell.image = UIImage(named: "bell")
        }
        else
        {
            self.imgBell.image = UIImage(named: "sBell")
        }
        
       
        let heightCalu = obj.name.heightWithConstrainedWidth(width: CGFloat(332), font: UIFont(name: "Inter-SemiBold", size: 24)!)
        
        if heightCalu > 30
        {
            machineHeight.constant = 60
        }
        else
        {
            machineHeight.constant = 35
        }
        
        self.mainView.layer.cornerRadius = 8
        self.mainView.clipsToBounds = true
        
        self.lblCicle.backgroundColor = UIColor.init(red: 248.0/255.0, green: 173.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        self.lblTextMachine.textColor = UIColor.init(red: 248.0/255.0, green: 173.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        self.machineView.backgroundColor = UIColor.init(red: 248.0/255.0, green: 173.0/255.0, blue: 61.0/255.0, alpha: 0.16)
        self.lblStateNameWidth.constant = 60
        
        
        self.lblName.text = obj.name
        self.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblName.font =  UIFont(name: "Inter-SemiBold", size: 16)

        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 24), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 16), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        
        let attributedString1 = NSMutableAttributedString(string:obj.name , attributes:attrs1 as [NSAttributedString.Key : Any])
        
        let attributedString2 = NSMutableAttributedString(string:"  " + obj.model + "-" +  obj.serial.capitalized, attributes:attrs2 as [NSAttributedString.Key : Any])
        
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
        
        
        self.lblPercentageOfMachine.text = obj.last_response
        
        
       
        let last2 = String(obj.progress.suffix(2))
        if last2 == "00" || last2 == ".0"
        {
            if obj.progress == "0.00" || obj.progress == "0.0" || obj.progress == "0"
            {
                self.lblPercent.text = "0%"
            }
            else
            {
                let first2 = Int(Double(obj.progress)!)
                self.lblPercent.text = String(first2) + "%"
            }
        }
        else
        {
            self.lblPercent.text = obj.progress + "%"
        }
        var progressValue = 0.0
        progressValue = Double((obj.progress).toDouble()! / 100)
        if obj.progress.toDouble()! >= 80.0 && obj.progress.toDouble()! < 85.0
        {
            progressValue = 0.80
        }
        else if obj.progress.toDouble()! >= 85 && obj.progress.toDouble()! < 90.0
        {
            progressValue = 0.85
        }
        else if obj.progress.toDouble()! >= 90.0 && obj.progress.toDouble()! < 95.0
        {
            progressValue = 0.88
        }
        else if obj.progress.toDouble()! == 95.0
        {
            progressValue = 0.90
        }
        else if obj.progress.toDouble()! == 96.0
        {
            progressValue = 0.92
        }
        else if obj.progress.toDouble()! == 97.0
        {
            progressValue = 0.93
        }
        else if obj.progress.toDouble()! == 98.0
        {
            progressValue = 0.94
        }
        else if obj.progress.toDouble()! == 99.0
        {
            progressValue = 0.95
        }
        else if obj.progress.toDouble()! == 100.0
        {
            progressValue = 0.96
        }
        else
        {
            progressValue = Double((obj.progress).toDouble()! / 100)
        }
        print(self.updateProgress)
        
        if self.updateProgress == 0
        {
            self.updateProgress = self.updateProgress + 1
            self.viewCircleChart.progressAnimation(duration: circularViewDuration,toValue: progressValue,from: "Machine",fromValue: 0.0)
            self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 230)
            self.fromValue = progressValue
        }
        else
        {
            self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 0)
            self.updateProgress = self.updateProgress + 1
            self.viewCircleChart.progressAnimation(duration: 0.0,toValue: progressValue,from: "Machine",fromValue: self.fromValue)
            self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 230)
            self.fromValue = progressValue
        }
       
       
        
        self.lblPercent.textColor = UIColor.init(red: 248.0/255.0, green: 173.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        self.lblPercent.font = UIFont(name: "Inter-Bold", size: 30)
        
        self.lblMachineSataus.text = "GOOD"
        self.lblMachineSataus.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblMachineSataus.font = UIFont(name: "Inter-Regular", size: 12)
    
        //self.viewCircleChart.progressAnimation(duration: circularViewDuration,toValue: 0.0,from: "Machine",fromValue: 0.0)
        
        
        self.lblTextMachine.text = "Idle"
        self.lblTextMachine.textColor = UIColor.init(red: 248.0/255.0, green: 173.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        self.lblTextMachine.font = UIFont(name: "Inter-Regular", size: 16)
    

        self.lblCicle.layer.cornerRadius = self.lblCicle.frame.size.height / 2
        self.lblCicle.clipsToBounds = true
        
        self.machineView.layer.cornerRadius = self.machineView.frame.size.height / 2
        self.machineView.clipsToBounds = true
        
        self.btnBell.layer.cornerRadius = self.btnBell.frame.size.height / 2
        self.btnBell.clipsToBounds = true
                
        self.btnMail.layer.cornerRadius = self.btnMail.frame.size.height / 2
        self.btnMail.clipsToBounds = true
        
        let origImageB = UIImage(named: "mail")
        let tintedImageB = origImageB?.withRenderingMode(.alwaysTemplate)
        self.btnMail.setImage(tintedImageB, for: .normal)
        self.btnMail.tintColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7)
        
        
        
        self.machineView.layer.cornerRadius = self.machineView.frame.size.height / 2
        self.machineView.clipsToBounds = true
        
        self.lblPercentageOfMachine.textColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.lblPercentageOfMachine.font = UIFont(name: "Inter-Medium", size: 16)
        
        self.lblMachineTimeheader.text = "Machining Time"
        self.lblMachineTimeheader.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblMachineTimeheader.font = UIFont(name: "Inter-SemiBold", size: 14)
        
        self.lblMachineTime.text = obj.last_response//AppUtils.getDateForPaymentInfo(paymentDate: obj.last_response)
        self.lblMachineTime.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblMachineTime.font = UIFont(name: "Inter-Light", size: 12)
    
        self.lblPartMade.text = "Parts Made"
        self.lblPartMade.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblPartMade.font = UIFont(name: "Inter-SemiBold", size: 14)
        
        self.lblNopartMade.text = String(obj.parts)
        self.lblNopartMade.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblNopartMade.font = UIFont(name: "Inter-Light", size: 12)
        
        
        self.lblFileName.text = "File Name"
        self.lblFileName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblFileName.font = UIFont(name: "Inter-SemiBold", size: 14)
        
        self.lblNameOfFile.text = obj.filename
        self.lblNameOfFile.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblNameOfFile.font = UIFont(name: "Inter-Light", size: 12)
        
        self.btnReset.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        self.btnReset.layer.cornerRadius = 12
        self.btnReset.clipsToBounds = true
        
        let imgUrl = obj.img//.replacingOccurrences(of: "http", with: "https")

        
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
            self.mHeight.constant = 35
            self.imgWidth.constant = 56
            self.imgHeight.constant = 56
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height / 2
            self.imgProfile.clipsToBounds = true
            self.lblMachineTimeheader.font = UIFont(name: "Inter-SemiBold", size: 14)
            self.lblPartMade.font = UIFont(name: "Inter-SemiBold", size: 14)
            self.lblMachineTime.font = UIFont(name: "Inter-Light", size: 12)
            self.lblNopartMade.font = UIFont(name: "Inter-Light", size: 12)
            self.lblFileName.font = UIFont(name: "Inter-SemiBold", size: 14)
            self.lblNameOfFile.font = UIFont(name: "Inter-Light", size: 12)

        }
        else
        {
            self.mHeight.constant = 60
            self.imgWidth.constant = 120
            self.imgHeight.constant = 120
            self.imgProfile.layer.cornerRadius = 60
            self.imgProfile.clipsToBounds = true
            self.scrlHeight.constant =  150//200
            self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)
            
            self.lblMachineTimeheader.font = UIFont(name: "Inter-SemiBold", size: 18)
            self.lblPartMade.font = UIFont(name: "Inter-SemiBold", size: 18)
            self.lblMachineTime.font = UIFont(name: "Inter-Light", size: 16)
            self.lblNopartMade.font = UIFont(name: "Inter-Light", size: 16)
            self.lblFileName.font = UIFont(name: "Inter-SemiBold", size: 18)
            self.lblNameOfFile.font = UIFont(name: "Inter-Light", size: 16)
            
        }
        
    }
    
    func setUPUIAlarm(obj : controllersList)
    {
        self.lblPercent.text = ""
        self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 0)
        self.btnReset.isHidden = false
        self.btnToggel.isUserInteractionEnabled = true
        self.myAppDelegate.progressFrom = "Alarm"
        self.btnReset.backgroundColor = UIColor.init(red: 248.0/255.0, green: 173.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        self.btnReset.isUserInteractionEnabled = true
        self.viewAlarm.isHidden = false
        self.model = obj.model

        if self.toggelStatus == 1
        {
            self.imgBell.image = UIImage(named: "bell")
        }
        else
        {
            self.imgBell.image = UIImage(named: "sBell")
        }
        
        let heightCalu = obj.name.heightWithConstrainedWidth(width: CGFloat(332), font: UIFont(name: "Inter-SemiBold", size: 24)!)
        
        if heightCalu > 30
        {
            machineHeight.constant = 60
        }
        else
        {
            machineHeight.constant = 35
        }
        print(obj.alarm_type)
        print(AppUtils.getAlertTypeMessage(valueAlert: obj.alarm_type))
        self.lblAlram.text = AppUtils.getAlertTypeMessage(valueAlert: obj.alarm_type)
        self.lblAlram.textColor = UIColor.init(red: 249.0/255.0, green: 54.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        
        self.lblCicle.backgroundColor = UIColor.init(red: 249.0/255.0, green: 54.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        self.lblTextMachine.textColor = UIColor.init(red: 249.0/255.0, green: 54.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        self.machineView.backgroundColor = UIColor.init(red: 249.0/255.0, green: 54.0/255.0, blue: 13.0/255.0, alpha: 0.16)
        self.lblStateNameWidth.constant = 80
        
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
        
       
        self.lblPercentageOfMachine.text = AppUtils.getAlertTypeMessage(valueAlert: obj.alarm_type)

        
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
        var progressValue = 0.0
        if obj.progress.toDouble()! >= 80.0 && obj.progress.toDouble()! < 85.0
        {
            progressValue = 0.80
        }
        else if obj.progress.toDouble()! >= 85 && obj.progress.toDouble()! < 90.0
        {
            progressValue = 0.85
        }
        else if obj.progress.toDouble()! >= 90.0 && obj.progress.toDouble()! < 95.0
        {
            progressValue = 0.88
        }
        else if obj.progress.toDouble()! == 95.0
        {
            progressValue = 0.90
        }
        else if obj.progress.toDouble()! == 96.0
        {
            progressValue = 0.92
        }
        else if obj.progress.toDouble()! == 97.0
        {
            progressValue = 0.93
        }
        else if obj.progress.toDouble()! == 98.0
        {
            progressValue = 0.94
        }
        else if obj.progress.toDouble()! == 99.0
        {
            progressValue = 0.95
        }
        else if obj.progress.toDouble()! == 100.0
        {
            progressValue = 0.96
        }
        else
        {
            progressValue = Double((obj.progress).toDouble()! / 100)
        }
        progressValue = Double((obj.progress).toDouble()! / 100)

        print(self.updateProgress)
        
        if self.updateProgress == 0
        {
            self.updateProgress = self.updateProgress + 1
            self.viewCircleChart.progressAnimation(duration: circularViewDuration,toValue: progressValue,from: "Machine",fromValue: 0.0)
            self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 230)
            self.fromValue = progressValue
        }
        else
        {
            self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 0)
            self.updateProgress = self.updateProgress + 1
            self.viewCircleChart.progressAnimation(duration: 0.0,toValue: progressValue,from: "Machine",fromValue: self.fromValue)
            self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 230)
            self.fromValue = progressValue
        }

        
        self.lblTextMachine.text = "Alarm"
        self.lblTextMachine.textColor = UIColor.init(red: 249.0/255.0, green: 54.0/255.0, blue: 13.0/255.0, alpha: 1.0)
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
        
        self.lblMachineTime.text =  obj.last_response//AppUtils.getDateForPaymentInfo(paymentDate: obj.last_response)
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
        
        let imgUrl = obj.img//.replacingOccurrences(of: "http", with: "https")

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
        
        self.toggelView.layer.cornerRadius = self.toggelView.frame.size.height / 2
        self.toggelView.clipsToBounds = true
        
    }
    
    func setUPUIOffline(obj : controllersList)
    {
        self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 0)

        self.myAppDelegate.progressFrom = "Machine"
        self.btnReset.isHidden = false
        self.btnToggel.isUserInteractionEnabled = true
        self.viewAlarm.isHidden = true
       
        self.mainView.layer.cornerRadius = 8
        self.mainView.clipsToBounds = true
        
        if self.toggelStatus == 1
        {
            self.imgBell.image = UIImage(named: "bell")
        }
        else
        {
            self.imgBell.image = UIImage(named: "sBell")
        }
        
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
        
        let heightCalu = obj.name.heightWithConstrainedWidth(width: CGFloat(332), font: UIFont(name: "Inter-SemiBold", size: 24)!)
        
        if heightCalu > 30
        {
            machineHeight.constant = 60
        }
        else
        {
            machineHeight.constant = 35
        }
       
        
        self.btnReset.backgroundColor = UIColor.init(red: 181.0/255.0, green: 172.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        self.btnReset.isUserInteractionEnabled = false
        
        self.lblCicle.backgroundColor = UIColor.init(red: 149.0/255.0, green: 149.0/255.0, blue: 149.0/255.0, alpha: 1.0)
        self.lblTextMachine.textColor = UIColor.init(red: 149.0/255.0, green: 149.0/255.0, blue: 149.0/255.0, alpha: 1.0)
        self.machineView.backgroundColor = UIColor.init(red: 149.0/255.0, green:149.0/255.0, blue: 149.0/255.0, alpha: 0.16)
        self.lblStateNameWidth.constant = 90
        
        self.imgBell.image = self.imgBell.image?.withRenderingMode(.alwaysTemplate)
        self.imgBell.tintColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
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
        
        self.lblRunningBy.font = UIFont(name: "Inter-Light", size: 16)
        self.lblRunningBy.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblRunningBy.text = obj.model.capitalized + "-" +  obj.serial
        
        self.lblOperatorName.font = UIFont(name: "Inter-Bold", size: 18)
        self.lblOperatorName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblOperatorName.text = obj.operatorName
        
        
        let attrs11 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 16), NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let attrs22 = [NSAttributedString.Key.font : UIFont(name: "Inter-light", size: 16), NSAttributedString.Key.foregroundColor : UIColor.init(red: 122.0/255.0, green: 144.0/255.0, blue: 156.0/255.0, alpha: 1.0)]
        
        
        let attributedString11 = NSMutableAttributedString(string:"Running by:" , attributes:attrs22 as [NSAttributedString.Key : Any])
        
        let attributedString21 = NSMutableAttributedString(string:" "+obj.operatorName.capitalized , attributes:attrs11 as [NSAttributedString.Key : Any])
        
        attributedString11.append(attributedString21)
       
        self.lblPercent.text = ""
        self.lblPercent.textColor = UIColor.init(red: 149.0/255.0, green: 149.0/255.0, blue: 149.0/255.0, alpha: 1.0)
        self.lblPercent.font = UIFont(name: "Inter-Bold", size: 30)
        
        self.lblMachineSataus.text = "GOOD"
        self.lblMachineSataus.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblMachineSataus.font = UIFont(name: "Inter-Regular", size: 12)
    
        self.viewCircleChart.progressAnimation(duration: circularViewDuration,toValue: 0.0,from: "Machine",fromValue: 0.0)
        
        
        self.lblTextMachine.text = "Offline"
        self.lblTextMachine.textColor = UIColor.init(red: 149.0/255.0, green: 149.0/255.0, blue: 149.0/255.0, alpha: 1.0)
        self.lblTextMachine.font = UIFont(name: "Inter-Regular", size: 16)
    

        self.lblCicle.layer.cornerRadius = self.lblCicle.frame.size.height / 2
        self.lblCicle.clipsToBounds = true
        
        self.machineView.layer.cornerRadius = self.machineView.frame.size.height / 2
        self.machineView.clipsToBounds = true
        
        self.btnBell.layer.cornerRadius = self.btnBell.frame.size.height / 2
        self.btnBell.clipsToBounds = true
        
        
        self.btnMail.layer.cornerRadius = self.btnMail.frame.size.height / 2
        self.btnMail.clipsToBounds = true
        
        let origImageB = UIImage(named: "mail")
        let tintedImageB = origImageB?.withRenderingMode(.alwaysTemplate)
        self.btnMail.setImage(tintedImageB, for: .normal)
        self.btnMail.tintColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.7)
        
        
        
        self.machineView.layer.cornerRadius = self.machineView.frame.size.height / 2
        self.machineView.clipsToBounds = true
        
        self.toggelView.layer.cornerRadius = self.toggelView.frame.size.height / 2
        self.toggelView.clipsToBounds = true
        
        let imgUrl = obj.img//.replacingOccurrences(of: "http", with: "https")

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
       
       
        self.lblMachineTimeheader.text = "Machining Time"
        self.lblMachineTimeheader.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblMachineTimeheader.font = UIFont(name: "Inter-SemiBold", size: 14)
        
        self.lblMachineTime.text = obj.last_response//AppUtils.getDateForPaymentInfo(paymentDate: obj.last_response)
        self.lblMachineTime.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblMachineTime.font = UIFont(name: "Inter-Light", size: 12)
    
        self.lblPartMade.text = "Parts Made"
        self.lblPartMade.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblPartMade.font = UIFont(name: "Inter-SemiBold", size: 14)
        
        self.lblNopartMade.text = String(obj.parts)
        self.lblNopartMade.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblNopartMade.font = UIFont(name: "Inter-Light", size: 12)
        
        
        self.lblFileName.text = "File Name"
        self.lblFileName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblFileName.font = UIFont(name: "Inter-SemiBold", size: 14)
        
        self.lblNameOfFile.text = obj.filename
        self.lblNameOfFile.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblNameOfFile.font = UIFont(name: "Inter-Light", size: 12)
        
        self.btnReset.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        self.btnReset.layer.cornerRadius = 12
        self.btnReset.clipsToBounds = true
        
        if Device.IS_IPHONE_X
        {
            self.imgWidth.constant = 56
            self.imgHeight.constant = 56
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height / 2
            self.imgProfile.clipsToBounds = true
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
            //self.scrlHeight.constant =  150//200
            //self.scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: self.scrlHeight.constant)
            
            self.lblMachineTimeheader.font = UIFont(name: "Inter-SemiBold", size: 18)
            self.lblPartMade.font = UIFont(name: "Inter-SemiBold", size: 18)
            self.lblMachineTime.font = UIFont(name: "Inter-Light", size: 16)
            self.lblNopartMade.font = UIFont(name: "Inter-Light", size: 16)
            self.lblFileName.font = UIFont(name: "Inter-SemiBold", size: 18)
            self.lblNameOfFile.font = UIFont(name: "Inter-Light", size: 16)
            
        }
        
    }
    
    func setUPUIUnsubscribe(obj : controllersList)
    {
        self.btnToggel.isUserInteractionEnabled = false
        self.viewCircleChart.transform = CGAffineTransform(rotationAngle: 0)

        self.setUpUnsubscribeAlert()
        self.otherView.isHidden = false
        self.myAppDelegate.progressFrom = "Machine"
        self.btnReset.isHidden = true
        self.btnReset.backgroundColor = UIColor.clear
        self.btnReset.isUserInteractionEnabled = false
        
        self.viewAlarm.isHidden = true
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
        
        let heightCalu = obj.name.heightWithConstrainedWidth(width: CGFloat(332), font: UIFont(name: "Inter-SemiBold", size: 24)!)
        
        if heightCalu > 30
        {
            machineHeight.constant = 60
        }
        else
        {
            machineHeight.constant = 35
        }
        
        self.lblCicle.backgroundColor = UIColor.init(red: 11.0/255.0, green: 169.0/255.0, blue: 107.0/255.0, alpha: 1.0)
        self.lblTextMachine.textColor = UIColor.init(red: 11.0/255.0, green: 169.0/255.0, blue: 107.0/255.0, alpha: 1.0)
        self.machineView.backgroundColor = UIColor.init(red: 11.0/255.0, green: 169.0/255.0, blue: 107.0/255.0, alpha: 0.16)
        self.lblStateNameWidth.constant = 140
        
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
        
        self.toggelView.layer.cornerRadius = self.toggelView.frame.size.height / 2
        self.toggelView.clipsToBounds = true
        
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
    
    static func getAlertTypeMessage(valueAlert : Int)-> String
    {
        var message = String()
        switch valueAlert {
        case 0:
            message = "X Axis Alarm"
            break
        case 1:
            message = "Y Axis Alarm"
            break
        case 2:
            message = "Z Axis Alarm"
            break
        case 3:
            message = "A Axis Alarm"
            break
        case 4:
            message = "B Axis Alarm"
            break
        case 5:
            message = "Spindle Drive Alarm"
            break
        case 6:
            message = "Air Pressure Low"
            break
        case 7:
            message = "X Axis Hard Limit Alarm"
            break
        case 8:
            message = "Y Axis Hard Limit Alarm"
            break
        case 9:
            message = "Z Axis Hard Limit Alarm"
            break
        case 10:
            message = "A Axis Hard Limit Alarm"
            break
        case 11:
            message = " B Axis Hard Limit Alarm"
            break
        case 12:
            message = "Spindle Coolant Flow Alarm"
            break
        case 20:
            message = "Lubricant Alarm"
            break
        case 21:
            message = "Plasma Torch Hit Alarm"
            break
        case 22:
            message = "Waterjet Head Hit Alarm"
            break
        case 23:
            message = "Waterjet Water Pressure Low Alarm"
            break
        case 24:
            message = "Waterjet Abrasive Low Alarm"
            break
        case 25:
            message = "Waterjet Abrasive Metering Alarm"
            break
        case 26:
            message = "Waterjet Cut Sense Alarm"
            break
        case 254:
            message = "No Axis Alarm"
            break
        case 255:
            message = "No Alarm"
            break
        default:
            message = ""
            break
        }
        return message
    }
    
    
    // MARK: - Call Service ----------
    
    func callServiceForDetails()
    {
        self.viewModel.getControllersListDetails(id: Int(self.serialNumber)!, viewController: self) { errorMessage, msg, list in
            if errorMessage == "Success"
            {
                self.globalcontrollersList = list
                if list.state == "2"
                {
                    self.toggelStatus = list.alarm_sub
                    self.setUPUIForMachine(obj: list)
                }
                else if list.state == "1"
                {
                    self.toggelStatus = list.alarm_sub
                    self.setUPUIForIdle(obj: list)
                }
                else if list.state == "4"
                {
                    self.toggelStatus = list.alarm_sub
                    self.setUPUIAlarm(obj: list)
                }
                else if list.state == "3"
                {
                    self.toggelStatus = list.alarm_sub
                    self.setUPUIOffline(obj: list)
                }
                else
                {
                    self.toggelStatus = list.alarm_sub
                    self.setUPUIUnsubscribe(obj: list)
                }
                self.myAppDelegate.showSerial = list.serial
              
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
        //comment
    }
    
    @IBAction func tapMail(_ sender: Any) {
        
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        

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
               // self.callServiceForDetails()
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
    
    @IBAction func tapToggel(_ sender: Any) {
        self.setUpProAlert()
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
                    self.globalcontrollersList.alarm_sub = 1
                    let dict = ["serial" : self.globalcontrollersList.serial,"alarm_sub" : self.globalcontrollersList.alarm_sub,"is_changed" : "1"]
                    self.myAppDelegate.dictDetails = dict as NSDictionary
                    self.imgBell.image = UIImage(named: "bell")
                    
                }
                else
                {
                    self.globalcontrollersList.alarm_sub = 0
                    let dict = ["serial" : self.globalcontrollersList.serial,"alarm_sub" : self.globalcontrollersList.alarm_sub,"is_changed" : "1"]
                    self.myAppDelegate.dictDetails = dict as NSDictionary
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
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    func setUpUnsubscribeAlert()
    {
        self.otherView.layer.cornerRadius = 20
        self.otherView.clipsToBounds = true
        
        let strOne = "Get a myWorkshop PRO subscription for this controller to view the live data view in real time"
    
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
