//
//  AppDelegate.swift
//  Masso
//
//  Created by Sunil on 21/03/23.
//

import UIKit
import NotificationCenter
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging
import FirebaseCrashlytics


@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    
    var window: UIWindow?
    var storyboard = UIStoryboard()
    var isFromMsg = Bool()
    var serialNumber = String()
    var model = String()
    var uploadedImage = String()
    var singleList = String()
    var isFromUser = String()
    var strName = String()
    var isNoti : Bool = false
    var isFromLogin : Bool = false
    var isFromPush : Bool = false
    var comingState = String()
    var pushSerialNumber = String()
    var progressFrom = String()
    var presentViewCr = String()
    var dictDetails = NSDictionary()
    var isfromInactiveMode = String()
    var previousSer = String()
    var showSerial = String()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.presentViewCr = "true"
        self.progressFrom = "Machine"
        self.isfromInactiveMode = "false"
        if launchOptions != nil {
           
                // opened from a push notification when the app is closed
                let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable : Any]
                if userInfo != nil {
                    let aps  = userInfo![AnyHashable("aps")] as? NSDictionary
                    let alert = aps!["alert"] as? NSDictionary
                    
                    let data = userInfo![AnyHashable("data")] as? NSDictionary
                    let serial = data!["serial"] as? String
                    
                    let state = data!["dstate"] as? String
                    self.moveToDashboard()
                    UserDefaults.standard.set(aps, forKey: "ter")
                    UserDefaults.standard.set(data, forKey: "term")
                    UserDefaults.standard.synchronize()
                    
                    self.isfromInactiveMode = "true"
                    
                    self.isFromPush = true
                    self.pushSerialNumber = serial!
                    self.comingState = "1"
                   
            }
    }
        else
        {
            if UIDevice.current.userInterfaceIdiom == .phone
            {
                self.storyboard = UIStoryboard(name: "Main", bundle: nil)
            }
            else
            {
                self.storyboard = UIStoryboard(name: "Main_ipad", bundle: nil)
            }
            
            let userActive = UserDefaults.standard.object(forKey: "login") as? String
            if userActive == "false" || userActive == nil
            {
                self.setRootNavigation()
            }
            else
            {
                self.moveToDashboard()
            }
            
            Thread.sleep(forTimeInterval: 2)
            self.window?.overrideUserInterfaceStyle = .light

            FirebaseApp.configure()
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
            Messaging.messaging().delegate = self
            
            

            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
            
            application.registerForRemoteNotifications()
        
        }
        
        
        return true
    }
    
   func moveTODetails()
    {
        
    }
    
    func moveToDashboard()
    {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            guard let rootVC = storyboard.instantiateViewController(identifier: "TabbarContollerViewController") as? TabbarContollerViewController else {
                print("ViewController not found")
                return
            }
            let rootNC = UINavigationController(rootViewController: rootVC)
            rootNC.setNavigationBarHidden(true, animated: true)
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
        } else {
            // Fallback on earlier versions
            let rootVC = storyboard.instantiateViewController(withIdentifier: "TabbarContollerViewController")
            let rootNC = UINavigationController(rootViewController: rootVC)
            rootNC.setNavigationBarHidden(true, animated: true)
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
        }
    }
    
    func moveToAllDashboard()
    {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            guard let rootVC = storyboard.instantiateViewController(identifier: "TabbarContollerViewController") as? TabbarContollerViewController else {
                print("ViewController not found")
                return
            }
            if var viewControllers = rootVC.viewControllers {
                self.window?.rootViewController = viewControllers[0].children[0]
                self.window?.makeKeyAndVisible()
            }
        }
        
    }
    
    func setRootNavigation()
    {
        let navRoot = self.storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
        self.window?.rootViewController = navRoot
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key == "email" ||  key == "pass"
            {
                
            }
            else
            {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    @nonobjc func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    private func application(application: UIApplication,
                             didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication,
                       didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Print full message.
        print(userInfo)
      }

      // [START receive_message]
      func application(_ application: UIApplication,
                       didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
        -> UIBackgroundFetchResult {
        // Print full message.
        print(userInfo)

        return UIBackgroundFetchResult.newData
      }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo.keys)
              
              let aps  = userInfo[AnyHashable("aps")] as? NSDictionary
              let alert = aps!["alert"] as? NSDictionary
              let body = alert!["body"] as? String
              let title = alert!["title"] as? String

        let data = userInfo[AnyHashable("data")] as? NSDictionary

        let serial = data!["serial"] as? String
        let per = data!["percent"] as? String
        let model = data!["model"] as? String
        let state = data!["dstate"] as? String

        if let view = UIApplication.shared.keyWindow?.viewWithTag(1000) as? UIView{
            view.removeFromSuperview()
        }
    
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let window = UIApplication.shared.keyWindow!
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC{
            vc.serialNumber = serial!
            window.visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
        if self.presentViewCr == "true"
        {
            
            let userInfo = notification.request.content.userInfo
                  print(userInfo.keys)
                  
                  let aps  = userInfo[AnyHashable("aps")] as? NSDictionary
                  let alert = aps!["alert"] as? NSDictionary
                  let body = alert!["body"] as? String
                  let title = alert!["title"] as? String

            let data = userInfo[AnyHashable("data")] as? NSDictionary
            if data != nil{
                let serial = data!["serial"] as? String
                let per = data!["percent"] as? String
                let model = data!["model"] as? String
                let dict = ["model" : model,"per" : per,"serial" : serial] as? NSDictionary
                print(dict)
                
                if self.previousSer.count == 0
                {
                    self.previousSer = serial!
                }
                
                if self.previousSer == serial
                {
                    if self.showSerial != self.previousSer
                    {
                        if let view = UIApplication.shared.keyWindow?.viewWithTag(1000) as? UIView{
                            view.removeFromSuperview()
                        }
                        
                        let v2 = CustomAlertView(frame: self.window!.frame,seriNo: dict!, title: title!, alertType: "Notification", msgToShow: body!)
                        v2.tag = 1000
                        self.window!.addSubview(v2)
                    }
                    
                }
                else
                {
                    self.previousSer = serial!
                    if let view = UIApplication.shared.keyWindow?.viewWithTag(1000) as? UIView{
                        view.removeFromSuperview()
                    }
                    
                    let v2 = CustomAlertView(frame: self.window!.frame,seriNo: dict!, title: title!, alertType: "Notification", msgToShow: body!)
                    v2.tag = 1000
                    self.window!.addSubview(v2)
                }
                
               
            }
            
        }
        else
        {
            completionHandler([])
        }
       
    }
    
      // [END receive_message]
      func application(_ application: UIApplication,
                       didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
      }

      // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
      // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
      // the FCM registration token.
      func application(_ application: UIApplication,
                       didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")

        // With swizzling disabled you must set the APNs token here.
         Messaging.messaging().apnsToken = deviceToken
          
          print(Messaging.messaging().apnsToken)
          
          Messaging.messaging().token { token, error in
            if let error = error {
              print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
              print("FCM registration token: \(token)")
             print("Remote FCM registration token: \(token)")
            }
          }

          
      }
        
   
}


extension UINavigationController {

func setStatusBar(backgroundColor: UIColor) {
    let statusBarFrame: CGRect
    if #available(iOS 13.0, *) {
        statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
    } else {
        statusBarFrame = UIApplication.shared.statusBarFrame
    }
    let statusBarView = UIView(frame: statusBarFrame)
    statusBarView.backgroundColor = backgroundColor
    view.addSubview(statusBarView)
}

}

public extension UIWindow {
     var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }

     static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}
