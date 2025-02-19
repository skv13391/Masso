//
//  MesageVC.swift
//  Masso
//
//  Created by Sunil on 29/03/23.
//

import UIKit
import Toast_Swift

class MesageVC: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var lblClear: UILabel!
    @IBOutlet weak var lblUnread: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var innerVeiw: UIView!
    @IBOutlet weak var lblCircel: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var clearViewHeight: NSLayoutConstraint!
    @IBOutlet weak var innerViewTopCon: NSLayoutConstraint!
    @IBOutlet weak var lblNoMessage: UILabel!
    @IBOutlet weak var msgHeight: NSLayoutConstraint!
    @IBOutlet weak var btmView: UIView!
    @IBOutlet weak var imgDraft: UIImageView!
    @IBOutlet weak var btnUnread: UIButton!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var scrlHeight: NSLayoutConstraint!
    @IBOutlet weak var lblMachineName: UILabel!
    @IBOutlet weak var lblMHeight: NSLayoutConstraint!
    @IBOutlet weak var lblModelSerial: UILabel!
    @IBOutlet weak var lblModelHeight: NSLayoutConstraint!
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var noMSgView: UIView!
    var msgList : [MessageList] = [MessageList]()
    var isFromHome = Bool()
    var strSerialNumber = String()
    var viewModel = MessageViewModel()
    let refreshControlTbl = UIRefreshControl()

    var strName = String()
    var serialNumber = String()
    
    // MARK: - View Life Cycle ----------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUPUI()
        
        self.myAppDelegate.presentViewCr = "true"
        self.myAppDelegate.showSerial = "11"
        self.tblView.register(UINib(nibName: "unreadCell", bundle: nil), forCellReuseIdentifier: "unreadCell")
        self.tblView.register(UINib(nibName: "unreadSecCell", bundle: nil), forCellReuseIdentifier: "unreadSecCell")
        self.tblView.register(UINib(nibName: "readCell", bundle: nil), forCellReuseIdentifier: "readCell")
        self.tblView.separatorColor = UIColor.clear
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        if #available(iOS 11, *) {
            self.scrlView.contentInsetAdjustmentBehavior = .never
        }
        
      
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.refreshControlTbl.tintColor = UIColor.white
        let attr = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.refreshControlTbl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes:attr)
        self.refreshControlTbl.addTarget(self, action: #selector(self.refreshTbl(_:)), for: .valueChanged)
        self.tblView.addSubview(self.refreshControlTbl)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.clearView.isHidden = true
        self.unreadView.isHidden = true

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
            if self.isFromHome == true || myAppDelegate.isFromMsg == true
            {
                let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 24), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
                
                let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 16), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
                
                
                let attributedString1 = NSMutableAttributedString(string:myAppDelegate.strName + " ", attributes:attrs1 as [NSAttributedString.Key : Any])
                
                let attributedString2 = NSMutableAttributedString(string:myAppDelegate.serialNumber , attributes:attrs2 as [NSAttributedString.Key : Any])
                
                attributedString1.append(attributedString2)
                self.lblMachineName.font = UIFont(name: "Inter-SemiBold", size: 24)
                self.lblMachineName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                self.lblMachineName.text = myAppDelegate.strName
                self.lblMachineName.textAlignment = .center
                self.lblModelSerial.text = myAppDelegate.model + "-" +  myAppDelegate.serialNumber
                self.lblModelSerial.font = UIFont(name: "Inter-SemiBold", size: 16)
                self.lblModelSerial.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                self.lblModelSerial.textAlignment = .center


                self.lblMHeight.constant = 50
                self.lblModelHeight.constant = 30
                self.callServiceforMachineMessageList()
                self.tabBarController?.selectedIndex = 1


            }
            else
            {

                if self.isFromHome == false
                {
                    self.lblMHeight.constant = 0
                    self.lblModelHeight.constant = 0
                    self.callServiceforMessageList()
                    self.tabBarController?.selectedIndex = 1
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mainView.isHidden = true
    }
    
    @objc func refreshTbl(_ sender: AnyObject) {
       // Code to refresh table view
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate

        if self.isFromHome == true || myAppDelegate.isFromMsg == true
        {
            self.tabBarController?.selectedIndex = 1

            let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 24), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
            
            let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 16), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
            
            
            let attributedString1 = NSMutableAttributedString(string:myAppDelegate.strName + " ", attributes:attrs1 as [NSAttributedString.Key : Any])
            
            let attributedString2 = NSMutableAttributedString(string:myAppDelegate.serialNumber , attributes:attrs2 as [NSAttributedString.Key : Any])
            
            
            attributedString1.append(attributedString2)
            self.lblMachineName.font = UIFont(name: "Inter-SemiBold", size: 24)
            self.lblMachineName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
            self.lblMachineName.text = myAppDelegate.strName
            self.lblModelSerial.text = myAppDelegate.model + "-" + myAppDelegate.serialNumber
            self.lblModelSerial.font = UIFont(name: "Inter-SemiBold", size: 16)
            self.lblModelSerial.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
            self.lblMHeight.constant = 50
            self.lblModelHeight.constant = 30

            self.callServiceforMachineMessageList()

        }
        else
        {

            if self.isFromHome == false
            {
                self.lblMHeight.constant = 0
                self.lblModelHeight.constant = 0
                self.callServiceforMessageList()
                self.tabBarController?.selectedIndex = 1
            }
        }
        self.tblView.reloadData()
        self.refreshControlTbl.endRefreshing()
    }
    
    func setUPUI()
    {
        
        self.noMSgView.isHidden = true
        self.lblNoMessage.text = "No" + "\n" + "Messages"
        self.lblNoMessage.font =  UIFont(name: "Inter-Bold", size: 44)
        self.lblNoMessage.textColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        
        self.lblTitle.text = "Messages"
        self.lblTitle.font =  UIFont(name: "Inter-SemiBold", size: 16)
        
        self.clearView.layer.cornerRadius = 12
        self.clearView.clipsToBounds = true
        
        self.unreadView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.12)
        self.unreadView.layer.cornerRadius = 12
        self.unreadView.layer.borderColor = UIColor.white.cgColor
        self.unreadView.layer.borderWidth = 1
        self.unreadView.clipsToBounds = true

        
        self.lblClear.text = "Clear all"
        self.lblClear.textColor = UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        self.lblClear.font =  UIFont(name: "Inter-SemiBold", size: 16)
        
        self.lblUnread.text = "Mark as read"
        self.lblUnread.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblUnread.font =  UIFont(name: "Inter-SemiBold", size: 16)
        
        self.innerVeiw.layer.cornerRadius = 10
        self.innerVeiw.clipsToBounds = true
        self.innerVeiw.backgroundColor = UIColor.init(red: 45.0/255.0, green: 53.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        
        self.lblName.text = "G3-7001"
        self.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblName.font =  UIFont(name: "Inter-Medium", size: 12)
        
        self.lblCircel.layer.cornerRadius = self.lblCircel.frame.size.height / 2
        self.lblCircel.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)
        self.lblCircel.clipsToBounds = true
        
        self.lblPercent.text = "65%"
        self.lblPercent.textColor = UIColor.init(red: 198.0/255.0, green: 149.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        self.lblPercent.font =  UIFont(name: "Inter-SemiBold", size: 13)
        
        let detaisl = "Has been stopped, We are trying to connect with you but you are not approachable can you assign someone so we can meet and discuss about it Mill 5 Axis Has been stopped, We are trying to connect with you but you are not approachable can you assign someone so we can meet and discuss about it..."
        
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 13), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 12), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        
        let attributedString1 = NSMutableAttributedString(string:"Mill 5 Axis " , attributes:attrs1 as [NSAttributedString.Key : Any])
        
        let attributedString2 = NSMutableAttributedString(string:detaisl , attributes:attrs2 as [NSAttributedString.Key : Any])
        
        attributedString1.append(attributedString2)
        
        self.lblDetails.font = UIFont(name: "Inter-Medium", size: 12)
        self.lblDetails.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)

    }
    
    // MARK: - Call Service ----------
    
    func callServiceforMachineMessageList()
    {
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate

        self.viewModel.getMachineMessageList(id : myAppDelegate.serialNumber ,viewController: self) { errorMessage, msg, list in
            if errorMessage == "Success"
            {
                if list.count == 0
                {
                    self.noMSgView.isHidden = false
                    self.tblView.isHidden = true
                    self.btmView.isHidden = true
                    self.lblMHeight.constant = 0
                    self.lblModelHeight.constant = 0
                    self.lblMachineName.isHidden = true
                    self.lblModelSerial.isHidden = true
                    self.unreadView.isHidden = true
                    self.clearView.isHidden = true
                }
                else
                {
                    self.unreadView.isHidden = false
                    self.clearView.isHidden = false
                    self.lblMachineName.isHidden = false
                    self.lblModelSerial.isHidden = false
                    self.msgList.removeAll()
                    self.tblView.reloadData()

                    self.noMSgView.isHidden = true
                    self.tblView.isHidden = false
                    self.btmView.isHidden = false
                    self.msgList = list
                    self.tblView.reloadData()
                    var markCheck : Bool = false
                    for item in list
                    {
                        if item.read == "0"
                        {
                            markCheck = true
                            break
                        }
                    }
                    if markCheck == true
                    {
                        self.imgDraft.image = self.imgDraft.image?.withRenderingMode(.alwaysTemplate)
                        self.imgDraft.tintColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                        self.lblUnread.textColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                        self.unreadView.layer.borderColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
                        self.unreadView.layer.borderWidth = 1
                        self.unreadView.clipsToBounds = true
                        self.btnUnread.isUserInteractionEnabled = true
                    }
                    else
                    {
                        self.imgDraft.image = self.imgDraft.image?.withRenderingMode(.alwaysTemplate)
                        self.imgDraft.tintColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.3)
                        self.lblUnread.textColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.3)
                        self.unreadView.layer.borderColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.3).cgColor
                        self.unreadView.layer.borderWidth = 1
                        self.unreadView.clipsToBounds = true
                        self.btnUnread.isUserInteractionEnabled = false
                    }
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
                    self.noMSgView.isHidden = false
                    self.tblView.isHidden = true
                    self.btmView.isHidden = true
                    self.lblMHeight.constant = 0
                    self.lblModelHeight.constant = 0
                    self.lblMachineName.isHidden = true
                    self.lblModelSerial.isHidden = true
                    self.unreadView.isHidden = true
                    self.clearView.isHidden = true
                }
                

            }
        }
    }
    
    func callServiceforMessageList()
    {
        self.viewModel.getMessageList(viewController: self) { errorMessage, msg, list in
            if errorMessage == "Success"
            {
                if list.count == 0
                {
                    self.msgList.removeAll()
                    self.tblView.reloadData()
                    self.noMSgView.isHidden = false
                    self.tblView.isHidden = true
                    self.btmView.isHidden = true
                    self.unreadView.isHidden = true
                    self.clearView.isHidden = true
                }
                else
                {

                    self.noMSgView.isHidden = true
                    self.tblView.isHidden = false
                    self.btmView.isHidden = false
                    self.unreadView.isHidden = false
                    self.clearView.isHidden = false
                    
                    self.msgList.removeAll()
                    self.msgList = list
                    self.tblView.reloadData()
                    var markCheck : Bool = false
                    for item in list
                    {
                        if item.read == "0"
                        {
                            markCheck = true
                            break
                        }
                    }
                    if markCheck == true
                    {
                        self.imgDraft.image = self.imgDraft.image?.withRenderingMode(.alwaysTemplate)
                        self.imgDraft.tintColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                        self.lblUnread.textColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                        self.unreadView.layer.borderColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
                        self.unreadView.layer.borderWidth = 1
                        self.unreadView.clipsToBounds = true
                        self.btnUnread.isUserInteractionEnabled = true
                    }
                    else
                    {
                        self.imgDraft.image = self.imgDraft.image?.withRenderingMode(.alwaysTemplate)
                        self.imgDraft.tintColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.3)
                        self.lblUnread.textColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.3)
                        self.unreadView.layer.borderColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.3).cgColor
                        self.unreadView.layer.borderWidth = 1
                        self.unreadView.clipsToBounds = true
                        self.btnUnread.isUserInteractionEnabled = false
                    }
                    
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
                    self.noMSgView.isHidden = false
                    self.tblView.isHidden = true
                    self.btmView.isHidden = true
                    self.unreadView.isHidden = true
                    self.clearView.isHidden = true
                }
            }
        }
    }
    
    func updateMessageStatus(id : String)
    {
        self.viewModel.getMessageReadStatus(id: id, viewController: self) { errorMessage, msg in
            if errorMessage == "Success"
            {
                self.view.makeToast(msg)
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
                    
                }
            }
        }
    }
    
    
    // MARK: - UIAction Method ----------
    @IBAction func tabClear(_ sender: Any) {
        
        
        let alert = UIAlertController(title: webServices.AppName, message: "Are you sure you want to clear all messages?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.viewModel.clearMessage(viewController: self, isLoaderRequired: true) { errorString, msg in
                if errorString == "Success"
                {
                    //self.view.makeToast(msg)
                   // self.clearViewHeight.constant = 0
                    self.clearView.isHidden = true
                    self.unreadView.isHidden = true
                    if self.isFromHome == true
                    {
                        self.callServiceforMachineMessageList()
                    }
                    else
                    {
                        self.callServiceforMessageList()
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
                        
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { (action) in
        
        }))
        self.present(alert, animated: true, completion: nil)
        
        

    }
    
    @IBAction func tapClose(_ sender: Any) {
        self.mainView.isHidden = true
        if self.isFromHome == true
        {
            self.callServiceforMachineMessageList()
        }
        else
        {
            self.callServiceforMessageList()
        }
    }
    
    @IBAction func tapUnread(_ sender: Any) {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.viewModel.getMessageReadStatus(id: "", viewController: self) { errorMessage, msg in
            if errorMessage == "Success"
            {
                //self.view.makeToast(msg)
                if self.isFromHome == true
                {
                    self.callServiceforMachineMessageList()
                }
                else
                {
                    self.callServiceforMessageList()
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
                    
                }
            }
        }
        
    }
    
    // MARK: - UITableView Delegate & Datasource ---------
    
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print(self.msgList.count)
         return self.msgList.count
    }
    
