//
//  WebServices.swift
//  HaulifiedBoard
//
//  Created by APTA on 07/07/17.
//  Copyright © 2017 LimitLess. All rights reserved.
//

import Foundation
class webServices{
     //139.59.1.185:8080/truckerList
     static var token = ""
     static var refereshToken = ""

     static var preToken = "Bearer "
     static var headers = ["authorization":"\(preToken)\(webServices.token)"]
    
    
/// Base Url
    //static let productionUrlMysql = "https://phpstack-888443-3416982.cloudwaysapps.com/index.php/v1/api"
    static let productionUrlMysql =   "https://mapi.masso.com.au/index.php/v1/api"
    static var baseUrl = webServices.productionUrlMysql;

    static let AppName = ""
/************************************** End of Main URLs *****************************************************/
    static let login = "/login"
    static let forgotpassword = "/otp"
    static let verifyOTP = "/otp/verify"
    static let resetPassword = "/resetpass"
    static let getControllers = "/controllerstates"
    static let controllersList = "/controllers"
    static let controllersDetails = "/controllers/"
    static let setAlart = "/controllers/alarm"
    static let msgList = "/messages"
    static let msgStatus = "/messages/read"
    static let clearMsg = "/messages/clear"
    static let logoutUser = "/logout"
    static let uploadImage = "/uploaddp"
    static let resetPart = "/controllers/resetparts"
    static let changePassword = "/changePassword"
    static let detailsForParticularDevice = "/messages/"
    static let deleteProfile = "/deletedp"
    static let deviceTokenUpdate = "/deviceToken"
    
    static let msgOTP = "OTP sent successfully to your registered email"
    static let msgInternet = "Internet connection is not stable. Please relaunch the app."
    
    class var sharedInstance:webServices{
        struct sharedInstanceStruct{
            static let instance = webServices()
        }
        return sharedInstanceStruct.instance
    }
}
