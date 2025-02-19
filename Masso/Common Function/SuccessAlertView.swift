//
//  SuccessAlertView.swift
//  GobblyWS
//
//  Created by Sanjeev on 04/06/22.
//  Copyright © 2022 Developer. All rights reserved.
//

import UIKit

class SuccessAlertView: UIView {

    var backgroundLayer = UIView()
    var popupView = UIView();
    var imgView = UIImageView();
    var headingLbl = UILabel();
    var msgLbl = UILabel();
    var okBtn = UIButton();
    var cancelBtn = UIButton();
    var lblHeader = UILabel()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame:CGRect, title:String,alertType:String,msgToShow:String,amount : String,buttonsNameDic:[String] = ["Continue"]) {
        super.init(frame: frame)
        
        self.backgroundLayer = UIView(frame: (self.bounds));
        self.backgroundLayer.backgroundColor =  UIColor.init(red: 216/255, green: 212/255, blue: 209/255, alpha: 1.0)
        self.backgroundLayer.tag = 1331
        self.addSubview(self.backgroundLayer)
    
        self.lblHeader = UILabel(frame: CGRect(x: 0, y: 20, width: self.frame.size.width , height: 40))
        self.lblHeader.backgroundColor = UIColor.init(red: 89/255, green: 41/255, blue: 178/255, alpha: 1.0)
        self.lblHeader.text = "Payment Status"
        self.lblHeader.textAlignment = .center
        self.lblHeader.textColor = UIColor.white
        self.addSubview(self.lblHeader)
        
        //self.backgroundColor = UIColor.init(red: 216/255, green: 212/255, blue: 209/255, alpha: 1.0)
        
        let newAmount = Int(amount)! / 100
        let msg = AppUtils.rupeeSymbol + String(newAmount)  + "\n" + msgToShow
        
         let heightOfText = CommonFunctions.sharedInstance.calculateHeight(inString: msg, width:self.frame.width - 80, font: UIFont(name: CustomFont.helveticaRegularFont, size: 15.0)!) + 80
        
        let popUpView = UIView(frame: CGRect(x: 25, y: 100, width: self.frame.width - 50, height: CGFloat(250) + heightOfText))
        popUpView.backgroundColor = UIColor.white
        popUpView.layer.cornerRadius = 5.0
        popUpView.clipsToBounds = true;
        popUpView.center = self.backgroundLayer.center
        popUpView.layer.cornerRadius = 10
        popUpView.layer.borderWidth = 4
        popUpView.layer.borderColor = UIColor.init(red: 89.0/255.0, green: 41.0/255.0, blue: 178.0/255.0, alpha: 1.0).cgColor
        popUpView.clipsToBounds = true
        
        self.backgroundLayer.addSubview(popUpView);
        
        var imgIconName = "thumb"
        
        let alertImg = UIImage(named: "thumb")?.scaleTo(CGSize(width: 160, height: 160))
        
        var defaultTitle = "Alert !"
        switch alertType {
        case AppUtils.Success: imgIconName = "thumb";
        defaultTitle = "Success !"
        break;
        case AppUtils.ErrorTypeTitle :  imgIconName = "thumb"
        defaultTitle = "Alert !"
        break;
        case AlertType.error.rawValue : imgIconName = "thumb"
                                        defaultTitle = "Error !"
        break;
        case AlertType.info.rawValue : imgIconName = "thumb"
                                       defaultTitle = "Info"
        case AlertType.tellus.rawValue:
            imgIconName = "thumb"
            defaultTitle = ""
        break;
            
        default:
        break;
            
        }
      
        if title != "" {
            let imgView = UIImageView(frame: CGRect(x: popUpView.frame.width/2 - 25, y: 20, width:50 , height: 50));
            imgView.image = UIImage(named:"goalIcon");
            imgView.contentMode = .center
            popUpView.addSubview(imgView);
            headingLbl = UILabel(frame: CGRect(x: 20, y: imgView.frame.maxY + 20, width: popUpView.frame.width - 40, height: 40));
            headingLbl.textAlignment = .center;
            headingLbl.textColor = UIColor.init(red: 89.0/255.0, green: 41.0/255.0, blue: 178.0/255.0, alpha: 1.0);
            headingLbl.font = UIFont(name: CustomFont.helveticaRegularFont, size: 17)
            popUpView.addSubview(headingLbl);
            headingLbl.text = title;
            let lineView = UIView(frame: CGRect(x: 0, y: headingLbl.frame.maxY - 5, width: popUpView.frame.width, height: 0.5))
            lineView.backgroundColor = color.line_backgroundColor;
            popUpView.addSubview(lineView)
            msgLbl = UILabel(frame: CGRect(x: 15, y: lineView.frame.maxY + 15, width: popUpView.frame.width - 30, height: heightOfText))
            msgLbl.textColor = UIColor.black;
            msgLbl.text = msg;
            msgLbl.textAlignment = .center;
            msgLbl.numberOfLines = 0
            msgLbl.lineBreakMode = .byWordWrapping
            msgLbl.font = UIFont(name: "Montserrat-Regular", size: 15.0)
            popUpView.addSubview(msgLbl)
        }else{
            let imgView = UIImageView(frame: CGRect(x: popUpView.frame.width/2 - 80, y: 30, width: 160, height: 160));
            imgView.image = alertImg;
            imgView.contentMode = .center
            popUpView.addSubview(imgView);
        
            msgLbl = UILabel(frame: CGRect(x: 15, y: imgView.frame.maxY - 15, width: popUpView.frame.width - 30, height: heightOfText))
            msgLbl.textAlignment = .center;
            msgLbl.numberOfLines = 0
            msgLbl.lineBreakMode = .byWordWrapping
            popUpView.addSubview(msgLbl)
            
            let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Montserrat-Regular", size: 22), NSAttributedString.Key.foregroundColor : UIColor.init(red: 89.0/255.0, green: 41.0/255.0, blue: 178.0/255.0, alpha: 1.0)]

            let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Montserrat-Regular", size: 18), NSAttributedString.Key.foregroundColor : UIColor.darkGray]

            let attributedString1 = NSMutableAttributedString(string: AppUtils.rupeeSymbol +  amount, attributes:attrs1 as [NSAttributedString.Key : Any])

            let attributedString2 = NSMutableAttributedString(string:"\n" + msgToShow, attributes:attrs2 as [NSAttributedString.Key : Any])

            attributedString1.append(attributedString2)
            self.msgLbl.attributedText = attributedString1
            

        }
        
        okBtn = UIButton(frame: CGRect(x: (popUpView.frame.width/2) - 80, y: popUpView.frame.height - 60, width: 160, height: 40))
        okBtn.setTitle(buttonsNameDic[0], for: .normal)
        okBtn.setTitleColor(UIColor.white, for: .normal)
        okBtn.backgroundColor = UIColor.init(red: 89.0/255.0, green: 41.0/255.0, blue: 178.0/255.0, alpha: 1.0)
        okBtn.layer.cornerRadius = okBtn.frame.size.height/2
        okBtn.clipsToBounds = true
        okBtn.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 20.0)
        popUpView.addSubview(okBtn)
        
        if buttonsNameDic.count > 1 {
            cancelBtn = UIButton(frame: CGRect(x: popUpView.frame.width - 180, y: popUpView.frame.height - 40, width: 80, height: 30))
            cancelBtn.setTitle(buttonsNameDic[1], for: .normal)
            cancelBtn.setTitleColor(UIColor.init(red: 89.0/255.0, green: 41.0/255.0, blue: 178.0/255.0, alpha: 1.0), for: .normal)
            popUpView.addSubview(cancelBtn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  

}


// MARK: - Used to scale UIImages
extension UIImage {
    func scaleTo(_ newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
