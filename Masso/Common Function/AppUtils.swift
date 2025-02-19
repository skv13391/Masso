//
//  AppUtils.swift
//  VMConsumer
//
//  Created by Developer on 17/12/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import Kingfisher
import SwiftyJSON




enum OrderStatus:String{
    case ORDER_UNPAID_VALUE = "7"
    case ORDER_CLOSED_VALUE = "1"
    case ORDER_INITIATED_VALUE = "2"
    case ORDER_CANCELLED_VALUE = "4"
    case ORDER_PENDING_VALUE = "8"
   
}



enum AlertType:String{
    case success = "Success"
    case alert = "alert"
    case error = "error"
    case info = "info"
    case tellus = "tellus"

}


enum TicketLookUpDataType:String{
    case Category = "Category"
    case SubCategory = "alert"
    case Status = "Status"
    case Priority = "Priority"
}


enum ResponseStatus:String{
    case Api_Success = "success"
    case Api_Failure = "fail"
}


class AppUtils{

    //decimal digits to be shown
    static var decimalDigits = 2;
    
    // alert title variables
    static var AlertTypeTitle = "Alert !";
    static var ErrorTypeTitle = "Error !"
    static var SuccessAlertType = "Success"
    static var paymentSuccessAlertType = "Payment Successful !";
    static var paymentFailedAlertType = "Payment Failed !";
    
    static var rechargeSuccessAlertType = "Recharge Successful !";
    static var rechargeFailedAlertType = "Recharge Failed !";
    static var transferSuccessAlertType = "Transfer Successsful !"
    
    //api response
    static let Success = "Success";
    static let alert = "Alert !"
    
    static let FCMToken = "FcmToken"

    
    // keys to save data in preferences
    static let isLoggedIn = "isLogin";
    static let save_UserInfo = "user_info";
    static let walletDetail = "walletDetail";
    static let wallet = "wallet";
    static let token = "token";
    static let userPassword = "password";
    static let userEmailId = "email";
    static let notificationId = "notificationId";
    static let fcmToken = "fcmToken"
    
    // wallet list constant variables
    
    static let availabl_balance = "Balance : "
    static let rupeeSymbol = "₹ ";
    static let percentageSymbol = "%";
    
    //notifications
    static let refreshTransactionList = Notification.Name("refreshTransaction");
    static let swipeOccurs = Notification.Name("swipeViewController");
    static let moveToCart = Notification.Name("showCart");
    static let moveToIndex = Notification.Name("moveToIndex");
    
    
     static let TICKET_STATUS_RESOLVED_TXT   = "Resolved";
     static let TICKET_STATUS_PENDING_TXT   = "Pending";
     static let TICKET_STATUS_INPROGRESS_TXT = "Progress";
     static let TICKET_STATUS_CREATED_TXT   = "Created";
 
    
//    static func savePostData(workItem:[WorkItemModel])->Bool{
//
//         let encoder = JSONEncoder()
//         let defaults = UserDefaults.standard
//
//         if let encoded = try? encoder.encode(workItem) {
//             defaults.set(encoded, forKey: "post");
//             return true;
//         }
//
//         return false;
//     }
//
//    static func retrievePostData()->[WorkItemModel]{
//         let defaults = UserDefaults.standard
//         if let savedPerson = defaults.object(forKey: "post") as? Data {
//             let decoder = JSONDecoder()
//             if let loadedPerson = try? decoder.decode([WorkItemModel].self, from: savedPerson) {
//                 return loadedPerson;
//             }
//         }
//         return [WorkItemModel]()
//     }
//
//
//    static func removePostData()->[WorkItemModel]{
//         let defaults = UserDefaults.standard
//        defaults.removeObject(forKey: "post")
//        defaults.removeObject(forKey: "title")
//        defaults.removeObject(forKey: "des")
//         return [WorkItemModel]()
//     }
//
//
//   static func saveUserDataToUserDefaults(user:UserLoginDataModel)->Bool{
//
//        let encoder = JSONEncoder()
//        let defaults = UserDefaults.standard
//
//        if let encoded = try? encoder.encode(user) {
//            defaults.set(encoded, forKey: AppUtils.save_UserInfo);
//            return true;
//        }
//
//        return false;
//    }
//
    static func getDateFromNewShowFormate(strDate : String)-> String
    {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let convertToDate = dateFormatter.date(from: strDate){
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDate = dateFormatter.string(from: convertToDate);
            return formattedDate;
        }
        return ""
    }
    