//    func convertToLocaleTimeZone(date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        // Set the time zone to the local time zone
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//
//        // Format the date
//        let formattedDate = dateFormatter.string(from: date)
//
//        return formattedDate
//    }

    func convertStringToDate(dateString: String, format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        // You can set a specific time zone if needed
        // dateFormatter.timeZone = TimeZone(identifier: "YourTimeZoneIdentifier")
        
        return dateFormatter.date(from: dateString)
    }
    
    func convertToLocaleTimeZone(date: Date) -> Date {
        let localTimeZone = TimeZone.current
        let secondsFromGMT = TimeInterval(localTimeZone.secondsFromGMT(for: date))
        return date.addingTimeInterval(secondsFromGMT)
    }

    // Example usage
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         self.msgList.removeAll()
         if self.msgList[indexPath.row].read == "0"
         {
             if let cell = tableView.dequeueReusableCell(withIdentifier: "unreadSecCell", for: indexPath) as? unreadSecCell {
                 cell.lblName.text = self.msgList[indexPath.row].model_name +  "-" + self.msgList[indexPath.row].serial
                 
                 // Example usage
                 let inputDateString = self.msgList[indexPath.row].timestamp
                 let dateString = inputDateString // Replace this with your own date string
                 if let date = convertStringToDate(dateString: dateString) {
                     print("Converted Date: \(date)")
                     let localDate = convertToLocaleTimeZone(date: date)
                     let dateFormatter = DateFormatter()
                     dateFormatter.dateFormat = "HH:mm, dd-MMM-yyyy"
                     let localTimeString = dateFormatter.string(from: localDate)
                     cell.lblTime.text = "\(localTimeString)"
                 } else {
                     print("Failed to convert the string to date.")
                 }
                 
              
                 
                  // AppUtils.getDateForPaymentInfo(paymentDate: )
                 cell.lblDetrails.text = self.msgList[indexPath.row].body
                // cell.lblPercent.text = String(self.msgList[indexPath.row].progress) + "%"
                 cell.lblPercent.isHidden = true
                 cell.lblLeft.isHidden = false
                 let imgUrl = self.msgList[indexPath.row].image//.replacingOccurrences(of: "http", with: "https")
                 cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2
                 cell.imgProfile.clipsToBounds = true
                 
                 let imgPath = (imgUrl as AnyObject).replacingOccurrences(of: "'\'", with: "").stringByAddingPercentEncodingForRFC3986()
                        if(imgPath != nil && imgPath != ""){
                            cell.imgProfile.kf.setImage(
                                with: URL(string: imgPath ?? ""),
                                placeholder: UIImage(named: "rechargeGobblyLogo"),
                                options: nil){
                                    result in
                                    switch result {
                                    case .success(_):
                                        cell.imgProfile.contentMode = .scaleAspectFill;
                                        
                                    case .failure(_):
                                        cell.imgProfile.contentMode = .scaleAspectFill;
                                    }
                            }
                        }
                 
                 
                 if Device.IS_IPHONE
                 {
                     cell.lblName.font =  UIFont(name: "Inter-Medium", size: 12)
                     cell.lblTime.font =  UIFont(name: "Inter-Light", size: 10)
                     cell.lblPercent.font =  UIFont(name: "Inter-SemiBold", size: 12)
                     cell.lblDetrails.font = UIFont(name: "Inter-Regular", size: 12)
                     cell.mHeight.constant = 14
                     cell.cHeight.constant = 6
                     cell.cWidth.constant = 6
                     cell.pHeight.constant = 15
                     cell.timeHeight.constant = 14
                     cell.msgHeight.constant = 35
                     cell.lblCircel.layer.cornerRadius = cell.lblCircel.frame.size.height / 2
                     cell.lblCircel.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)
                     cell.lblCircel.clipsToBounds = true
                     
                     let height = CommonFunctions.sharedInstance.calculateHeight(inString: self.msgList[indexPath.row].body, width: self.tblView.frame.size.width - 100, font: UIFont(name: "Inter-Regular", size: 12)!)
                     print(height)
                     if height < 16.0
                     {
                         cell.msgHeight.constant = 25
                     }
                     else
                     {
                         cell.msgHeight.constant = 35
                     }
                 }
                 else
                 {
                     cell.lblName.font =  UIFont(name: "Inter-Medium", size: 16)
                     cell.lblTime.font =  UIFont(name: "Inter-Light", size: 14)
                     cell.lblPercent.font =  UIFont(name: "Inter-SemiBold", size: 16)
                     cell.lblDetrails.font = UIFont(name: "Inter-Regular", size: 16)
                     cell.mHeight.constant = 20
                     cell.cHeight.constant = 10
                     cell.cWidth.constant = 10

                     cell.pHeight.constant = 25
                     cell.timeHeight.constant = 25
                    
                     cell.lblCircel.layer.cornerRadius = 5
                     cell.lblCircel.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)
                     cell.lblCircel.clipsToBounds = true
                     let height = CommonFunctions.sharedInstance.calculateHeight(inString: self.msgList[indexPath.row].body, width: self.tblView.frame.size.width - 100, font: UIFont(name: "Inter-Regular", size: 12)!)
                     print(height)
                     if height < 16.0
                     {
                         cell.msgHeight.constant = 25
                     }
                     else
                     {
                         cell.msgHeight.constant = 60
                     }
                 }
                 
                 
                 
                 return cell
             }
         }
         else
         {
             if let cell = tableView.dequeueReusableCell(withIdentifier: "unreadSecCell", for: indexPath) as? unreadSecCell {
                 cell.lblName.text = self.msgList[indexPath.row].model_name +  "-" + self.msgList[indexPath.row].serial
                 // Example usage
                 let inputDateString = self.msgList[indexPath.row].timestamp
                 let dateString = inputDateString // Replace this with your own date string
                 if let date = convertStringToDate(dateString: dateString) {
                     print("Converted Date: \(date)")
                     let localDate = convertToLocaleTimeZone(date: date)
                     let dateFormatter = DateFormatter()
                     dateFormatter.dateFormat = "HH:mm, dd-MMM-yyyy"
                     let localTimeString = dateFormatter.string(from: localDate)
                     cell.lblTime.text = "\(localTimeString)"
                 } else {
                     print("Failed to convert the string to date.")
                 }
                 
                // cell.lblTime.text =  AppUtils.getDateForPaymentInfo(paymentDate: self.msgList[indexPath.row].timestamp)
                 cell.lblDetrails.text = self.msgList[indexPath.row].body
                 //cell.lblPercent.text = String(self.msgList[indexPath.row].progress) + "%"
                 cell.lblPercent.isHidden = true
                 cell.lblLeft.isHidden = true
                 let imgUrl = self.msgList[indexPath.row].image//.replacingOccurrences(of: "http", with: "https")
                 cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2
                 cell.imgProfile.clipsToBounds = true
                 
                 let imgPath = (imgUrl as AnyObject).replacingOccurrences(of: "'\'", with: "").stringByAddingPercentEncodingForRFC3986()
                        if(imgPath != nil && imgPath != ""){
                            cell.imgProfile.kf.setImage(
                                with: URL(string: imgPath ?? ""),
                                placeholder: UIImage(named: "rechargeGobblyLogo"),
                                options: nil){
                                    result in
                                    switch result {
                                    case .success(_):
                                        cell.imgProfile.contentMode = .scaleAspectFill;
                                        
                                    case .failure(_):
                                        cell.imgProfile.contentMode = .scaleAspectFill;
                                    }
                            }
                        }
                 
                 if Device.IS_IPHONE
                 {
                     cell.lblName.font =  UIFont(name: "Inter-Medium", size: 12)
                     cell.lblTime.font =  UIFont(name: "Inter-Light", size: 10)
                     cell.lblPercent.font =  UIFont(name: "Inter-SemiBold", size: 12)
                     cell.lblDetrails.font = UIFont(name: "Inter-Regular", size: 12)
                     cell.mHeight.constant = 14
                     cell.cHeight.constant = 6
                     cell.cWidth.constant = 6
                     cell.pHeight.constant = 15
                     cell.timeHeight.constant = 14
                     cell.msgHeight.constant = 35
                     cell.lblCircel.layer.cornerRadius = cell.lblCircel.frame.size.height / 2
                     cell.lblCircel.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)
                     cell.lblCircel.clipsToBounds = true
                     
                     let height = CommonFunctions.sharedInstance.calculateHeight(inString: self.msgList[indexPath.row].body, width: self.tblView.frame.size.width - 100, font: UIFont(name: "Inter-Regular", size: 12)!)
                     print(height)
                     if height < 16.0
                     {
                         cell.msgHeight.constant = 25
                     }
                     else
                     {
                         cell.msgHeight.constant = 35
                     }
                 }
                 else
                 {
                     cell.lblName.font =  UIFont(name: "Inter-Medium", size: 16)
                     cell.lblTime.font =  UIFont(name: "Inter-Light", size: 14)
                     cell.lblPercent.font =  UIFont(name: "Inter-SemiBold", size: 16)
                     cell.lblDetrails.font = UIFont(name: "Inter-Regular", size: 16)
                     cell.mHeight.constant = 20
                     cell.cHeight.constant = 10
                     cell.cWidth.constant = 10

                     cell.pHeight.constant = 25
                     cell.timeHeight.constant = 25
                    
                     cell.lblCircel.layer.cornerRadius = 5
                     cell.lblCircel.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)
                     cell.lblCircel.clipsToBounds = true
                     let height = CommonFunctions.sharedInstance.calculateHeight(inString: self.msgList[indexPath.row].body, width: self.tblView.frame.size.width - 100, font: UIFont(name: "Inter-Regular", size: 12)!)
                     print(height)
                     if height < 16.0
                     {
                         cell.msgHeight.constant = 25
                     }
                     else
                     {
                         cell.msgHeight.constant = 60
                     }
                 }
                 
                 
                 return cell
             }
         }
         
        
         
        return UITableViewCell()
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if Device.IS_IPHONE
         {
             let height = CommonFunctions.sharedInstance.calculateHeight(inString: self.msgList[indexPath.row].body, width: self.tblView.frame.size.width - 50, font: UIFont(name: "Inter-Regular", size: 12)!)
             print(height)
             if height < 16.0
             {
                 return 85
             }
             return 105
         }
         else
         {
             let height = CommonFunctions.sharedInstance.calculateHeight(inString: self.msgList[indexPath.row].body, width: self.tblView.frame.size.width - 100, font: UIFont(name: "Inter-Regular", size: 12)!)
             print(height)
             if height < 16.0
             {
                 return 110
             }
             return 145
         }
        
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         if !Reachability.isConnectedToNetwork()
         {
             let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
             }))
             self.present(alert, animated: true, completion: nil)
             return
         }
         
         if self.msgList[indexPath.row].read == "0"
         {
             self.viewModel.getMessageReadStatus(id: self.msgList[indexPath.row].id, viewController: self) { errorMessage, msg in
                 if errorMessage == "Success"
                 {
                     self.view.makeToast(msg)
                     self.mainView.isHidden = false
                     self.lblName.text = self.msgList[indexPath.row].model_name +  "-" + self.msgList[indexPath.row].serial
                     //self.lblPercent.text = String(self.msgList[indexPath.row].progress) + "%"
                     self.lblPercent.isHidden = true
                     self.lblDetails.text = self.msgList[indexPath.row].title + " " + self.msgList[indexPath.row].body
                     self.scrlHeight.constant = 0
                     self.scrlView.contentSize = CGSize(width: self.scrlView.frame.size.width, height: self.scrlHeight.constant)
                    
                     
                     let msgCOm = self.msgList[indexPath.row].title + " " + self.msgList[indexPath.row].body

                     let heightCalu = msgCOm.heightWithConstrainedWidth(width: CGFloat(249), font: UIFont(name: "Inter-Medium", size: 12)!)
                     
                     print(heightCalu)
                     
                     if heightCalu > 160
                     {
                         self.scrlHeight.constant = 0
                         self.msgHeight.constant = 200
                         self.scrlHeight.constant = heightCalu
                         self.scrlView.contentSize = CGSize(width: self.scrlView.frame.size.width, height: self.scrlHeight.constant)
                     }
                     else
                     {
                         self.msgHeight.constant = 130
                         self.scrlHeight.constant = 0
                         self.scrlView.contentSize = CGSize(width: self.scrlView.frame.size.width, height: self.scrlHeight.constant)
                     }
                     
                     
                     self.innerViewTopCon.constant = (self.view.frame.size.height - self.msgHeight.constant) / 2
                     
                     
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
                         
                     }
                 }
             }
             
         }
         else
         {
            
             let msg = self.msgList[indexPath.row].title + " " + self.msgList[indexPath.row].body
             let heightCalu = msg.heightWithConstrainedWidth(width: CGFloat(self.lblDetails.frame.size.width), font: UIFont(name: "Inter-Medium", size: 12)!)
             
             print(heightCalu)
             
             if heightCalu > 160
             {
                 self.scrlHeight.constant = 0
                 self.msgHeight.constant = 38.0 + heightCalu + 30
                 self.scrlHeight.constant = heightCalu
                 self.scrlView.contentSize = CGSize(width: self.scrlView.frame.size.width, height: self.scrlHeight.constant)
             }
             else
             {
                 self.msgHeight.constant = 38.0 + heightCalu + 30
                 self.scrlHeight.constant = 0
                 self.scrlView.contentSize = CGSize(width: self.scrlView.frame.size.width, height: self.scrlHeight.constant)
             }
             self.innerViewTopCon.constant = (self.view.frame.size.height - self.msgHeight.constant) / 2

             self.mainView.isHidden = false
             self.lblName.text = self.msgList[indexPath.row].model_name +  "-" + self.msgList[indexPath.row].serial
             //self.lblPercent.text = String(self.msgList[indexPath.row].progress) + "%"
             self.lblPercent.isHidden = true
             self.lblDetails.text = self.msgList[indexPath.row].title + " " + self.msgList[indexPath.row].body
         }
         
        
    }
}


extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
