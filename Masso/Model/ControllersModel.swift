//
//  ControllersModel.swift
//  Masso
//
//  Created by Sunil on 31/03/23.
//

import Foundation



struct controllers
{
    var sid : Int = 0
    var sname : String = ""
}


struct controllersList
{
    var serial : String = ""
    var model :String = ""
    var name :String = ""
    var state :String = ""
    var operatorName :String = ""
    var progress :String = ""
    var img :String = ""
    var alarm_type :Int = 0
    var alarm_sub :Int = 0
    var last_response :String = ""
    var parts:Int = 0
    var filename :String = ""
    var is_sub :Int = 0
    var machineState : String?
}


struct MessageList
{
    var id : String = ""
    var serial : String = ""
    var progress : Int = 0
    var timestamp : String = ""
    var title : String = ""
    var body : String = ""
    var read : String = ""
    var model_name : String = ""
    var image : String = ""


}