    static func chatDateFormatter(date:String) -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "dd MMM, yyyy"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");
            return formattedDate;
        }
        return "";
    }
    
    static func chatDateTimeFormatter(date:String) -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "hh:mm a"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");
            return formattedDate;
        }
        return "";
    }
    
    static func getYearFromNewShowFormate(strDate : String)-> String
    {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let convertToDate = dateFormatter.date(from: strDate){
            dateFormatter.dateFormat = "yyyy"
            let formattedDate = dateFormatter.string(from: convertToDate);
            return formattedDate;
        }
        return ""
    }
    
    static func getAlertTypeMessage(valueAlert : Int)-> String
    {
        var message = String()
        switch valueAlert {
        case 0:
            message = "X Axis Alarm"
            break
        case 1:
            message = "Y Axis Alarm"
            break
        case 2:
            message = "Z Axis Alarm"
            break
        case 3:
            message = "A Axis Alarm"
            break
        case 4:
            message = "B Axis Alarm"
            break
        case 5:
            message = "Spindle Drive Alarm"
            break
        case 6:
            message = "Air Pressure Low"
            break
        case 7:
            message = "X Axis Hard Limit Alarm"
            break
        case 8:
            message = "Y Axis Hard Limit Alarm"
            break
        case 9:
            message = "Z Axis Hard Limit Alarm"
            break
        case 10:
            message = "A Axis Hard Limit Alarm"
            break
        case 11:
            message = " B Axis Hard Limit Alarm"
            break
        case 12:
            message = "Spindle Coolant Flow Alarm"
            break
        case 20:
            message = "Lubricant Alarm"
            break
        case 21:
            message = "Plasma Torch Hit Alarm"
            break
        case 22:
            message = "Waterjet Head Hit Alarm"
            break
        case 23:
            message = "Waterjet Water Pressure Low Alarm"
            break
        case 24:
            message = "Waterjet Abrasive Low Alarm"
            break
        case 25:
            message = "Waterjet Abrasive Metering Alarm"
            break
        case 26:
            message = "Waterjet Cut Sense Alarm"
            break
        case 254:
            message = "No Axis Alarm"
            break
        case 255:
            message = "No Alarm"
            break
        default:
            message = ""
            break
        }
        return message
    }
   
    
