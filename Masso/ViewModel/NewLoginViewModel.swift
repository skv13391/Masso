//
//  NewLoginViewModel.swift
//  Masso
//
//  Created by Sunil on 31/03/23.
//


import Foundation
import Alamofire
import UIKit
import SwiftyJSON


class NewLoginViewModel : NSObject
{
    
    func  getLogin(dictDat:NSDictionary,viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String, _ serial : String)->Void){
        
        let url = webServices.baseUrl + webServices.login
        print(url)
        let name = dictDat.object(forKey: "username") as? String
        let pass = dictDat.object(forKey: "password") as? String
        let token = dictDat.object(forKey: "device_token") as? String
        let type  = "3"
        
        loaderManager.sharedInstance.startLoading();

        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(name!.data(using: .utf8)!, withName: "username")
            multipart.append(pass!.data(using: .utf8)!, withName: "password")
            multipart.append(type.data(using: .utf8)!, withName: "app_type")
            multipart.append(token!.data(using: .utf8)!, withName: "device_token")


        }, to: url, method: .post, headers: [:]) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.response { answer in
                    let dataString = String(data: answer.data!, encoding: .utf8)
                    if dataString == ""
                    {
                        loaderManager.sharedInstance.stopLoading()
                        completionHandler("failT","","")
                    }
                    else
                    {
                        loaderManager.sharedInstance.stopLoading()
                        let output = JSON.init(parseJSON: dataString!)
                        let dpURL = output["data"]["dp"].stringValue
                        let token = output["data"]["token"].stringValue
                        let name = output["data"]["username"].stringValue
                        let serial = output["data"]["serial"].stringValue

                        let isSuccess = output["status"].stringValue
                        if isSuccess == "OK"
                        {
                            let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
                            myAppDelegate.uploadedImage = dpURL
                            UserDefaults.standard.set(dpURL, forKey: "dpp")
                            UserDefaults.standard.set(token, forKey: "token")
                            UserDefaults.standard.set(name, forKey: "name")
                            UserDefaults.standard.synchronize()
                            completionHandler("Success", output["msg"].stringValue,serial)
                        }
                        else
                        {
                            completionHandler("fail", output["msg"].stringValue,"")
                        }
                            
                        
                    }
                }
                upload.uploadProgress { progress in
                    print("progress:- \(progress)")
                    if(progress.isFinished){
                        print("uploading finished")
                    }
                }
            case .failure(_):
                loaderManager.sharedInstance.stopLoading()
                completionHandler(Message.appearError, "","")
            }
        }
     
    }
    
    
    func forgotPasswordOTP(dictDat:NSDictionary,viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String,_ otp : String, _ transID : String)->Void){
        
        let url = webServices.baseUrl + webServices.forgotpassword
        print(url)
        let email = dictDat.object(forKey: "email") as? String
        let operations = dictDat.object(forKey: "operation") as? String
        
        loaderManager.sharedInstance.startLoading();

        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(email!.data(using: .utf8)!, withName: "email")
            multipart.append(operations!.data(using: .utf8)!, withName: "operation")
        }, to: url, method: .post, headers: [:]) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.response { answer in
                    let dataString = String(data: answer.data!, encoding: .utf8)
                    if dataString == ""
                    {
                        loaderManager.sharedInstance.stopLoading()
                        completionHandler("failT","","","")
                    }
                    else
                    {
                        loaderManager.sharedInstance.stopLoading()
                        let output = JSON.init(parseJSON: dataString!)
                        let otp = output["data"]["otp"].stringValue
                        let transid = output["data"]["trans_id"].stringValue
                        
                        let isSuccess = output["status"].stringValue
                        if isSuccess == "OK"
                        {
                            completionHandler("Success", output["msg"].stringValue,otp,transid)
                        }
                        else
                        {
                            completionHandler("fail", output["msg"].stringValue,"","")
                        }
                        
                        
                    }
                }
                upload.uploadProgress { progress in
                    print("progress:- \(progress)")
                    if(progress.isFinished){
                        loaderManager.sharedInstance.stopLoading()
                        print("uploading finished")
                    }
                }
            case .failure(_):
                loaderManager.sharedInstance.stopLoading();
                completionHandler(Message.appearError, "","","")
            }
        }
     
    }
    
    func verifyOTP(dictDat:NSDictionary,viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String, _ transID : String)->Void){
        
        let url = webServices.baseUrl + webServices.verifyOTP
        print(url)
        let otp = dictDat.object(forKey: "otp") as? String
        let transid = dictDat.object(forKey: "trans_id") as? String
        
        loaderManager.sharedInstance.startLoading();

        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(otp!.data(using: .utf8)!, withName: "otp")
            multipart.append(transid!.data(using: .utf8)!, withName: "trans_id")
            multipart.append("1".data(using: .utf8)!, withName: "type")

        }, to: url, method: .post, headers: [:]) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.response { answer in
                    let dataString = String(data: answer.data!, encoding: .utf8)
                    if dataString == ""
                    {
                        loaderManager.sharedInstance.stopLoading()
                        completionHandler("failT","","")
                    }
                    else
                    {
                        loaderManager.sharedInstance.stopLoading()
                        let output = JSON.init(parseJSON: dataString!)
                        let transid = output["data"]["trans_id"].stringValue
                        let isSuccess = output["status"].stringValue
                        if isSuccess == "OK"
                        {
                            completionHandler("Success", output["msg"].stringValue,transid)
                        }
                        else
                        {
                            completionHandler("fail", output["msg"].stringValue,"")
                        }
                    }
                }
                upload.uploadProgress { progress in
                    print("progress:- \(progress)")
                    if(progress.isFinished){
                        loaderManager.sharedInstance.stopLoading()
                        print("uploading finished")
                    }
                }
            case .failure(_):
                loaderManager.sharedInstance.stopLoading();
                completionHandler(Message.appearError, "","")
            }
        }
     
    }
    
    
    func resetPassword(dictDat:NSDictionary,viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String)->Void){
        
        let url = webServices.baseUrl + webServices.resetPassword
        print(url)
        let password = dictDat.object(forKey: "password") as? String
        let transid = dictDat.object(forKey: "token") as? String
        
        loaderManager.sharedInstance.startLoading();

        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(password!.data(using: .utf8)!, withName: "password")
            multipart.append(transid!.data(using: .utf8)!, withName: "trans_id")
        }, to: url, method: .post, headers: [:]) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.response { answer in
                    let dataString = String(data: answer.data!, encoding: .utf8)
                    if dataString == ""
                    {
                        loaderManager.sharedInstance.stopLoading()
                        completionHandler("failT","")
                    }
                    else
                    {
                        loaderManager.sharedInstance.stopLoading()
                        let output = JSON.init(parseJSON: dataString!)
                        let isSuccess = output["status"].stringValue
                        if isSuccess == "OK"
                        {
                            completionHandler("Success", output["msg"].stringValue)
                        }
                        else
                        {
                            completionHandler("fail", output["msg"].stringValue)
                        }
                        
                    }
                }
                upload.uploadProgress { progress in
                    print("progress:- \(progress)")
                    if(progress.isFinished){
                        loaderManager.sharedInstance.stopLoading()
                        print("uploading finished")
                    }
                }
            case .failure(_):
                loaderManager.sharedInstance.stopLoading();
                completionHandler(Message.appearError, "")
            }
        }
     
    }
    
    
    
    
    func logoutUser(viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ msg:String) -> Void) {
        
        let requestP = webServices.logoutUser
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
            if(output["status"].stringValue == "OK"){
                completion("Success", output["msg"].stringValue)
            }else{
                print("error completion called");
                completion(output["message"].stringValue,output["msg"].stringValue);
            }
            
        }
    }
    
    func removeUserProfile(viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ msg:String) -> Void) {
        
        let requestP = webServices.deleteProfile
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
            if(output["status"].stringValue == "OK"){
                completion("Success", output["msg"].stringValue)
            }else{
                print("error completion called");
                completion(output["message"].stringValue,output["msg"].stringValue);
            }
            
        }
    }
    
    func changePassword(dictDat : NSDictionary,viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String)->Void){
        
        let url = webServices.baseUrl + webServices.changePassword
        print(url)
        
        let old = dictDat.object(forKey: "old") as? String
        let new = dictDat.object(forKey: "new") as? String

        let token = UserDefaults.standard.object(forKey: "token") as? String
        let dictHeader = ["Authorization" : token!]
        webServices.token = token!
        
        
        loaderManager.sharedInstance.startLoading();

        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(old!.data(using: .utf8)!, withName: "old_password")
            multipart.append(new!.data(using: .utf8)!, withName: "new_password")

        }, to: url, method: .post, headers: dictHeader) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.response { answer in
                    let dataString = String(data: answer.data!, encoding: .utf8)
                    if dataString == ""
                    {
                        loaderManager.sharedInstance.stopLoading()
                        completionHandler("failT","")
                    }
                    else
                    {
                        loaderManager.sharedInstance.stopLoading()
                        let output = JSON.init(parseJSON: dataString!)
                        let isSuccess = output["status"].stringValue
                        if isSuccess == "OK"
                        {
                            completionHandler("Success", output["msg"].stringValue)
                        }
                        else
                        {
                            completionHandler("fail", output["msg"].stringValue)
                        }
                    }
                }
                upload.uploadProgress { progress in
                    print("progress:- \(progress)")
                    if(progress.isFinished){
                        loaderManager.sharedInstance.stopLoading()
                        print("uploading finished")
                    }
                }
            case .failure(_):
                loaderManager.sharedInstance.stopLoading();
                completionHandler(Message.appearError, "")
            }
        }
     
    }
    
    
    func updateTokenToServer(token : String,viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String)->Void){
        
        let url = webServices.baseUrl + webServices.deviceTokenUpdate
        print(url)
        
        
        let token = UserDefaults.standard.object(forKey: "token") as? String
        let dictHeader = ["Authorization" : token!]
        webServices.token = token!
        
        
        loaderManager.sharedInstance.startLoading();

        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(token!.data(using: .utf8)!, withName: "device_token")
        }, to: url, method: .post, headers: dictHeader) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.response { answer in
                    let dataString = String(data: answer.data!, encoding: .utf8)
                    if dataString == ""
                    {
                        loaderManager.sharedInstance.stopLoading()
                        completionHandler("failT","")
                    }
                    else
                    {
                        loaderManager.sharedInstance.stopLoading()
                        let output = JSON.init(parseJSON: dataString!)
                        let isSuccess = output["status"].stringValue
                        if isSuccess == "OK"
                        {
                            completionHandler("Success", output["msg"].stringValue)
                        }
                        else
                        {
                            completionHandler("fail", output["msg"].stringValue)
                        }
                    }
                }
                upload.uploadProgress { progress in
                    print("progress:- \(progress)")
                    if(progress.isFinished){
                        print("uploading finished")
                    }
                }
            case .failure(_):
                loaderManager.sharedInstance.stopLoading();
                completionHandler(Message.appearError, "")
            }
        }
     
    }
    
}
