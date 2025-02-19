//
//  MessageViewModel.swift
//  Masso
//
//  Created by Sunil on 31/03/23.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON


class MessageViewModel : NSObject
{
    var msgList : [MessageList] = [MessageList]()
    
    func getMessageList(viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String, _ list : [MessageList])->Void){
        
        let url = webServices.baseUrl + webServices.msgList
        print(url)
        let token = UserDefaults.standard.object(forKey: "token") as? String
        let dictHeader = ["Authorization" : token!]
        webServices.token = token!
        
       // loaderManager.sharedInstance.startLoading();

        Alamofire.upload(multipartFormData: { multipart in
            
        }, to: url, method: .get, headers: dictHeader) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.response { answer in
                    let dataString = String(data: answer.data!, encoding: .utf8)
                    if dataString == ""
                    {
                        //loaderManager.sharedInstance.stopLoading()
                        completionHandler("failT","",[MessageList]())
                    }
                    else
                    {
                        //loaderManager.sharedInstance.stopLoading()
                        let output = JSON.init(parseJSON: dataString!)
                        let isSuccess = output["status"].stringValue
                        if isSuccess == "OK"
                        {
                            self.msgList.removeAll()
                            let arrayList = output["data"].arrayValue
                            for item in arrayList
                            {
                                let model = MessageList(id : item["id"].stringValue,serial: item["serial"].stringValue,progress: item["progress"].intValue,timestamp: item["timestamp"].stringValue,title: item["title"].stringValue,body: item["body"].stringValue,read: item["read"].stringValue,model_name: item["model_name"].stringValue,image: item["image"].stringValue)
                                print(model)
                                self.msgList.append(model)
                            }
                            completionHandler("Success", output["msg"].stringValue,self.msgList)
                        }
                        else
                        {
                            completionHandler("fail", output["msg"].stringValue,[MessageList]())

                        }
                        
                    }
                }
                upload.uploadProgress { progress in
                    print("progress:- \(progress)")
                    if(progress.isFinished){
                        //loaderManager.sharedInstance.stopLoading()
                        print("uploading finished")
                    }
                }
            case .failure(_):
                //loaderManager.sharedInstance.stopLoading();
                completionHandler(Message.appearError, "",[MessageList]())
            }
        }
     
    }
    
    func getMachineMessageList(id : String,viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String, _ list : [MessageList])->Void){
        
        let url = webServices.baseUrl + webServices.detailsForParticularDevice + id
        print(url)
        let token = UserDefaults.standard.object(forKey: "token") as? String
        let dictHeader = ["Authorization" : token!]
        webServices.token = token!
        
        loaderManager.sharedInstance.startLoading();

        Alamofire.upload(multipartFormData: { multipart in
            
        }, to: url, method: .get, headers: dictHeader) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.response { answer in
                    let dataString = String(data: answer.data!, encoding: .utf8)
                    if dataString == ""
                    {
                        loaderManager.sharedInstance.stopLoading()
                        completionHandler("failT","",[MessageList]())
                    }
                    else
                    {
                        loaderManager.sharedInstance.stopLoading()
                        let output = JSON.init(parseJSON: dataString!)
                        let isSuccess = output["status"].stringValue
                        if isSuccess == "OK"
                        {
                            self.msgList.removeAll()
                            let arrayList = output["data"].arrayValue
                            for item in arrayList
                            {
                                let model = MessageList(id : item["id"].stringValue,serial: item["serial"].stringValue,progress: item["progress"].intValue,timestamp: item["timestamp"].stringValue,title: item["title"].stringValue,body: item["body"].stringValue,read: item["read"].stringValue,model_name: item["model_name"].stringValue,image: item["image"].stringValue)
                                print(model)
                                self.msgList.append(model)
                            }
                            completionHandler("Success", output["msg"].stringValue,self.msgList)
                        }
                        else
                        {
                            completionHandler("fail", output["msg"].stringValue,[MessageList]())

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
                completionHandler(Message.appearError, "",[MessageList]())
            }
        }
     
    }
    
    func getMessageReadStatus(id : String,viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String)->Void){
        
        let url = webServices.baseUrl + webServices.msgStatus
        print(url)
        
    
        
        let token = UserDefaults.standard.object(forKey: "token") as? String
        let dictHeader = ["Authorization" : token!]
        webServices.token = token!
        
        loaderManager.sharedInstance.startLoading();

        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(id.data(using: .utf8)!, withName: "message_id")

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
    
    func clearMessage(viewController:UIViewController, isLoaderRequired:Bool ,completion: @escaping (_ errorString: String?,_ msg:String) -> Void) {
        
        let requestP = webServices.clearMsg
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
