//
//  LoginViewModel.swift
//  Masso
//
//  Created by Sunil on 31/03/23.
//

import Foundation

import UIKit
import SwiftyJSON


class LoginViewModel : NSObject
{
    
    func getLogin(dict: NSDictionary, viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ msg:String) -> Void) {
        
        let requestP = webServices.login
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: dict as! [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in
            
            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }
            
            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                let dpURL = output["data"]["dp"].stringValue
                let token = output["data"]["token"].stringValue

                UserDefaults.standard.set(dpURL, forKey: "dp")
                UserDefaults.standard.set(token, forKey: "token")

                completion("Success", output["msg"].stringValue)
            }else{
                print("error completion called");
                completion(output["message"].stringValue,output["msg"].stringValue);
            }
            
        }
    }
    
    func forgotPasswordOTP(dict: NSDictionary, viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ msg:String,_ otp : String, _ transID : String) -> Void) {
        
        let requestP = webServices.forgotpassword
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: dict as! [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in
            
            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }
            
            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                completion("Success", output["msg"].stringValue,output["data"]["otp"].stringValue,output["data"]["trans_id"].stringValue)
            }else{
                print("error completion called");
                completion(output["message"].stringValue,output["msg"].stringValue,"","");
            }
            
        }
    }
    
    func verifyOTP(dict: NSDictionary, viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ msg:String, _ transID : String) -> Void) {
        
        let requestP = webServices.verifyOTP
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: dict as! [String : AnyObject], serviceType: "post", header: [:], withVC: viewController) { (res) in
            
            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }
            
            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                completion("Success", output["msg"].stringValue,output["data"]["trans_id"].stringValue)
            }else{
                print("error completion called");
                completion(output["message"].stringValue,output["msg"].stringValue,"");
            }
            
        }
    }
    
    func resetPassword(dict: NSDictionary, viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ msg:String) -> Void) {
        
        let requestP = webServices.resetPassword
        if(isLoaderRequired){
            loaderManager.sharedInstance.startLoading();
        }
        let token = UserDefaults.standard.object(forKey: "token") as? String
        let dictHeader = ["Authorization" : token!]
        webServices.token = token!
        
        webServiceExecuter.sharedInstance.executeRequest(webServices.baseUrl+requestP, param: [:], serviceType: "post", header: dictHeader, withVC: viewController) { (res) in
            
            if(isLoaderRequired){
                loaderManager.sharedInstance.stopLoading();
            }
            
            let output = JSON(res);
            print(output);
            if(output["isError"].boolValue == false){
                completion("Success", output["msg"].stringValue)
            }else{
                print("error completion called");
                completion(output["message"].stringValue,output["msg"].stringValue);
            }
            
        }
    }
}
