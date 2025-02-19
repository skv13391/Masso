//
//  HomeVC.swift
//  Masso
//
//  Created by Sunil on 27/03/23.
//

import UIKit
import CocoaMQTT
import Foundation
import QuartzCore
import CoreGraphics
import CommonCrypto
import FirebaseCrashlytics

class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var lblDevice: UILabel!
    @IBOutlet weak var btnGrid: UIButton!
    @IBOutlet weak var btnLinear: UIButton!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnIdle: UIButton!
    @IBOutlet weak var viewIdel: UIView!
    @IBOutlet weak var btnAlrm: UIButton!
    @IBOutlet weak var viewAlrm: UIView!
    @IBOutlet weak var viewMachine: UIView!
    @IBOutlet weak var btnMachine: UIButton!
    @IBOutlet weak var viewOffline: UIView!
    @IBOutlet weak var btnOffline: UIButton!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblNoMachine: UILabel!
    @IBOutlet weak var noMAchineView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var lblOtherDetails: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    
    @IBOutlet weak var alarmToggelView: UIView!
    @IBOutlet weak var alarmInnerView: UIView!
    @IBOutlet weak var imgMcn: UIImageView!
    @IBOutlet weak var btnCLose: UIButton!
    @IBOutlet weak var lblAlamName: UILabel!
    @IBOutlet weak var lblAlramDetails: UILabel!
    @IBOutlet weak var btnView: UIButton!
    var selectedTab : String = "All"
    
    var viewModel = HomeViewModel()
    
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate

    var cModelList : [controllers] = [controllers]()
    var cntrollersList : [controllersList] = [controllersList]()
    var tempCntrollersList : [controllersList] = [controllersList]()
    var selectedMode : String = ""
    let defaultHost = "mqtt.masso.com.au"//"170.64.134.196"//"157.245.236.173"
    var mqtt: CocoaMQTT?
    var clientId =  "534534534"
    var dicrDta = NSDictionary()

    // MARK: - View Life Cycle ----------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setStatusBar(backgroundColor: color.bgColor)
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
        
       
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        myAppDelegate.showSerial = "11"
        if myAppDelegate.isFromPush == true
        {
            myAppDelegate.isFromPush = false
            self.pushForNotification(stateC: myAppDelegate.comingState, serialNumber: myAppDelegate.pushSerialNumber)
        }
        else
        {
            myAppDelegate.serialNumber = ""
        }
        
        let imgUrl = UserDefaults.standard.object(forKey: "dpp") as? String
        if imgUrl == "" || imgUrl == nil
        {
            if myAppDelegate.isFromLogin == true
            {
                myAppDelegate.isFromLogin = false
                self.tabBarController?.addSubviewToLastTabItem("",ischeck: true)
            }
            else
            {
                myAppDelegate.isFromLogin = false
                self.tabBarController?.addSubviewToLastTabItem("",ischeck: false)
            }
           
        }
        else
        {
            if myAppDelegate.isFromLogin == true
            {
                myAppDelegate.isFromLogin = false
                self.tabBarController?.addSubviewToLastTabItem(imgUrl,ischeck: true)
            }
            else
            {
                myAppDelegate.isFromLogin = false
                self.tabBarController?.addSubviewToLastTabItem(imgUrl,ischeck: false)
            }
           
        }
        self.setUPUI()
        self.showBottomBar()
        self.setUpProAlert()
       
        
        print(self.view.frame.size.height)
        if Device.IS_IPHONE
        {
            if self.collView != nil
            {
                // collectionVie
                if self.view.frame.size.width > 412
                {
                    let width = (self.collView.frame.size.width - 20)  / 2
                    print(width)
                    let layout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    layout.scrollDirection = .vertical
                    layout.itemSize = CGSize(width: width, height: 144)
                    self.collView.collectionViewLayout = layout
                    self.collView.delegate = self
                    self.collView.dataSource = self
                }
                else if Device.IS_IPHONE_X
                {
                    let width = (self.collView.frame.size.width - 40)  / 2
                    print(width)
                    let layout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    layout.scrollDirection = .vertical
                    layout.itemSize = CGSize(width: width, height: 144)
                    self.collView.collectionViewLayout = layout
                    self.collView.delegate = self
                    self.collView.dataSource = self
                }
                else
                {
                    let width = (self.collView.frame.size.width - 50)  / 2
                    print(width)
                    let layout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    layout.scrollDirection = .vertical
                    layout.itemSize = CGSize(width: width, height: 144)
                    self.collView.collectionViewLayout = layout
                    self.collView.delegate = self
                    self.collView.dataSource = self

                }

                
            }
        }
        else
        {
            if UIDevice.current.orientation.isLandscape {
                let width = (self.view.frame.size.width - 80)  / 4
                print(width)
                let layout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                layout.scrollDirection = .vertical
                layout.itemSize = CGSize(width: width, height: width)
                self.collView.collectionViewLayout = layout
                self.collView.delegate = self
                self.collView.dataSource = self
            }
            else
            {
                let width = (self.view.frame.size.width - 80)  / 3
                print(width)
                let layout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                layout.scrollDirection = .vertical
                layout.itemSize = CGSize(width: width, height: width)
                self.collView.collectionViewLayout = layout
                self.collView.delegate = self
                self.collView.dataSource = self
            }
            
        }

       
        
        self.tblView.register(UINib(nibName: "idlemachineCell", bundle: nil), forCellReuseIdentifier: "idlemachineCell")
        self.tblView.register(UINib(nibName: "machineCell", bundle: nil), forCellReuseIdentifier: "machineCell")
        self.tblView.register(UINib(nibName: "alertCell", bundle: nil), forCellReuseIdentifier: "alertCell")
        self.tblView.register(UINib(nibName: "offllineCell", bundle: nil), forCellReuseIdentifier: "offllineCell")
        self.tblView.register(UINib(nibName: "newOfflineCell", bundle: nil), forCellReuseIdentifier: "newOfflineCell")

        
        self.tblView.separatorColor = UIColor.clear
       
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.setUpDeviceToggelAlarm()
        
        
        
        //self.collView.addSubview(self.refreshControlTbl)
        
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
            self.getServiceforControllers()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.myAppDelegate.presentViewCr = "true"
        let dict = self.myAppDelegate.dictDetails
        if dict.count != 0
        {
            let isChanged = dict.object(forKey: "is_changed") as? String
            if isChanged == "1"
            {
                let serialNumber = dict.object(forKey: "serial") as? String
                let alarm_sub = dict.object(forKey: "alarm_sub") as? Int

                for i in 0...(self.cntrollersList.count - 1)
                {
                    let model = self.cntrollersList[i]
                    let serialModel = model.serial
                    if serialModel == serialNumber
                    {
                        self.cntrollersList[i].alarm_sub = alarm_sub!
                        self.tempCntrollersList[i].alarm_sub = alarm_sub!
                        break
                    }
                }
                self.tblView.reloadData()
                self.collView.reloadData()
                
                self.myAppDelegate.dictDetails = [:]
            }
        }
       
    }
    
    @objc func rotated() {
        if Device.IS_IPHONE
        {
            return
        }
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            let myAppDelegate = UIApplication.shared.delegate as! AppDelegate

            let imgUrl = UserDefaults.standard.object(forKey: "dpp") as? String
            if imgUrl == "" || imgUrl == nil
            {
                if myAppDelegate.isFromLogin == true
                {
                    myAppDelegate.isFromLogin = false
                    self.tabBarController?.addSubviewToLastTabItem("",ischeck: true)
                }
                else
                {
                    myAppDelegate.isFromLogin = false
                    self.tabBarController?.addSubviewToLastTabItem("",ischeck: false)
                }
               
            }
            else
            {
                if myAppDelegate.isFromLogin == true
                {
                    myAppDelegate.isFromLogin = false
                    self.tabBarController?.addSubviewToLastTabItem(imgUrl,ischeck: true)
                }
                else
                {
                    myAppDelegate.isFromLogin = false
                    self.tabBarController?.addSubviewToLastTabItem(imgUrl,ischeck: false)
                }
               
            }
        } else {
            print("Portrait")
            let myAppDelegate = UIApplication.shared.delegate as! AppDelegate

            let imgUrl = UserDefaults.standard.object(forKey: "dpp") as? String
            if imgUrl == "" || imgUrl == nil
            {
                if myAppDelegate.isFromLogin == true
                {
                    myAppDelegate.isFromLogin = false
                    self.tabBarController?.addSubviewToLastTabItem("",ischeck: true)
                }
                else
                {
                    myAppDelegate.isFromLogin = false
                    self.tabBarController?.addSubviewToLastTabItem("",ischeck: false)
                }
               
            }
            else
            {
                if myAppDelegate.isFromLogin == true
                {
                    myAppDelegate.isFromLogin = false
                    self.tabBarController?.addSubviewToLastTabItem(imgUrl,ischeck: true)
                }
                else
                {
                    myAppDelegate.isFromLogin = false
                    self.tabBarController?.addSubviewToLastTabItem(imgUrl,ischeck: false)
                }
               
            }
        }
    }
    
    func setUPMQTT()
    {
      //  server ip : 170.64.134.196
       // port : 1883
        
        let pToken = UserDefaults.standard.object(forKey: "token") as? String
        let str = pToken!
        let data = ccSha256(data: str.data(using: .utf8)!)
        let key256Sha = "\(data.map { String(format: "%02hhx", $0) }.joined())"
        print("sha256 String: \(key256Sha)")

        
        
        let clientID = key256Sha//"CocoaMQTT-\(self.clientId)-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: defaultHost, port: 1882) // 1890
        mqtt?.username = "usersub_p"//"usersub_t"//
        mqtt?.password = "03V8Yy6USetd" // "4d42Yd91j5A0"//
        mqtt!.keepAlive = 3
        mqtt!.delegate = self
        mqtt?.enableSSL = true
        mqtt?.allowUntrustCACertificate = true
        self.connectMQTT()
        
       
        // add when server got SLL then below line will be uncmmented
       
    }
    
    func connectMQTT()
    {
        _ = self.mqtt?.connect()
        self.mqtt!.autoReconnect = true
       

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.otherView.isHidden = true
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
    
    func pushForNotification(stateC : String, serialNumber : String)
    {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC{
            vc.serialNumber = serialNumber
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setUPUI()
    {
        self.lblDevice.text = "Devices"
        
        if Device.IS_IPHONE
        {
            self.lblDevice.font =  UIFont(name: "Inter-SemiBold", size: 16)
            self.btnAll.titleLabel?.font = UIFont(name: "Inter-Medium", size: 12)
            self.btnIdle.titleLabel?.font = UIFont(name: "Inter-Medium", size: 12)
            self.btnAlrm.titleLabel?.font = UIFont(name: "Inter-Medium", size: 12)
            self.btnMachine.titleLabel?.font = UIFont(name: "Inter-Medium", size: 12)
            self.btnOffline.titleLabel?.font = UIFont(name: "Inter-Medium", size: 12)
        }
        else
        {
            self.lblDevice.font =   UIFont(name: "Inter-SemiBold", size: 16)
            self.btnAll.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
            self.btnIdle.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
            self.btnAlrm.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
            self.btnMachine.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
            self.btnOffline.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
        }
        

        self.btnAll.backgroundColor = color.btnColor
        self.btnAll.setTitleColor(UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0), for: .normal)
        
        self.btnIdle.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnIdle.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnAlrm.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnAlrm.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnMachine.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnMachine.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnOffline.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnOffline.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)
            
        
        self.makeButtonBorder(btn: self.btnAll)
        self.makeButtonBorder(btn: self.btnIdle)
        self.makeButtonBorder(btn: self.btnAlrm)
        self.makeButtonBorder(btn: self.btnMachine)
        self.makeButtonBorder(btn: self.btnOffline)
        self.makeButtonBorder(btn: self.btnGrid)
        self.makeButtonBorder(btn: self.btnLinear)

        self.noMAchineView.isHidden = true
        self.lblNoMachine.text = "No " + "Devices " + "Exist"
        self.lblNoMachine.font =  UIFont(name: "Inter-Bold", size: 30)
        self.lblNoMachine.textColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 1.0)
    }

    func makeButtonBorder(btn :UIButton)
    {
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
    }
    
    // MARK: - Call Service ----------

    func getServiceforControllers()
    {
        self.viewModel.getAllControllers(viewController: self) { errorMessage, msg, list in
            if errorMessage == "Success"
            {
                self.cModelList = list
                self.getServiceforControllersList()
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
                  
                    UserDefaults.standard.set("false", forKey: "login")
                    UserDefaults.standard.synchronize()
                    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                    myAppDelegate.setRootNavigation()
                    myAppDelegate.resetDefaults()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getServiceforControllersList()
    {
        self.viewModel.getAllControllersList(viewController: self) { errorMessage, msg, list in
            if errorMessage == "Success"
            {
                self.tempCntrollersList.removeAll()
                self.cntrollersList.removeAll()
                for var item in list
                {
                    for subItem in self.cModelList
                    {
                        if Int(item.state) == subItem.sid
                        {
                            item.machineState = subItem.sname
                        }
                        else if Int(item.state) == 0
                        {
                            item.machineState = "unsubscribe"
                        }
                    }
                    self.cntrollersList.append(item)
                }
                
                self.tempCntrollersList = self.cntrollersList
                print(self.cntrollersList)
                
                self.collView.reloadData()
                self.tblView.reloadData()
                
                
                if self.cntrollersList.count == 0
                {
                    self.collView.isHidden = true
                    self.tblView.isHidden = true
                    self.noMAchineView.isHidden = false
                }
                else if self.cntrollersList.count == 1
                {
                    self.selectedMode = "Linear"
                    self.collView.isHidden = true
                    self.tblView.isHidden = false
                    self.noMAchineView.isHidden = true
                    
                    let origImage = UIImage(named: "linear")
                    let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                    self.btnLinear.setImage(tintedImage, for: .normal)
                    self.btnLinear.tintColor = UIColor.white
                    self.btnLinear.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.12)
                    self.selectedMode = "Linear"

                    
                    let origImage1 = UIImage(named: "grid_Unselected")
                    let tintedImage1 = origImage1?.withRenderingMode(.alwaysTemplate)
                    self.btnGrid.setImage(tintedImage1, for: .normal)
                    self.btnGrid.tintColor = color.btnInactiveColor
                    self.btnGrid.backgroundColor = UIColor.clear

                    self.makeButtonBorder(btn: self.btnGrid)
                    self.makeButtonBorder(btn: self.btnLinear)

                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC{
                        vc.serialNumber = self.cntrollersList[0].serial
                        vc.toggelStatus = self.cntrollersList[0].alarm_sub
                        self.navigationController?.pushViewController(vc, animated: true)

                    }
                }
                else
                {

                    if self.selectedMode == "" || self.selectedMode.count == 0
                    {
                        self.selectedMode = "Grid"
                    }
                    
                    self.collView.isHidden = false
                    self.tblView.isHidden = true
                    self.noMAchineView.isHidden = true
                    
                    if self.selectedMode == "Grid"
                    {
                        self.collView.isHidden = false
                        self.tblView.isHidden = true
                    }
                    else
                    {
                        self.collView.isHidden = true
                        self.tblView.isHidden = false
                    }
                    
                    if self.selectedTab == "All"
                    {
                        
                    }
                    else  if self.selectedTab == "Idle"
                    {
                        self.cntrollersList = self.cntrollersList.filter({(($0.state == "1"))})
                        self.collView.reloadData()
                        self.tblView.reloadData()
                    }
                    else  if self.selectedTab == "Alarm"
                    {
                        self.cntrollersList = self.cntrollersList.filter({(($0.state == "4"))})
                        self.collView.reloadData()
                        self.tblView.reloadData()
                    }
                    else  if self.selectedTab == "Offline"
                    {
                        self.cntrollersList = self.cntrollersList.filter({(($0.state == "3"))})
                        self.collView.reloadData()
                        self.tblView.reloadData()
                    }
                    else
                    {
                        self.cntrollersList = self.cntrollersList.filter({(($0.state == "2"))})
                        self.collView.reloadData()
                        self.tblView.reloadData()
                    }
                }
                
                self.setUPMQTT()
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
                self.tblView.isHidden = true
                self.collView.isHidden = true
                self.noMAchineView.isHidden = false
            }
        }
    }
    
    
    // MARK: - UIAction Method ----------
    
    
    @IBAction func tapAll(_ sender: Any) {
        self.otherView.isHidden = true
        self.btnAll.backgroundColor = color.btnColor
        self.btnAll.setTitleColor(UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0), for: .normal)
        
        self.btnIdle.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnIdle.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnAlrm.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnAlrm.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnMachine.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnMachine.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnOffline.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnOffline.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)
        self.cntrollersList.removeAll()
        self.cntrollersList = self.tempCntrollersList
        self.collView.reloadData()
        self.tblView.reloadData()
        self.selectedTab = "All"
        
        if self.cntrollersList.count == 0
        {
            self.collView.isHidden = true
            self.tblView.isHidden = true
            self.noMAchineView.isHidden = false
        }
        else
        {
            if self.selectedMode == "Grid"
            {
                self.collView.isHidden = false
                self.tblView.isHidden = true
            }
            else
            {
                self.collView.isHidden = true
                self.tblView.isHidden = false
            }
            self.noMAchineView.isHidden = true
        }
    }
    
    @IBAction func tapIdle(_ sender: Any) {
        self.otherView.isHidden = true
        self.btnIdle.backgroundColor = color.btnColor
        self.btnIdle.setTitleColor(UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0), for: .normal)
        
        self.btnAll.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnAll.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnAlrm.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnAlrm.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnMachine.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnMachine.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnOffline.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnOffline.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)
        
        self.cntrollersList.removeAll()
        self.cntrollersList = self.tempCntrollersList
        self.selectedTab = "Idle"

        self.cntrollersList = self.cntrollersList.filter({(($0.state == "1"))})
        self.collView.reloadData()
        self.tblView.reloadData()
        if self.cntrollersList.count == 0
        {
            self.collView.isHidden = true
            self.tblView.isHidden = true
            self.noMAchineView.isHidden = false
        }
        else
        {
            if self.selectedMode == "Grid"
            {
                self.collView.isHidden = false
                self.tblView.isHidden = true
            }
            else
            {
                self.collView.isHidden = true
                self.tblView.isHidden = false
            }
            self.noMAchineView.isHidden = true
        }
        
        
    }
    
    
    @IBAction func tapAlrm(_ sender: Any) {
        
        self.otherView.isHidden = true
        self.btnAlrm.backgroundColor = color.btnColor
        self.btnAlrm.setTitleColor(UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0), for: .normal)
        
        self.btnAll.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnAll.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnIdle.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnIdle.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnMachine.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnMachine.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnOffline.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnOffline.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)
        
        self.cntrollersList.removeAll()
        self.cntrollersList = self.tempCntrollersList
        
        self.cntrollersList = self.cntrollersList.filter({(($0.state == "4"))})
        self.collView.reloadData()
        self.tblView.reloadData()
        
        self.selectedTab = "Alarm"

        
        if self.cntrollersList.count == 0
        {
            self.collView.isHidden = true
            self.tblView.isHidden = true
            self.noMAchineView.isHidden = false
        }
        else
        {
            if self.selectedMode == "Grid"
            {
                self.collView.isHidden = false
                self.tblView.isHidden = true
            }
            else
            {
                self.collView.isHidden = true
                self.tblView.isHidden = false
            }
            self.noMAchineView.isHidden = true
        }
    }
    
    @IBAction func tapMachine(_ sender: Any) {
        self.otherView.isHidden = true
        self.btnMachine.backgroundColor = color.btnColor
        self.btnMachine.setTitleColor(UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0), for: .normal)
        
        self.btnAll.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnAll.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnIdle.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnIdle.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnAlrm.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnAlrm.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnOffline.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnOffline.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)
        
        self.cntrollersList.removeAll()
        self.cntrollersList = self.tempCntrollersList
        
        
        self.selectedTab = "Machine"

        
        self.cntrollersList = self.cntrollersList.filter({(($0.state == "2"))})
        self.collView.reloadData()
        self.tblView.reloadData()
        
        if self.cntrollersList.count == 0
        {
            self.collView.isHidden = true
            self.tblView.isHidden = true
            self.noMAchineView.isHidden = false
        }
        else
        {
            if self.selectedMode == "Grid"
            {
                self.collView.isHidden = false
                self.tblView.isHidden = true
            }
            else
            {
                self.collView.isHidden = true
                self.tblView.isHidden = false
            }
            self.noMAchineView.isHidden = true
        }
    }
    
    @IBAction func tapOffline(_ sender: Any) {
        self.otherView.isHidden = true
        self.btnOffline.backgroundColor = color.btnColor
        self.btnOffline.setTitleColor(UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0), for: .normal)
        
        self.btnAll.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnAll.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnIdle.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnIdle.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnAlrm.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnAlrm.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)

        self.btnMachine.setTitleColor(UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.7), for: .normal)
        self.btnMachine.backgroundColor = UIColor.init(red: 48.0/255.0, green: 57.0/255.0, blue: 63.0/255.0, alpha: 0.7)
        
        self.cntrollersList.removeAll()
        self.cntrollersList = self.tempCntrollersList
        
        self.cntrollersList = self.cntrollersList.filter({(($0.state == "3"))})
        self.collView.reloadData()
        self.tblView.reloadData()
        self.selectedTab = "Offline"
        if self.cntrollersList.count == 0
        {
            self.collView.isHidden = true
            self.tblView.isHidden = true
            self.noMAchineView.isHidden = false
        }
        else
        {
            if self.selectedMode == "Grid"
            {
                self.collView.isHidden = false
                self.tblView.isHidden = true
            }
            else
            {
                self.collView.isHidden = true
                self.tblView.isHidden = false
            }
            self.noMAchineView.isHidden = true
        }
    }
    
    @IBAction func tapGrid(_ sender: Any) {
        self.otherView.isHidden = true
        let origImage = UIImage(named: "grid_Unselected")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        self.btnGrid.setImage(tintedImage, for: .normal)
        self.btnGrid.tintColor = UIColor.white
        self.btnGrid.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.12)
        
        
        let origImage1 = UIImage(named: "linear")
        let tintedImage1 = origImage1?.withRenderingMode(.alwaysTemplate)
        self.btnLinear.setImage(tintedImage1, for: .normal)
        self.btnLinear.tintColor = color.btnInactiveColor
        self.btnLinear.backgroundColor = UIColor.clear

        self.makeButtonBorder(btn: self.btnGrid)
        self.makeButtonBorder(btn: self.btnLinear)
        self.selectedMode = "Grid"
        self.collView.isHidden = false
        self.tblView.isHidden = true
        self.collView.reloadData()
    }
    
    @IBAction func tapLinear(_ sender: Any) {
        self.otherView.isHidden = true
        let origImage = UIImage(named: "linear")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        self.btnLinear.setImage(tintedImage, for: .normal)
        self.btnLinear.tintColor = UIColor.white
        self.btnLinear.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.12)
        self.selectedMode = "Linear"

        
        let origImage1 = UIImage(named: "grid_Unselected")
        let tintedImage1 = origImage1?.withRenderingMode(.alwaysTemplate)
        self.btnGrid.setImage(tintedImage1, for: .normal)
        self.btnGrid.tintColor = color.btnInactiveColor
        self.btnGrid.backgroundColor = UIColor.clear

        self.makeButtonBorder(btn: self.btnGrid)
        self.makeButtonBorder(btn: self.btnLinear)
        
        
        
        self.collView.isHidden = true
        self.tblView.isHidden = false
        self.tblView.reloadData()
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
    
    @IBAction func tapView(_ sender: Any) {
    }
    
    @IBAction func tapCLose(_ sender: Any) {
        self.alarmToggelView.isHidden = true

    }
    
    // MARK: - UIcollectionView Delegate & Datasource -----------
    
    func getIndexPathForSingleColl(view: UIView, collView: UICollectionView) -> IndexPath? {

        let point = collView.convert(view.bounds.origin, from: view)
        let indexPath = collView.indexPathForItem(at: point)
        return indexPath
       }
     
     @objc func tapToggele(button : UIButton)
     {
         if !Reachability.isConnectedToNetwork()
         {
             let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
             }))
             self.present(alert, animated: true, completion: nil)
             return
         }

         let indexPath = self.getIndexPathForSingleColl(view: button, collView: self.collView)
         var setAlrm : Int = 0
         setAlrm = self.cntrollersList[indexPath!.row].alarm_sub
         if setAlrm == 0
         {
             setAlrm = 1
         }
         else
         {
             setAlrm = 0
         }
         let dict = ["serial" : self.cntrollersList[indexPath!.row].serial,"alarm" : String(setAlrm)]
         self.viewModel.setAlertState(dictDat: dict as NSDictionary, viewController: self) { errorMessage, msg in
             if errorMessage == "Success"
             {
                // self.view.makeToast(msg)
                 if setAlrm == 1
                 {
                     self.otherView.isHidden = false
                 }
                 else
                 {
                     self.otherView.isHidden = true
                 }
                 self.getServiceforControllersList()
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
    
    @objc func tapMessage(button : UIButton)
    {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let indexPath = self.getIndexPathForSingleColl(view: button, collView: self.collView)

        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MesageVC") as? MesageVC{
            vc.isFromHome = true
            vc.strSerialNumber = String(self.cntrollersList[indexPath!.row].serial)
            vc.strName = self.cntrollersList[indexPath!.row].name
            vc.serialNumber = self.cntrollersList[indexPath!.row].model + "-" + self.cntrollersList[indexPath!.row].serial
            let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
            myAppDelegate.isFromMsg = true
            myAppDelegate.strName = self.cntrollersList[indexPath!.row].name
            myAppDelegate.serialNumber = String(self.cntrollersList[indexPath!.row].serial)
            myAppDelegate.model = self.cntrollersList[indexPath!.row].model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return self.cntrollersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
            let state = self.cntrollersList[indexPath.row].state
            if state == "1"
            {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollCell", for: indexPath) as? homeCollCell{
                                
                    cell.layer.cornerRadius = 5
                    cell.clipsToBounds = true
                    
                   
                    
                    cell.stateView.layer.cornerRadius = 8
                    cell.stateView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
                    cell.stateView.clipsToBounds = true
                    cell.imgMsg.image = cell.imgMsg.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgMsg.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
                    
                    cell.imgBell.image = cell.imgBell.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgBell.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
                    cell.bellView.layer.cornerRadius = 13
                    cell.bellView.clipsToBounds = true
                    
                    cell.msgView.layer.cornerRadius = cell.msgView.frame.size.height / 2
                    cell.msgView.clipsToBounds = true
                    cell.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                    cell.lblName.text = self.cntrollersList[indexPath.row].name
                    
                    cell.lblMCode.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                    cell.lblMCode.text = self.cntrollersList[indexPath.row].model + "-" + self.cntrollersList[indexPath.row].serial
                    
                    cell.lblCircle.layer.cornerRadius = cell.lblCircle.frame.size.height / 2
                    cell.lblCircle.clipsToBounds = true
                  
                    if Device.IS_IPHONE
                    {
                        cell.lblName.font =  UIFont(name: "Inter-Bold", size: 14)
                        cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 12)
                        cell.lblStateNaem.font =  UIFont(name: "Inter-Regular", size: 10)
                        cell.lblHr.font =  UIFont(name: "Inter-Regular", size: 12)
                        cell.imgHeight.constant = 32
                        cell.imgWidth.constant = 32
                        cell.imgUSer.layer.cornerRadius = cell.imgUSer.frame.size.height / 2
                        cell.imgUSer.clipsToBounds = true
                        cell.lblRunningBy.font = UIFont(name: "Inter-Bold", size: 12)

                    }
                    else
                    {
                        cell.lblName.font =  UIFont(name: "Inter-Bold", size: 20)
                        cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 16)
                        cell.lblStateNaem.font =  UIFont(name: "Inter-Regular", size: 10)
                        cell.lblHr.font =  UIFont(name: "Inter-Regular", size: 14)
                        cell.lblRunningBy.font = UIFont(name: "Inter-Bold", size: 16)

                        cell.imgHeight.constant = 60
                        cell.imgWidth.constant = 60
                        cell.imgUSer.layer.cornerRadius = 30
                        cell.imgUSer.clipsToBounds = true
                    }
                   
                    let last2 = String(self.cntrollersList[indexPath.row].progress.suffix(2))
                    if last2 == "00"
                    {
                        if self.cntrollersList[indexPath.row].progress == "0.00" || self.cntrollersList[indexPath.row].progress == "0.0" || self.cntrollersList[indexPath.row].progress == "0"
                        {
                            cell.lblHr.text = "0%"
                        }
                        else
                        {
                            let first2 = Int(Double(self.cntrollersList[indexPath.row].progress)!)
                            cell.lblHr.text = String(first2) + "%"
                        }
                        
                    }
                    else
                    {
                        cell.lblHr.text = self.cntrollersList[indexPath.row].progress + "%"
                    }
                    
                    cell.lblRunningBy.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                    
                    cell.lblRunningBy.text = self.cntrollersList[indexPath.row].operatorName.capitalized
                    
                    let imgUrl = self.cntrollersList[indexPath.row].img//.replacingOccurrences(of: "http", with: "https")

                    let imgPath = (imgUrl as AnyObject).replacingOccurrences(of: "'\'", with: "").stringByAddingPercentEncodingForRFC3986()
                                       if(imgPath != nil && imgPath != ""){
                                           cell.imgUSer.kf.setImage(
                                               with: URL(string: imgPath ?? ""),
                                               placeholder: UIImage(named: "rechargeGobblyLogo"),
                                               options: nil){
                                                   result in
                                                   switch result {
                                                   case .success(_):
                                                       cell.imgUSer.contentMode = .scaleAspectFill;
                                                       
                                                   case .failure(_):
                                                       cell.imgUSer.contentMode = .scaleAspectFill;
                                                   }
                                           }
                                       }
                    
                    cell.btnToggel.addTarget(self, action: #selector(tapToggele(button:)), for: .touchUpInside)
                    cell.btnMsg.addTarget(self, action: #selector(tapMessage(button:)), for: .touchUpInside)

                    if self.cntrollersList[indexPath.row].alarm_sub == 1
                    {
                        cell.imgBell.image = UIImage(named: "bell")
                    }
                    else
                    {
                        cell.imgBell.image = UIImage(named: "sBell")
                    }
                    
                    
                    return cell
                }
            }
            else if state == "2"
            {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeMachineCell", for: indexPath) as? homeMachineCell{
                    
                    cell.layer.cornerRadius = 5
                    cell.clipsToBounds = true
                    
                    cell.imgUSer.layer.cornerRadius = cell.imgUSer.frame.size.height / 2
                    cell.imgUSer.clipsToBounds = true
                    
                    cell.stateView.layer.cornerRadius = 8
                    cell.stateView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
                    cell.stateView.clipsToBounds = true
                    cell.imgMsg.image = cell.imgMsg.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgMsg.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
                    
                    cell.imgBell.image = cell.imgBell.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgBell.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
                    cell.bellView.layer.cornerRadius = 13
                    cell.bellView.clipsToBounds = true
                    
                    cell.msgView.layer.cornerRadius = cell.msgView.frame.size.height / 2
                    cell.msgView.clipsToBounds = true
                    cell.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                    cell.lblName.font =  UIFont(name: "Inter-Bold", size: 14)
                    cell.lblName.text = self.cntrollersList[indexPath.row].name
                    cell.lblStateNaem.font =  UIFont(name: "Inter-Regular", size: 10)

                    cell.lblMCode.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                    cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 12)
                    cell.lblMCode.text = self.cntrollersList[indexPath.row].model + "-" + self.cntrollersList[indexPath.row].serial
                    
                    cell.lblCircle.layer.cornerRadius = cell.lblCircle.frame.size.height / 2
                    cell.lblCircle.clipsToBounds = true
                    cell.lblHr.font =  UIFont(name: "Inter-Regular", size: 12)
                    
                    let last2 = String(self.cntrollersList[indexPath.row].progress.suffix(2))
                    if last2 == "00"
                    {
                        if self.cntrollersList[indexPath.row].progress == "0.00" || self.cntrollersList[indexPath.row].progress == "0.0" || self.cntrollersList[indexPath.row].progress == "0"
                        {
                            cell.lblHr.text = "0%"
                        }
                        else
                        {
                            let first2 = Int(Double(self.cntrollersList[indexPath.row].progress)!)
                            cell.lblHr.text = String(first2) + "%"
                        }
                    }
                    else
                    {
                        cell.lblHr.text = self.cntrollersList[indexPath.row].progress + "%"
                    }
                    
                     
                    cell.lblRunningBy.font = UIFont(name: "Inter-Bold", size: 12)
                    cell.lblRunningBy.text = self.cntrollersList[indexPath.row].operatorName.capitalized
                    cell.lblRunningBy.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)

                    
                    cell.btnToggel.addTarget(self, action: #selector(tapToggele(button:)), for: .touchUpInside)
                    cell.btnMsg.addTarget(self, action: #selector(tapMessage(button:)), for: .touchUpInside)
                    let imgUrl = self.cntrollersList[indexPath.row].img//.replacingOccurrences(of: "http", with: "https")

                    let imgPath = (imgUrl as AnyObject).replacingOccurrences(of: "'\'", with: "").stringByAddingPercentEncodingForRFC3986()
                           if(imgPath != nil && imgPath != ""){
                               cell.imgUSer.kf.setImage(
                                   with: URL(string: imgPath ?? ""),
                                   placeholder: UIImage(named: "rechargeGobblyLogo"),
                                   options: nil){
                                       result in
                                       switch result {
                                       case .success(_):
                                           cell.imgUSer.contentMode = .scaleAspectFill;
                                           
                                       case .failure(_):
                                           cell.imgUSer.contentMode = .scaleAspectFill;
                                       }
                               }
                           }
                    
                    if self.cntrollersList[indexPath.row].alarm_sub == 1
                    {
                        cell.imgBell.image = UIImage(named: "bell")
                    }
                    else
                    {
                        cell.imgBell.image = UIImage(named: "sBell")
                    }
                    
                    if Device.IS_IPHONE
                    {
                        cell.lblName.font =  UIFont(name: "Inter-Bold", size: 14)
                        cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 12)
                        cell.lblStateNaem.font =  UIFont(name: "Inter-Regular", size: 10)
                        cell.lblHr.font =  UIFont(name: "Inter-Regular", size: 12)
                        cell.imgHeight.constant = 32
                        cell.imgWidth.constant = 32
                        cell.imgUSer.layer.cornerRadius = cell.imgUSer.frame.size.height / 2
                        cell.imgUSer.clipsToBounds = true
                        cell.lblRunningBy.font = UIFont(name: "Inter-Bold", size: 12)

                    }
                    else
                    {
                        cell.lblName.font =  UIFont(name: "Inter-Bold", size: 20)
                        cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 16)
                        cell.lblStateNaem.font =  UIFont(name: "Inter-Regular", size: 10)
                        cell.lblHr.font =  UIFont(name: "Inter-Regular", size: 14)
                        cell.lblRunningBy.font = UIFont(name: "Inter-Bold", size: 16)

                        cell.imgHeight.constant = 60
                        cell.imgWidth.constant = 60
                        cell.imgUSer.layer.cornerRadius = 30
                        cell.imgUSer.clipsToBounds = true
                    }
                    
                    
                    
                    return cell
                }
            }
            else if state == "3"
            {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offlineCollCell", for: indexPath) as? offlineCollCell{
                                
                    cell.layer.cornerRadius = 5
                    cell.clipsToBounds = true
                    
                    cell.imgUSer.layer.cornerRadius = cell.imgUSer.frame.size.height / 2
                    cell.imgUSer.clipsToBounds = true
                    
                    
                    cell.stateView.layer.cornerRadius = 8
                    cell.stateView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner] // Top right corner, Top left corner respectively
                    cell.stateView.clipsToBounds = true
                    
                    
                    cell.imgMsg.image = cell.imgMsg.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgMsg.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
                    
                    cell.imgBell.image = cell.imgBell.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgBell.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
                    
                    cell.bellView.layer.cornerRadius = 13
                    cell.bellView.clipsToBounds = true
                    
                    cell.msgView.layer.cornerRadius = cell.msgView.frame.size.height / 2
                    cell.msgView.clipsToBounds = true
                    cell.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                    cell.lblName.font =  UIFont(name: "Inter-Bold", size: 14)
                    cell.lblName.text = self.cntrollersList[indexPath.row].name
                    
                    cell.lblMCode.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                    cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 12)
                    cell.lblMCode.text = self.cntrollersList[indexPath.row].model + "-" + self.cntrollersList[indexPath.row].serial
                    
                    cell.lblStateNaem.font =  UIFont(name: "Inter-Regular", size: 10)
                    cell.lblCircle.layer.cornerRadius = cell.lblCircle.frame.size.height / 2
                    cell.lblCircle.clipsToBounds = true
                    cell.lblHr.font =  UIFont(name: "Inter-Regular", size: 12)

                    
                    let last2 = String(self.cntrollersList[indexPath.row].progress.suffix(2))
                    if last2 == "00"
                    {
                        if self.cntrollersList[indexPath.row].progress == "0.00" || self.cntrollersList[indexPath.row].progress == "0.0" || self.cntrollersList[indexPath.row].progress == "0"
                        {
                            cell.lblHr.text = "0%"
                        }
                        else
                        {
                            let first2 = Int(Double(self.cntrollersList[indexPath.row].progress)!)
                            cell.lblHr.text = String(first2) + "%"
                        }
                    }
                    else
                    {
                        cell.lblHr.text = self.cntrollersList[indexPath.row].progress + "%"
                    }
                    
                    
                    cell.lblRunningBy.font = UIFont(name: "Inter-Bold", size: 12)
                    cell.lblRunningBy.text = self.cntrollersList[indexPath.row].operatorName.capitalized
                    cell.lblRunningBy.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)

                    
                    cell.btnToggel.addTarget(self, action: #selector(tapToggele(button:)), for: .touchUpInside)
                    cell.btnMsg.addTarget(self, action: #selector(tapMessage(button:)), for: .touchUpInside)
                    let imgUrl = self.cntrollersList[indexPath.row].img//.replacingOccurrences(of: "http", with: "https")

                    let imgPath = (imgUrl as AnyObject).replacingOccurrences(of: "'\'", with: "").stringByAddingPercentEncodingForRFC3986()
                           if(imgPath != nil && imgPath != ""){
                               cell.imgUSer.kf.setImage(
                                   with: URL(string: imgPath ?? ""),
                                   placeholder: UIImage(named: "rechargeGobblyLogo"),
                                   options: nil){
                                       result in
                                       switch result {
                                       case .success(_):
                                           cell.imgUSer.contentMode = .scaleAspectFill;
                                           
                                       case .failure(_):
                                           cell.imgUSer.contentMode = .scaleAspectFill;
                                       }
                               }
                           }
                    
                    if self.cntrollersList[indexPath.row].alarm_sub == 1
                    {
                        cell.imgBell.image = UIImage(named: "bell")
                    }
                    else
                    {
                        cell.imgBell.image = UIImage(named: "sBell")
                    }
                    
                    
                    if Device.IS_IPHONE
                    {
                        cell.lblName.font =  UIFont(name: "Inter-Bold", size: 14)
                        cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 12)
                        cell.lblStateNaem.font =  UIFont(name: "Inter-Regular", size: 10)
                        cell.lblHr.font =  UIFont(name: "Inter-Regular", size: 12)
                        cell.imgHeight.constant = 32
                        cell.imgWidth.constant = 32
                        cell.imgUSer.layer.cornerRadius = cell.imgUSer.frame.size.height / 2
                        cell.imgUSer.clipsToBounds = true
                        cell.lblRunningBy.font = UIFont(name: "Inter-Bold", size: 12)

                    }
                    else
                    {
                        cell.lblName.font =  UIFont(name: "Inter-Bold", size: 20)
                        cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 16)
                        cell.lblStateNaem.font =  UIFont(name: "Inter-Regular", size: 10)
                        cell.lblHr.font =  UIFont(name: "Inter-Regular", size: 14)
                        cell.lblRunningBy.font = UIFont(name: "Inter-Bold", size: 16)

                        cell.imgHeight.constant = 60
                        cell.imgWidth.constant = 60
                        cell.imgUSer.layer.cornerRadius = 30
                        cell.imgUSer.clipsToBounds = true
                    }
                    
                    
                    return cell
                }
            }
            else if state == "4"
            {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "alermCollCell", for: indexPath) as? alermCollCell{
                              
                      cell.layer.cornerRadius = 5
                      cell.clipsToBounds = true
                    
                      cell.imgUSer.layer.cornerRadius = cell.imgUSer.frame.size.height / 2
                      cell.imgUSer.clipsToBounds = true
                    
                    
                        cell.stateView.layer.cornerRadius = 8
                        cell.stateView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner] // Top right corner, Top left corner respectively
                        cell.stateView.clipsToBounds = true
                    
                      cell.imgMsg.image = cell.imgMsg.image?.withRenderingMode(.alwaysTemplate)
                      cell.imgMsg.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
                      
                      cell.imgBell.image = cell.imgBell.image?.withRenderingMode(.alwaysTemplate)
                      cell.imgBell.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
                      
                      cell.lblHr.text = AppUtils.getAlertTypeMessage(valueAlert: self.cntrollersList[indexPath.row].alarm_type)
                    
                      cell.bellView.layer.cornerRadius = 13
                      cell.bellView.clipsToBounds = true
                      
                      cell.msgView.layer.cornerRadius = cell.msgView.frame.size.height / 2
                      cell.msgView.clipsToBounds = true
                      cell.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                      cell.lblName.font =  UIFont(name: "Inter-Bold", size: 14)
                      cell.lblName.text = self.cntrollersList[indexPath.row].name
                    
                      cell.lblMCode.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                      cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 12)
                      cell.lblMCode.text = self.cntrollersList[indexPath.row].model + "-" + self.cntrollersList[indexPath.row].serial
                      
                      cell.lblStateNaem.font =  UIFont(name: "Inter-Regular", size: 10)
                      cell.lblCircle.layer.cornerRadius = cell.lblCircle.frame.size.height / 2
                      cell.lblCircle.clipsToBounds = true
                      cell.lblHr.font =  UIFont(name: "Inter-Regular", size: 12)

                    let last2 = String(self.cntrollersList[indexPath.row].progress.suffix(2))
                    if last2 == "00"
                    {
                        if self.cntrollersList[indexPath.row].progress == "0.00" || self.cntrollersList[indexPath.row].progress == "0.0" || self.cntrollersList[indexPath.row].progress == "0"
                        {
                            cell.lblHr.text = "0%"
                        }
                        else
                        {
                            let first2 = Int(Double(self.cntrollersList[indexPath.row].progress)!)
                            cell.lblHr.text = String(first2) + "%"
                        }
                    }
                    else
                    {
                        cell.lblHr.text = self.cntrollersList[indexPath.row].progress + "%"
                    }
                    
                   
                    cell.lblRunningBy.font = UIFont(name: "Inter-Bold", size: 12)
                    cell.lblRunningBy.text = self.cntrollersList[indexPath.row].operatorName.capitalized
                    cell.lblRunningBy.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)

                    
                      cell.btnToggel.addTarget(self, action: #selector(tapToggele(button:)), for: .touchUpInside)
                      cell.btnMsg.addTarget(self, action: #selector(tapMessage(button:)), for: .touchUpInside)
                    let imgUrl = self.cntrollersList[indexPath.row].img//.replacingOccurrences(of: "http", with: "https")

                    let imgPath = (imgUrl as AnyObject).replacingOccurrences(of: "'\'", with: "").stringByAddingPercentEncodingForRFC3986()
                           if(imgPath != nil && imgPath != ""){
                               cell.imgUSer.kf.setImage(
                                   with: URL(string: imgPath ?? ""),
                                   placeholder: UIImage(named: "rechargeGobblyLogo"),
                                   options: nil){
                                       result in
                                       switch result {
                                       case .success(_):
                                           cell.imgUSer.contentMode = .scaleAspectFill;
                                           
                                       case .failure(_):
                                           cell.imgUSer.contentMode = .scaleAspectFill;
                                       }
                               }
                           }
                    
                    if self.cntrollersList[indexPath.row].alarm_sub == 1
                    {
                        cell.imgBell.image = UIImage(named: "bell")
                    }
                    else
                    {
                        cell.imgBell.image = UIImage(named: "sBell")
                    }
                    
                    if Device.IS_IPHONE
                    {
                        cell.lblName.font =  UIFont(name: "Inter-Bold", size: 14)
                        cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 12)
                        cell.lblStateNaem.font =  UIFont(name: "Inter-Regular", size: 10)
                        cell.lblHr.font =  UIFont(name: "Inter-Regular", size: 12)
                        cell.imgHeight.constant = 32
                        cell.imgWidth.constant = 32
                        cell.imgUSer.layer.cornerRadius = cell.imgUSer.frame.size.height / 2
                        cell.imgUSer.clipsToBounds = true
                        cell.lblRunningBy.font = UIFont(name: "Inter-Bold", size: 12)

                    }
                    else
                    {
                        cell.lblName.font =  UIFont(name: "Inter-Bold", size: 20)
                        cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 16)
                        cell.lblStateNaem.font =  UIFont(name: "Inter-Regular", size: 10)
                        cell.lblHr.font =  UIFont(name: "Inter-Regular", size: 14)
                        cell.lblRunningBy.font = UIFont(name: "Inter-Bold", size: 16)

                        cell.imgHeight.constant = 60
                        cell.imgWidth.constant = 60
                        cell.imgUSer.layer.cornerRadius = 30
                        cell.imgUSer.clipsToBounds = true
                    }
                    
                    
                    
                      return cell
                  }
            }
            else
            {
                // unsubscrible
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeOfflineCell", for: indexPath) as? homeOfflineCell{
                                
                    cell.layer.cornerRadius = 5
                    cell.clipsToBounds = true
                   
                    cell.imgUSer.layer.cornerRadius = cell.imgUSer.frame.size.height / 2
                    cell.imgUSer.clipsToBounds = true
                    
                    
                    cell.imgMsg.image = cell.imgMsg.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgMsg.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
                    
                    cell.imgBell.image = cell.imgBell.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgBell.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
                    
                    cell.bellView.layer.cornerRadius = 13
                    cell.bellView.clipsToBounds = true
                    
                    cell.msgView.layer.cornerRadius = cell.msgView.frame.size.height / 2
                    cell.msgView.clipsToBounds = true
                    cell.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                    cell.lblName.font =  UIFont(name: "Inter-Bold", size: 14)
                    cell.lblName.text = self.cntrollersList[indexPath.row].name
                    
                    cell.lblMCode.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                    cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 12)
                    cell.lblMCode.text = self.cntrollersList[indexPath.row].model + "-" + self.cntrollersList[indexPath.row].serial
                    
                    cell.btnToggel.addTarget(self, action: #selector(tapToggele(button:)), for: .touchUpInside)
                    cell.btnMSg.addTarget(self, action: #selector(tapMessage(button:)), for: .touchUpInside)
                    cell.btnToggel.isUserInteractionEnabled = false

                    if self.cntrollersList[indexPath.row].is_sub == 1
                    {
                        cell.imgBell.image = UIImage(named: "bell")
                    }
                    else
                    {
                        cell.imgBell.image = UIImage(named: "sBell")
                    }
                    
                    if Device.IS_IPHONE
                    {
                        cell.lblName.font =  UIFont(name: "Inter-Bold", size: 14)
                        cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 12)
                        cell.imgHeight.constant = 32
                        cell.imgWidth.constant = 32
                        cell.imgUSer.layer.cornerRadius = cell.imgUSer.frame.size.height / 2
                        cell.imgUSer.clipsToBounds = true

                    }
                    else
                    {
                        cell.lblName.font =  UIFont(name: "Inter-Bold", size: 20)
                        cell.lblMCode.font =  UIFont(name: "Inter-Regular", size: 16)

                        cell.imgHeight.constant = 60
                        cell.imgWidth.constant = 60
                        cell.imgUSer.layer.cornerRadius = 30
                        cell.imgUSer.clipsToBounds = true
                    }
                    
                    
                    return cell
                }
            }
            
            
            return UICollectionViewCell()
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC{
            vc.serialNumber = self.cntrollersList[indexPath.row].serial
            vc.toggelStatus = self.cntrollersList[indexPath.row].alarm_sub
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // MARK: - UITableView Delegate & Datasource ---------
    
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.cntrollersList.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         
         let state = self.cntrollersList[indexPath.row].state
         if state == "1"
         {
             if let cell = tableView.dequeueReusableCell(withIdentifier: "idlemachineCell", for: indexPath) as? idlemachineCell
             {
                 
                 cell.lblName.text = self.cntrollersList[indexPath.row].name
                 cell.lblStatus.text = self.cntrollersList[indexPath.row].model + "-" + self.cntrollersList[indexPath.row].serial
                 
                 cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2
                 cell.imgProfile.clipsToBounds = true
                 
                 let last2 = String(self.cntrollersList[indexPath.row].progress.suffix(2))
                 if last2 == "00"
                 {
                     if self.cntrollersList[indexPath.row].progress == "0.00" || self.cntrollersList[indexPath.row].progress == "0.0" || self.cntrollersList[indexPath.row].progress == "0"
                     {
                         cell.lblMachineAlert.text = "0%"
                     }
                     else
                     {
                         let first2 = Int(Double(self.cntrollersList[indexPath.row].progress)!)
                         cell.lblMachineAlert.text = String(first2) + "%"
                     }
                 }
                 else
                 {
                     cell.lblMachineAlert.text = self.cntrollersList[indexPath.row].progress + "%"
                 }
                 
                
                 cell.lblMachineAlert.font =  UIFont(name: "Inter-Regular", size: 12)
                 cell.lblMachineAlert.textColor = UIColor.init(red: 198.0/255.0, green: 149.0/255.0, blue: 24.0/255.0, alpha: 1.0)

                 cell.lblDetails.text = self.cntrollersList[indexPath.row].operatorName.capitalized
                 
                 cell.btnMsg.addTarget(self, action: #selector(tapMessageTbl(button:)), for: .touchUpInside)
                 cell.btnToggel.addTarget(self, action: #selector(tapToggelONOFF(button:)), for: .touchUpInside)
                 let imgUrl = self.cntrollersList[indexPath.row].img//.replacingOccurrences(of: "http", with: "https")

                 
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
                 
                 if self.cntrollersList[indexPath.row].alarm_sub == 1
                 {
                     cell.imgBell.image = UIImage(named: "bell")
                 }
                 else
                 {
                     cell.imgBell.image = UIImage(named: "sBell")
                 }
                 
                 return cell
             }
         }
         else if state == "2"
         {
             if let cell = tableView.dequeueReusableCell(withIdentifier: "machineCell", for: indexPath) as? machineCell {
                 
                 cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2
                 cell.imgProfile.clipsToBounds = true
                 
                 cell.btnMsg.addTarget(self, action: #selector(tapMessageTbl(button:)), for: .touchUpInside)
                 cell.lblName.text = self.cntrollersList[indexPath.row].name
                 cell.lblStatus.text = self.cntrollersList[indexPath.row].model + "-" + self.cntrollersList[indexPath.row].serial
                 
                 let last2 = String(self.cntrollersList[indexPath.row].progress.suffix(2))
                 if last2 == "00"
                 {
                     if self.cntrollersList[indexPath.row].progress == "0.00" || self.cntrollersList[indexPath.row].progress == "0.0" || self.cntrollersList[indexPath.row].progress == "0"
                     {
                         cell.lblMachineAlert.text = "0%"
                     }
                     else
                     {
                         let first2 = Int(Double(self.cntrollersList[indexPath.row].progress)!)
                         cell.lblMachineAlert.text = String(first2) + "%"
                     }
                 }
                 else
                 {
                     cell.lblMachineAlert.text = self.cntrollersList[indexPath.row].progress + "%"
                 }
                 
               
                 cell.lblMachineAlert.font =  UIFont(name: "Inter-Regular", size: 12)
                 cell.lblMachineAlert.textColor = UIColor.init(red: 198.0/255.0, green: 149.0/255.0, blue: 24.0/255.0, alpha: 1.0)
                 
                 cell.lblDetails.text = self.cntrollersList[indexPath.row].operatorName.capitalized
                 
                
                 cell.btnMsg.addTarget(self, action: #selector(tapMessageTbl(button:)), for: .touchUpInside)
                 cell.btnToggel.addTarget(self, action: #selector(tapToggelONOFF(button:)), for: .touchUpInside)
                 let imgUrl = self.cntrollersList[indexPath.row].img//.replacingOccurrences(of: "http", with: "https")

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
                 
                 if self.cntrollersList[indexPath.row].alarm_sub == 1
                 {
                     cell.imgBell.image = UIImage(named: "bell")
                 }
                 else
                 {
                     cell.imgBell.image = UIImage(named: "sBell")
                 }
                 
                  return cell
              }
             
         }
         else if state == "3"
         {
             if let cell = tableView.dequeueReusableCell(withIdentifier: "newOfflineCell", for: indexPath) as? newOfflineCell {
                 
                 cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2
                 cell.imgProfile.clipsToBounds = true
                 
                 
                 cell.btnMsg.addTarget(self, action: #selector(tapMessageTbl(button:)), for: .touchUpInside)
                 cell.lblName.text = self.cntrollersList[indexPath.row].name
                 cell.lblStatus.text = self.cntrollersList[indexPath.row].model + "-" + self.cntrollersList[indexPath.row].serial
                 
                 
                 let last2 = String(self.cntrollersList[indexPath.row].progress.suffix(2))
                 if last2 == "00"
                 {
                     if self.cntrollersList[indexPath.row].progress == "0.00" || self.cntrollersList[indexPath.row].progress == "0.0" || self.cntrollersList[indexPath.row].progress == "0"
                     {
                         cell.lblMachineAlert.text = "0%"
                     }
                     else
                     {
                         let first2 = Int(Double(self.cntrollersList[indexPath.row].progress)!)
                         cell.lblMachineAlert.text = String(first2) + "%"
                     }
                 }
                 else
                 {
                     cell.lblTime.text = self.cntrollersList[indexPath.row].progress + "%"
                 }
                 
               
                 cell.lblTime.font =  UIFont(name: "Inter-Regular", size: 12)
                 cell.lblTime.textColor = UIColor.init(red: 198.0/255.0, green: 149.0/255.0, blue: 24.0/255.0, alpha: 1.0)
                 
                 cell.lblDetails.text = self.cntrollersList[indexPath.row].operatorName.capitalized
                 
                 
                 cell.btnMsg.addTarget(self, action: #selector(tapMessageTbl(button:)), for: .touchUpInside)
                 cell.btnToggel.addTarget(self, action: #selector(tapToggelONOFF(button:)), for: .touchUpInside)

                 let imgUrl = self.cntrollersList[indexPath.row].img//.replacingOccurrences(of: "http", with: "https")

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
                 
                 if self.cntrollersList[indexPath.row].alarm_sub == 1
                 {
                     cell.imgBell.image = UIImage(named: "bell")
                 }
                 else
                 {
                     cell.imgBell.image = UIImage(named: "sBell")
                 }
                  return cell
              }
         }
         else if state == "4"
         {
             if let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as? alertCell {
                 cell.btnMsg.addTarget(self, action: #selector(tapMessageTbl(button:)), for: .touchUpInside)
                 cell.lblName.text = self.cntrollersList[indexPath.row].name
                 cell.lblStatus.text = self.cntrollersList[indexPath.row].model + "-" + self.cntrollersList[indexPath.row].serial
                 
                 cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height / 2
                 cell.imgProfile.clipsToBounds = true
                 
                 let last2 = String(self.cntrollersList[indexPath.row].progress.suffix(2))
                 if last2 == "00"
                 {
                     if self.cntrollersList[indexPath.row].progress == "0.00" || self.cntrollersList[indexPath.row].progress == "0.0" || self.cntrollersList[indexPath.row].progress == "0"
                     {
                         cell.lblMachineAlert.text = "0%"
                     }
                     else
                     {
                         let first2 = Int(Double(self.cntrollersList[indexPath.row].progress)!)
                         cell.lblMachineAlert.text = String(first2) + "%"
                     }
                 }
                 else
                 {
                     cell.lblMachineAlert.text = self.cntrollersList[indexPath.row].progress + "%"
                 }
                 

                 cell.lblMachineAlert.font =  UIFont(name: "Inter-Regular", size: 12)
                 cell.lblMachineAlert.textColor = UIColor.init(red: 198.0/255.0, green: 149.0/255.0, blue: 24.0/255.0, alpha: 1.0)
                 
                 cell.lblDetails.text = self.cntrollersList[indexPath.row].operatorName.capitalized

                 cell.btnMsg.addTarget(self, action: #selector(tapMessageTbl(button:)), for: .touchUpInside)
                 cell.btnToggel.addTarget(self, action: #selector(tapToggelONOFF(button:)), for: .touchUpInside)

                 let imgUrl = self.cntrollersList[indexPath.row].img//.replacingOccurrences(of: "http", with: "https")

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
                 
                 if self.cntrollersList[indexPath.row].alarm_sub == 1
                 {
                     cell.imgBell.image = UIImage(named: "bell")
                 }
                 else
                 {
                     cell.imgBell.image = UIImage(named: "sBell")
                 }
                 
                  return cell
            }
         }
         else
         {
             // unsubscrible
             if let cell = tableView.dequeueReusableCell(withIdentifier: "offllineCell", for: indexPath) as? offllineCell {
                 cell.lblName.text = self.cntrollersList[indexPath.row].name
                 cell.lblStatus.text = self.cntrollersList[indexPath.row].model
                 // Create String
                 cell.btnToggel.isUserInteractionEnabled = false
                 cell.btnMsg.isUserInteractionEnabled = false

                return cell
            }
            
         }
         
         
        return UITableViewCell()
    }

    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let state = self.cntrollersList[indexPath.row].state
         if state == "1" || state == "2" ||  state == "3" || state == "4"
         {
             return 135
         }
         else
         {
             return 126
         }
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC{
             vc.serialNumber = self.cntrollersList[indexPath.row].serial
             vc.toggelStatus = self.cntrollersList[indexPath.row].alarm_sub
             self.navigationController?.pushViewController(vc, animated: true)
         }
    }
    
    func getIndexPathFor(view: UIView, tableView: UITableView) -> IndexPath? {
        let point = tableView.convert(view.bounds.origin, from: view)
        let indexPath = tableView.indexPathForRow(at: point)
        return indexPath
      }
       
       
       @objc func tapToggelONOFF(button : UIButton)
       {
           if !Reachability.isConnectedToNetwork()
           {
               let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                  
               }))
               self.present(alert, animated: true, completion: nil)
               return
           }
           
           let index = self.getIndexPathFor(view: button, tableView: self.tblView)
           var setAlrm : Int = 0
           setAlrm = self.cntrollersList[index!.row].alarm_sub
           if setAlrm == 0
           {
               setAlrm = 1
           }
           else
           {
               setAlrm = 0
           }
           let dict = ["serial" : self.cntrollersList[index!.row].serial,"alarm" : String(setAlrm)]
           self.viewModel.setAlertState(dictDat: dict as NSDictionary, viewController: self) { errorMessage, msg in
               if errorMessage == "Success"
               {
                   //self.view.makeToast(msg)

                   if setAlrm == 1
                   {
                       self.otherView.isHidden = false
                   }
                   else
                   {
                       self.otherView.isHidden = true
                   }
                   self.getServiceforControllersList()
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
    
    @objc func tapMessageTbl(button : UIButton)
    {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let index = self.getIndexPathFor(view: button, tableView: self.tblView)

        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MesageVC") as? MesageVC{
            vc.isFromHome = true
            vc.strSerialNumber = String(self.cntrollersList[index!.row].serial)
            vc.strName = self.cntrollersList[index!.row].name
            vc.serialNumber = self.cntrollersList[index!.row].model + "-" + self.cntrollersList[index!.row].serial
            let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
            myAppDelegate.isFromMsg = true
            myAppDelegate.strName = self.cntrollersList[index!.row].name
            myAppDelegate.serialNumber = String(self.cntrollersList[index!.row].serial)
            myAppDelegate.model = self.cntrollersList[index!.row].model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))hr"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension HomeVC: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        print("check")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("Uncheck")
    }

    
    // Optional ssl CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        TRACE("trust: \(trust)")
        completionHandler(true)
    }
    
    func ccSha256(data: Data) -> Data {
        var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))

        _ = digest.withUnsafeMutableBytes { (digestBytes) in
            data.withUnsafeBytes { (stringBytes) in
                CC_SHA256(stringBytes, CC_LONG(data.count), digestBytes)
            }
        }
        return digest
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        let pToken = UserDefaults.standard.object(forKey: "token") as? String
        let str = pToken!
        let data = ccSha256(data: str.data(using: .utf8)!)
        let key256Sha = "\(data.map { String(format: "%02hhx", $0) }.joined())"
        print("sha256 String: \(key256Sha)")

        
        let topic = "massoRoot/" + key256Sha + "/#"
        print(topic)
        self.mqtt!.subscribe(topic)
        TRACE("ack: \(ack)")
    }
    
    
    
    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        TRACE("new state: \(state)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        TRACE("message: \(message.string!.description), id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        TRACE("id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        TRACE("message: \(message.string!.description), id: \(id)")
        print("Message received in topic \(message.topic) with payload \(message.string!)")
        print((message.string!.description))
        let dict = self.convertToDictionary(text: (message.string!.description))
        let convertedDict = dict as? NSDictionary
        print(convertedDict)
        if convertedDict?.count == 1
        {
            return
        }
        self.dicrDta = (convertedDict! as? NSDictionary)!
        let arrayList = self.dicrDta.object(forKey: "data") as? NSArray
        let updatedDict = arrayList![0] as? NSDictionary
        
        print(self.dicrDta)
        
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: self.dicrDta)
        
        let machineNAme = updatedDict!.object(forKey: "machine_name") as? String
        print(machineNAme)
        let serial = updatedDict!.object(forKey: "serial") as? Int
        let state = updatedDict!.object(forKey: "state") as? Int
        let operatorName = updatedDict!.object(forKey: "operator_name") as? String
        let alarmType = updatedDict!.object(forKey: "alarm_type") as? Int
        let filename = updatedDict!.object(forKey: "filename") as? String
        let last_response = updatedDict!.object(forKey: "last_response") as? String
        let mName = updatedDict!.object(forKey: "machine_name") as? String
        let parts = updatedDict!.object(forKey: "parts") as? Int
        let progress = updatedDict!.object(forKey: "progress") as? Double

        print(self.cntrollersList.count)
        self.cntrollersList.removeAll()
        self.cntrollersList = self.tempCntrollersList
        var updatedIndex : Int = 0
        for i in 0...(self.cntrollersList.count - 1) {
            var model = self.cntrollersList[i] as? controllersList
            let serialModel = model!.serial
            print(serial)
            print(serialModel)
            if String(serial!) == serialModel
            {
                self.cntrollersList[i].serial = String(serial!)
                self.cntrollersList[i].name = mName!
                self.cntrollersList[i].state = String(state!)
                self.cntrollersList[i].operatorName = operatorName!
                self.cntrollersList[i].progress = String(progress!)
                self.cntrollersList[i].alarm_type = alarmType!
                self.cntrollersList[i].last_response = last_response!
                self.cntrollersList[i].parts = parts!
                self.cntrollersList[i].filename = filename!
               // self.cntrollersList[i].alarm_sub = alaram_sub!
                updatedIndex = i
                
            }
            
        }
        
       
        
        self.tempCntrollersList = self.cntrollersList
        
        if self.selectedTab == "All"
        {
            // do nothing
            if self.cntrollersList.count == 0
            {
                self.collView.isHidden = true
                self.tblView.isHidden = true
                self.noMAchineView.isHidden = false
            }
            else
            {
                if self.selectedMode == "Grid"
                {
                    self.collView.isHidden = false
                    self.tblView.isHidden = true
                }
                else
                {
                    self.collView.isHidden = true
                    self.tblView.isHidden = false
                }
                self.noMAchineView.isHidden = true
            }
        }
        else if self.selectedTab == "Idle"
        {
            self.cntrollersList = self.cntrollersList.filter({(($0.state == "1"))})
            if self.cntrollersList.count == 0
            {
                self.collView.isHidden = true
                self.tblView.isHidden = true
                self.noMAchineView.isHidden = false
            }
            else
            {
                if self.selectedMode == "Grid"
                {
                    self.collView.isHidden = false
                    self.tblView.isHidden = true
                }
                else
                {
                    self.collView.isHidden = true
                    self.tblView.isHidden = false
                }
                self.noMAchineView.isHidden = true
            }
        }
        else if self.selectedTab == "Machine"
        {
            self.cntrollersList = self.cntrollersList.filter({(($0.state == "2"))})
            if self.cntrollersList.count == 0
            {
                self.collView.isHidden = true
                self.tblView.isHidden = true
                self.noMAchineView.isHidden = false
            }
            else
            {
                if self.selectedMode == "Grid"
                {
                    self.collView.isHidden = false
                    self.tblView.isHidden = true
                }
                else
                {
                    self.collView.isHidden = true
                    self.tblView.isHidden = false
                }
                self.noMAchineView.isHidden = true
            }
        }
        else if self.selectedTab == "Alarm"
        {
            self.cntrollersList = self.cntrollersList.filter({(($0.state == "4"))})
            if self.cntrollersList.count == 0
            {
                self.collView.isHidden = true
                self.tblView.isHidden = true
                self.noMAchineView.isHidden = false
            }
            else
            {
                if self.selectedMode == "Grid"
                {
                    self.collView.isHidden = false
                    self.tblView.isHidden = true
                }
                else
                {
                    self.collView.isHidden = true
                    self.tblView.isHidden = false
                }
                self.noMAchineView.isHidden = true
            }
        }
        else if self.selectedTab == "Offline"
        {
            self.cntrollersList = self.cntrollersList.filter({(($0.state == "3"))})
            if self.cntrollersList.count == 0
            {
                self.collView.isHidden = true
                self.tblView.isHidden = true
                self.noMAchineView.isHidden = false
            }
            else
            {
                if self.selectedMode == "Grid"
                {
                    self.collView.isHidden = false
                    self.tblView.isHidden = true
                }
                else
                {
                    self.collView.isHidden = true
                    self.tblView.isHidden = false
                }
                self.noMAchineView.isHidden = true
            }
        }
        
        self.collView.reloadData()
        self.tblView.reloadData()
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        TRACE("subscribed: \(success), failed: \(failed)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        TRACE()
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        TRACE()
        print(mqtt.description)
        print(mqtt.willMessage)
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        TRACE("\(err.debugDescription)")
    }
    
    
}

extension HomeVC {
    func TRACE(_ message: String = "", fun: String = #function) {
        let names = fun.components(separatedBy: ":")
        var prettyName: String
        if names.count == 2 {
            prettyName = names[0]
        } else {
            prettyName = names[1]
        }
        
        if fun == "mqttDidDisconnect(_:withError:)" {
            prettyName = "didDisconnect"
        }

        print("[TRACE] [\(prettyName)]: \(message)")
    }
}
