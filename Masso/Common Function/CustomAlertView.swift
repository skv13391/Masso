//
//  CustomAlertView.swift
//  VMConsumer
//
//  Created by Developer on 19/01/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class CustomAlertView: UIView {

    var backgroundLayer = UIView()
    var popupView = UIView();
    var imgView = UIImageView();
    var headingLbl = UILabel();
    var bottomLbl = UILabel();
    var closeBtn = UIButton()
    var msgLbl = UILabel();
    var okBtn = UIButton();
    var cancelBtn = UIButton();
    var viewModel = HomeViewModel()
    var serialNumber = String()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundLayer = UIView(frame: (self.bounds));
        self.backgroundLayer.backgroundColor = UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        self.backgroundLayer.tag = 1331
        self.addSubview(self.backgroundLayer)
    
    }
    

    init(frame:CGRect,seriNo: NSDictionary, title:String,alertType:String,msgToShow:String,buttonsNameDic:[String] = ["OK"]) {
        super.init(frame: frame)
        self.serialNumber = ((seriNo.object(forKey: "serial") as? String)!)
        let per = seriNo.object(forKey: "per") as? String ?? " "
        let model = seriNo.object(forKey: "model") as? String ?? " "
        
        self.backgroundLayer = UIView(frame: (self.bounds));
        self.backgroundLayer.backgroundColor = UIColor.init(red: 19.0/255.0, green: 30.0/255.0, blue: 36.0/255.0, alpha: 0.9)
        self.backgroundLayer.tag = 1331
        self.addSubview(self.backgroundLayer)
    
         let heightOfText = CommonFunctions.sharedInstance.calculateHeight(inString: msgToShow, width:self.frame.width - 80, font: UIFont(name: CustomFont.helveticaRegularFont, size: 15.0)!) + 10
        
        let popUpView = UIView(frame: CGRect(x: 25, y: 100, width: self.frame.width - 100, height: CGFloat(250) + heightOfText))
        popUpView.backgroundColor = UIColor.darkGray
        popUpView.layer.cornerRadius = 5.0
        popUpView.clipsToBounds = true;
        popUpView.center = self.backgroundLayer.center
        self.backgroundLayer.addSubview(popUpView);
        
        closeBtn = UIButton(frame: CGRect(x: popUpView.frame.size.width - 35, y: 20, width: 15, height: 15))
        closeBtn.setBackgroundImage(UIImage(named: "closeNew"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
        popUpView.addSubview(closeBtn);
        
        let imgView = UIImageView(frame: CGRect(x: popUpView.frame.width/2 - 30, y: 25, width: 60, height: 60));
        imgView.image = UIImage(named: "newNoti");
        imgView.contentMode = .center
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
        imgView.clipsToBounds = true
        popUpView.addSubview(imgView);
        
    
         headingLbl = UILabel(frame: CGRect(x: 20, y: imgView.frame.maxY, width: popUpView.frame.width - 40, height: 40));
        if title == "" {
            headingLbl.text = "";
        }else{
            headingLbl.text = title;
        }
        
        headingLbl.textAlignment = .center;
        headingLbl.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        headingLbl.font = UIFont(name: "Inter-Bold", size: 14)
        popUpView.addSubview(headingLbl);

        
        msgLbl = UILabel(frame: CGRect(x: 15, y: headingLbl.frame.maxY, width: popUpView.frame.width - 30, height: heightOfText))
        msgLbl.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        //msgLbl.backgroundColor = color.blueColor
        msgLbl.text = msgToShow;
        msgLbl.textAlignment = .left;
        msgLbl.numberOfLines = 0
        msgLbl.lineBreakMode = .byWordWrapping
        msgLbl.font = UIFont(name: "Inter-Regular", size: 14)
        popUpView.addSubview(msgLbl)
        
        
        bottomLbl = UILabel(frame: CGRect(x: 20, y: msgLbl.frame.maxY, width: popUpView.frame.width - 40, height: 30));
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Inter-Light", size: 14), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
                
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 14), NSAttributedString.Key.foregroundColor : UIColor.init(red: 248.0/255.0, green: 173.0/255.0, blue: 61.0/255.0, alpha: 1.0)]
        
        let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 14), NSAttributedString.Key.foregroundColor : UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)]
                
        let attributedString1 = NSMutableAttributedString(string:model + "-" + self.serialNumber, attributes:attrs1 as [NSAttributedString.Key : Any])
                
        let attributedString2 = NSMutableAttributedString(string:" • ", attributes:attrs3 as [NSAttributedString.Key : Any])
        
         let attributedString3 = NSMutableAttributedString(string:per + "%", attributes:attrs2 as [NSAttributedString.Key : Any])
        
        
            
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)

        bottomLbl.attributedText = attributedString1
        bottomLbl.textAlignment = .center;
        popUpView.addSubview(bottomLbl)
        
        
        okBtn = UIButton(frame: CGRect(x: 30, y: popUpView.frame.height - 75, width: popUpView.frame.width - 60, height: 51))
        okBtn.setTitle("View", for: .normal)
        okBtn.setTitleColor(UIColor.black, for: .normal)
        okBtn.backgroundColor = UIColor.init(red: 255.0/255.0, green: 159.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        okBtn.layer.cornerRadius = 10
        okBtn.clipsToBounds = true
        okBtn.addTarget(self, action: #selector(hideAlert), for: .touchUpInside)
        
        popUpView.addSubview(okBtn)
        
        if buttonsNameDic.count > 1 {
            cancelBtn = UIButton(frame: CGRect(x: popUpView.frame.width - 160, y: popUpView.frame.height - 35, width: 70, height: 30))
            cancelBtn.setTitle(buttonsNameDic[1], for: .normal)
            cancelBtn.setTitleColor(color.themeOrangeColor, for: .normal)
            popUpView.addSubview(cancelBtn)
        }
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func hideAlert()
    {
        self.callServiceForState()
        if let view = UIApplication.shared.keyWindow?.viewWithTag(1000) as? UIView{
            view.removeFromSuperview()
        }
    }
    
    @objc func closeAlert()
    {
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        if let view = UIApplication.shared.keyWindow?.viewWithTag(1000) as? UIView{
            view.removeFromSuperview()
        }
    }
  

    func callServiceForState()
    {
        self.viewModel.getControllersListDetails(id: Int(self.serialNumber)!, viewController: (UIApplication.shared.keyWindow?.rootViewController)!) { errorMessage, msg, list in
            if errorMessage == "Success"
            {
                let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                myAppDelegate.isNoti = true
                self.moveToController(list: list)
            }
            else
            {
            }
        }
    }
    
    func moveToController(list : controllersList)
    {
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let state = list.state
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let window = UIApplication.shared.keyWindow!
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC{
            vc.serialNumber = self.serialNumber
            window.visibleViewController?.navigationController?.pushViewController(vc, animated: true)
        }
        
       

    }
}

