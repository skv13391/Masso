//
//  HomeViewModel.swift
//  Masso
//
//  Created by Sunil on 31/03/23.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON


class HomeViewModel : NSObject
{
    
    var cModelList : [controllers] = [controllers]()
    var cntrollersList : [controllersList] = [controllersList]()
    var cntrollersDetails : controllersList!

    
    
    func getAllControllers(viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String, _ list : [controllers])->Void){
        
        let url = webServices.baseUrl + webServices.getControllers
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
                        completionHandler("failT","",[controllers]())
                    }
                    else
                    {
                        loaderManager.sharedInstance.stopLoading()
                        let output = JSON.init(parseJSON: dataString!)
                        let isSuccess = output["status"].stringValue
                        if isSuccess == "OK"
                        {
                            let arrayList = output["data"].arrayValue
                            for item in arrayList
                            {
                                let id = item["sid"].intValue
                                let name = item["sname"].stringValue
                                let model = controllers(sid: id,sname: name)
                                print(model)
                                self.cModelList.append(model)
                            }
                            completionHandler("Success", output["msg"].stringValue,self.cModelList)
                        }
                        else
                        {
                            completionHandler("fail", output["msg"].stringValue,[controllers]())
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
                completionHandler(Message.appearError, "",[controllers]())
            }
        }
     
    }
    
   
    
    func getAllControllersList(viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String, _ list : [controllersList])->Void){
        
        let url = webServices.baseUrl + webServices.controllersList
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
                        completionHandler("failT","",[controllersList]())
                    }
                    else
                    {
                        loaderManager.sharedInstance.stopLoading()
                        let output = JSON.init(parseJSON: dataString!)
                        let isSuccess = output["status"].stringValue
                        if isSuccess == "OK"
                        {
                            self.cntrollersList.removeAll()
                            let arrayList = output["data"].arrayValue
                            for item in arrayList
                            {
                                let model = controllersList(serial: item["serial"].stringValue,model: item["model_name"].stringValue,name:item["machine_name"].stringValue,state:item["state"].stringValue,operatorName:item["operator_name"].stringValue,progress:item["progress"].stringValue,img:item["image"].stringValue,alarm_type:item["alarm_type"].intValue,alarm_sub:item["alarm_sub"].intValue,last_response:item["last_response"].stringValue,parts:item["parts"].intValue,filename:item["filename"].stringValue,is_sub:item["is_sub"].intValue)
                                print(model)
                                self.cntrollersList.append(model)
                            }
                            completionHandler("Success", output["msg"].stringValue,self.cntrollersList)
                        }
                        else
                        {
                            completionHandler("fail", output["msg"].stringValue,[controllersList]())
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
                completionHandler(Message.appearError, "",[controllersList]())
            }
        }
     
    }
    
    
    func getControllersListDetails(id : Int,viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String, _ list : controllersList)->Void){
        
        let url = webServices.baseUrl + webServices.controllersDetails + "\(id)"
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
                        completionHandler("failT","", controllersList(serial: "",model: "",name:"",state:"",operatorName:"",progress:"",img:"",alarm_type:0,alarm_sub:0,last_response:"",parts:0,filename:"",is_sub:0))
                    }
                    else
                    {
                        loaderManager.sharedInstance.stopLoading()
                        let output = JSON.init(parseJSON: dataString!)
                        let isSuccess = output["status"].stringValue
                        if isSuccess == "OK"
                        {
                            let arrayList = output["data"].arrayValue
                            
                            let model = controllersList(serial: arrayList[0]["serial"].stringValue,model: arrayList[0]["model_name"].stringValue,name:arrayList[0]["machine_name"].stringValue,state:arrayList[0]["state"].stringValue,operatorName:arrayList[0]["operator_name"].stringValue,progress:arrayList[0]["progress"].stringValue,img:arrayList[0]["image"].stringValue,alarm_type:arrayList[0]["alarm_type"].intValue,alarm_sub:arrayList[0]["alarm_sub"].intValue,last_response:arrayList[0]["last_response"].stringValue,parts:arrayList[0]["parts"].intValue,filename:arrayList[0]["filename"].stringValue,is_sub:arrayList[0]["is_sub"].intValue,machineState: "")
                            self.cntrollersDetails = model
                            print(model)
                            
                            completionHandler("Success", output["msg"].stringValue,self.cntrollersDetails)
                        }
                        else
                        {
                            completionHandler("fail", output["msg"].stringValue,controllersList(serial: "",model: "",name:"",state:"",operatorName:"",progress:"",img:"",alarm_type:0,alarm_sub:0,last_response:"",parts:0,filename:"",is_sub:0))
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
                completionHandler(Message.appearError, "",controllersList(serial: "",model: "",name:"",state:"",operatorName:"",progress:"",img:"",alarm_type:0,alarm_sub:0,last_response:"",parts:0,filename:"",is_sub:0))
            }
        }
     
    }
    
    
    func setAlertState(dictDat : NSDictionary,viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String)->Void){
        
        let url = webServices.baseUrl + webServices.setAlart
        print(url)
        
        let serial = dictDat.object(forKey: "serial") as? String
        let alarm = dictDat.object(forKey: "alarm") as? String
        
        let token = UserDefaults.standard.object(forKey: "token") as? String
        let dictHeader = ["Authorization" : token!]
        webServices.token = token!
        
        
        loaderManager.sharedInstance.startLoading();

        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(serial!.data(using: .utf8)!, withName: "serial")
            multipart.append(alarm!.data(using: .utf8)!, withName: "alarm")
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
    
    
    func setResetPart(dictDat : NSDictionary,viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String)->Void){
        
        let url = webServices.baseUrl + webServices.resetPart
        print(url)
        
        let serial = dictDat.object(forKey: "serial") as? String
        
        let token = UserDefaults.standard.object(forKey: "token") as? String
        let dictHeader = ["Authorization" : token!]
        webServices.token = token!
        
        
        loaderManager.sharedInstance.startLoading();

        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(serial!.data(using: .utf8)!, withName: "serial")
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
    
    
    
    
    func uploadProfileImage(img : UIImage,viewController:UIViewController,completionHandler:@escaping (_ errorMessage:String,_ msg:String,_ img : String)->Void){
        
        let url = webServices.baseUrl + webServices.uploadImage
        print(url)
        
        
        let token = UserDefaults.standard.object(forKey: "token") as? String
        let dictHeader = ["Authorization" : token!]
        webServices.token = token!
        guard let imgData = img.pngData() else { return }
        let base64String = imgData.base64EncodedString(options: .lineLength64Characters)
        let newBase64 = "data:image/jpeg;base64," + base64String
        
        loaderManager.sharedInstance.startLoading();

        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(newBase64.data(using: .utf8)!, withName: "image")
        }, to: url, method: .post, headers: dictHeader) { encodingResult in
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
                        let isSuccess = output["status"].stringValue
                        if isSuccess == "OK"
                        {
                            completionHandler("Success", output["msg"].stringValue,output["data"]["path"].stringValue)
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
    
}