//   static func retrieveUserObjectFromDefaults()->UserLoginDataModel{
//        let defaults = UserDefaults.standard
//        if let savedPerson = defaults.object(forKey: AppUtils.save_UserInfo) as? Data {
//            let decoder = JSONDecoder()
//            if let loadedPerson = try? decoder.decode(UserLoginDataModel.self, from: savedPerson) {
//                return loadedPerson;
//            }
//        }
//        return UserLoginDataModel(fromJson: nil);
//    }
//    
//    static func resetDefaults(isRemoveLoginCredentials:Bool) {
//    webServices.token = "";
//        let defaults = UserDefaults.standard
//        let dictionary = defaults.dictionaryRepresentation()
//        dictionary.keys.forEach { key in
//            
//            if isRemoveLoginCredentials{
//                defaults.removeObject(forKey: key)
//
//            }else{
//                if key != AppUtils.userPassword && key != AppUtils.userEmailId{
//                    defaults.removeObject(forKey: key)
//                }
//            }
//        }
//    }
    
    
    //func to convert double to string with decimal formatter
    static func doubleToString(doubleValue:Double)-> String{
        
       return String(format: "%.\(decimalDigits)f", doubleValue)
    }
    
    static func doubleToStringForWeight(doubleValue:Double)-> String{
        return String(format: "%.0f", doubleValue)
    }
    
    
    static func stringWithDecimalFormatter(value:String)->String{
        return String(format: "%.\(decimalDigits)f", value);
    }
    
    
    static func transactionDateFormatter(date:String) -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssZ" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "dd,MMM,yyyy | hh:mm"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");

            return formattedDate;

        }
                
        return "";
    }
    
    static func transactionDateFormatterMembersince(date:String) -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssZ" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");

            return formattedDate;

        }
                
        return "";
    }
    
    
    static func projectDateFormatter(date:String) -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssZ" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "dd-MMMM-yyyy"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");

            return formattedDate;

        }
                
        return "";
    }
    
    
    static func offersDateFormatter(date:String) -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "dd MMM, yyyy"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");
            
            return formattedDate;
            
        }
        
        return "";
    }
    
    
    static func ticketsDateFormatter(date:String) -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssss" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "dd MMM, yyyy"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");
            
            return formattedDate;
            
        }
        
        return "";
    }
    
    static func updatedDateFormatter(date:String) -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssZ" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");
            
            return formattedDate;
            
        }
        
        return "";
    }
    
    
    
    
    static func getDateFromString(dateString:String,format:String) -> Date{
        
        let dateformatter = DateFormatter();
        dateformatter.dateFormat = format
//        dateformatter.locale = Locale(identifier: "en_US_POSIX")
//        dateformatter.timeZone = TimeZone(abbreviation: "GMT+5:30")
        let date = dateformatter.date(from: dateString)
        print("date:- \(date)")
        return date!
    }
    
    
    static func isValidDateFormat(date:String)-> Bool{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd MMM, yyyy" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: date){
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let formattedDate = dateFormatter.string(from: convertToDate);
//            //print("formatted date:- \(formattedDate)");
            if convertToDate != nil{
                return true;

            }else{
                return false;

            }
            
        }
        return false;
    }
    
    static func formatFilterDate(date:String,isReverse:Bool) -> String{
        let dateFormatter = DateFormatter();
        
        if isReverse{
            dateFormatter.dateFormat = "dd MMM, yyyy" // receiving date format
            
            if let convertToDate = dateFormatter.date(from: date){
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let formattedDate = dateFormatter.string(from: convertToDate);
                //print("formatted date:- \(formattedDate)");
                
                return formattedDate;
                
            }
        }else{
            dateFormatter.dateFormat = "yyyy-MM-dd" // receiving date format
            
            if let convertToDate = dateFormatter.date(from: date){
                dateFormatter.dateFormat = "dd MMM, yyyy"
                let formattedDate = dateFormatter.string(from: convertToDate);
                //print("formatted date:- \(formattedDate)");
                
                return formattedDate;
                
            }
        }
       
        
        return "";
    }
    
    
    static func getDayFromDate(date:String,isRequiredDayOnly:Bool) -> String{
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let todayDate = formatter.date(from: date) else { return "" }
        
        if(isRequiredDayOnly){
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.day, from: todayDate)
            return "\(weekDay)"
        }else{
            
            formatter.dateFormat = "MMM yyyy  HH:mm";
            let requiredDate = formatter.string(from: todayDate);
            return requiredDate;
            
        }
      
        
    }
    
    
    
    
    static func getCurrenTimeStamp() -> String{
    
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyyMMddHHmmss";
        return dateFormatter.string(from: date)
    }
    
    
    static func getDateFromMonthBefore()-> String{
        
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd";
        
        let dateOneMonthAgo = Calendar(identifier: .gregorian).date(byAdding: .day, value: -30, to: date)
        
        if dateOneMonthAgo != nil{
            
            return dateFormatter.string(from: dateOneMonthAgo!);
        }
        
        return "";
    }
    
    static func getDateFromMonthBeforeForTransactionHistory()-> String{
        
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd MMM, yyyy";
        
        let dateOneMonthAgo = Calendar(identifier: .gregorian).date(byAdding: .day, value: -30, to: date)
        
        if dateOneMonthAgo != nil{
            
            return dateFormatter.string(from: dateOneMonthAgo!);
        }
        
        return "";
    }
    
    static func getCurrentDate() -> String{
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd";
   
        return dateFormatter.string(from: date)
    }
    
    
    static func getCurrentDateForTransactionHistory() -> String{
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd MMM, yyyy";
        
        return dateFormatter.string(from: date)
    }
    
    static func getDateForPaymentInfo(paymentDate:String) -> String{
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: paymentDate){
            dateFormatter.dateFormat = "hh:mm a, dd MMM yy"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");
            
            return formattedDate;
            
        }
        
        return "";
    }
    
    
    static func getDateForMesage(paymentDate:String) -> String{
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: paymentDate){
            dateFormatter.dateFormat = "dd MMM,yyyy"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");
            
            return formattedDate;
            
        }
        
        return "";
    }
    
    static func getOrderStatus(status:String) -> String{
        
        if status == OrderStatus.ORDER_UNPAID_VALUE.rawValue{
            return "Unpaid";
        }else if status == OrderStatus.ORDER_PENDING_VALUE.rawValue{
            return "View Pending";
        }
        else if status == OrderStatus.ORDER_INITIATED_VALUE.rawValue{
            return "Open";
        }
        else if status == OrderStatus.ORDER_CLOSED_VALUE.rawValue{
            return "Closed";
        }
        
        return "Cancel";
    }

    
    static func calculateApiVersion(apiUrl:String)->String{
       // let specificUrl = apiUrl.components(separatedBy: webServices.baseUrl)
        //add switch here to return api_version according to url
        return "1.0"
    }
    
    
    
    
}
