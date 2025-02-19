//
//  TabbarContollerViewController.swift
//  MANBot
//
//  Created by Sanjeev on 12/07/22.
//

import UIKit

class TabbarContollerViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
            //self.tabBarController?.selectedIndex = 0
            self.navigationController?.navigationBar.isHidden = true;
            self.navigationItem.setHidesBackButton(true, animated:false);
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.navigationItem.hidesBackButton = true
            self.delegate = self
            self.tabBar.unselectedItemTintColor = UIColor.white
            self.tabBar.selectedImageTintColor = UIColor.white
            
        
//            if let items = tabBar.items {
//                    // Setting the title text color of all tab bar items:
//                    for item in items {
//                        item.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
//                        item.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
//                    }
//                }
         
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let items = tabBar.items else { return }

        let name = UserDefaults.standard.object(forKey: "name") as? String
        items[2].title = name?.capitalized.trimmingCharacters(in: .whitespaces)
           
    }

  
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
              
              if tabBar.selectedItem?.title == "Devices"
                {
                  
                  guard let vc = self.navigationController?.viewControllers else { return }

                  for controller in vc {
                     if controller.isKind(of: TabbarContollerViewController.self) {
                        let tabVC = controller as! TabbarContollerViewController
                        tabVC.selectedIndex = 0
                        self.navigationController?.popToViewController(tabVC, animated: true)
                     }
                  }
                  let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                  myAppDelegate.isFromMsg = false
              }
              else if tabBar.selectedItem?.title == "Messages"
              {
                  let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                  if myAppDelegate.isNoti == true
                  {
                      myAppDelegate.isNoti = false
                      guard let vc = self.navigationController?.viewControllers else { return }

                      for controller in vc {
                         if controller.isKind(of: TabbarContollerViewController.self) {
                            let tabVC = controller as! TabbarContollerViewController
                            tabVC.selectedIndex = 1
                            self.navigationController?.popToViewController(tabVC, animated: true)
                         }
                      }
                      let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                      myAppDelegate.isFromMsg = false
                  }
                  else
                  {
                     // self.tabBarController?.selectedIndex = 1
                  }
              }
            else
            {
                let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                myAppDelegate.isFromMsg = false
                //self.tabBarController?.selectedIndex = 2
            }
                  
          }
          
   

}
