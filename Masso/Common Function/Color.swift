//
//  File.swift
//  VMConsumer
//
//  Created by Developer on 11/12/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import UIKit

class  color {
    
    
    var colorType = UIColor()
    // for Initial screen
    static let bgColor = UIColor(red: 19.0/255.0, green: 30/255.0, blue: 36/255.0, alpha: 1.0) //UIColor(red: 0/255, green: 85/255.0, blue: 140/255.0, alpha: 1.0);

    static let btnColor = UIColor(red: 255.0/255.0, green: 159.0/255.0, blue: 41/255.0, alpha: 1.0) //UIColor(red: 0/255, green: 85/255.0, blue: 140/255.0, alpha: 1.0);
    
    static let btnActiveColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha: 1.0) //UIColor(red: 0/255, green: 85/255.0, blue: 140/255.0, alpha: 1.0);
    
    static let btnInactiveColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha: 0.6) //UIColor(red: 0/255, green: 85/255.0, blue: 140/255.0, alpha: 1.0);
    
    static let good = UIColor(red: 75.0/255.0, green: 177.0/255.0, blue: 78.0/255.0, alpha: 1.0) //UIColor(red: 0/255, green: 85/255.0, blue: 140/255.0, alpha: 1.0);

    static let fair = UIColor(red: 75.0/255.0, green: 150.0/255.0, blue: 241.0/255.0, alpha: 1.0) //UIColor(red: 0/255, green: 85/255.0, blue: 140/255.0, alpha: 1.0);

    static let damage = UIColor(red: 246.0/255.0, green: 65.0/255.0, blue: 56.0/255.0, alpha: 1.0) //UIColor(red: 0/255, green: 85/255.0, blue: 140/255.0, alpha: 1.0);

    
    static let initialScreenLoginBtnBgColor = UIColor(red: 88/255, green: 41/255.0, blue: 171/255.0, alpha: 1.0) //UIColor(red: 0/255, green: 85/255.0, blue: 140/255.0, alpha: 1.0);
    static let initialScreenSignUpBtnBgColor = UIColor(red: 88/255, green: 41/255.0, blue: 171/255.0, alpha: 1.0)
    static let initialScreenLoginBtnTitleColor = UIColor.white;
    static let whiteColor = UIColor.white;
    static let themeOrangeColor = initialScreenLoginBtnBgColor //UIColor(red: 0/255, green: 85/255.0, blue: 140/255.0, alpha: 1.0);
//    static let initialScreenSignUpBtnTitleColor = UIColor.d;
    
    
    // for login screen
    static let textFieldLineColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    static let textFiledTextColor = UIColor.init(red: 89.0/255.0, green: 41.0/255.0, blue: 178.0/255.0, alpha: 1.0)
    static let textFiledTitleColor = UIColor(red: 175/255, green: 175/255.0, blue: 175/255.0, alpha: 1.0)
    static let navigationBarBackgroundColor = initialScreenLoginBtnBgColor //UIColor(red: 0/255, green: 85/255.0, blue: 140/255.0, alpha: 1.0);
    static let statusBarBackgroundColor = UIColor(red: 88/255, green: 41/255.0, blue: 171/255.0, alpha: 1.0);
    
    static let btnBgColor = initialScreenLoginBtnBgColor//UIColor(red: 0/255, green: 85/255.0, blue: 140/255.0, alpha: 1.0);
    static let btnBgColor_Default = UIColor.white;
    
    // wallet implementation colors
    
    static let color_forHeaderBackground = UIColor(red: 250/255, green: 250/255.0, blue: 250/255.0, alpha: 1.0);
    
    //view shadow color
    static let color_shadow = UIColor.black;
    
    // color for wallet detail tabbar
    static let walletDetail_tabBarBackgroundColor = UIColor(red: 248/255, green: 248/255.0, blue: 248/255.0, alpha: 1.0);
    static let recharge_wallet_textColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0);
    static let wallet_lightColor = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1);
    
    
    static let wallet_tab_backgroundColor =  UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1);
    static let  wallet_header_title_textColor_light = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1); // same for filter & for light color need to use it
    
     static let  wallet_header_title_textColor_Dark = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1); // will be use for dark text color
    
    static let line_backgroundColor = UIColor.black.withAlphaComponent(0.18); // need to check it
    
    static let price_minus_color = UIColor(red: 218/255.0, green: 4/255.0, blue: 4/255.0, alpha: 1);
    
    static let price_plus_green_color = UIColor(red: 97/255.0, green: 145/255.0, blue: 26/255.0, alpha: 1);
    

    static let planogram_tblCell_backgroundColor = UIColor(red: 242/255.0, green: 244/255.0, blue: 243/255.0, alpha: 1)
  //  static let button_gradient_color - style -liner mix btn blue color with status bar color
    
    
    static let priorityRed = UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1) //"#FF0000"
    static let priorityGray = UIColor(red: 132/255.0, green: 128/255.0, blue: 127/255.0, alpha: 1) //"#84807F"
    static let priorityYellow = UIColor(red: 234/255.0, green: 109/255.0, blue: 11/255.0, alpha: 1) //"#ea6d0b"
    static let green = UIColor(red: 97/255.0, green: 145/255.0, blue: 26/255.0, alpha: 1) //"#ea6d0b"
    
    static let ticketLineColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1) //#bcbcbc
    static let tableOddCellColor = UIColor(red: 244/255, green: 244/255, blue: 242/255, alpha: 1)
    
}
