//
//  alertCell.swift
//  Masso
//
//  Created by Sunil on 28/03/23.
//

import UIKit

class alertCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblMachineAlert: UILabel!
    @IBOutlet weak var alarmView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var toggelView: UIView!
    @IBOutlet weak var msgView: UIView!
    @IBOutlet weak var imgMsg: UIImageView!
    @IBOutlet weak var btnToggel: UIButton!
    @IBOutlet weak var lblCircel: UILabel!
    @IBOutlet weak var btnMsg: UIButton!
    
    @IBOutlet weak var imgBell: UIImageView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgMsg.image = self.imgMsg.image?.withRenderingMode(.alwaysTemplate)
        self.imgMsg.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        self.imgBell.image = self.imgBell.image?.withRenderingMode(.alwaysTemplate)
        self.imgBell.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        self.mainView.layer.cornerRadius = 8
        self.mainView.clipsToBounds = true
        
        self.toggelView.layer.cornerRadius = 13
        self.toggelView.clipsToBounds = true
        
        self.msgView.layer.cornerRadius = self.msgView.frame.size.height / 2
        self.msgView.clipsToBounds = true
        
        self.lblCircel.layer.cornerRadius = self.lblCircel.frame.size.height / 2
        self.lblCircel.clipsToBounds = true
        
        self.alarmView.layer.cornerRadius = 8
        self.alarmView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        self.alarmView.clipsToBounds = true
        
        self.lblName.font =  UIFont(name: "Inter-Bold", size: 14)
        self.lblStatus.font =  UIFont(name: "Inter-Regular", size: 12)
        self.lblDetails.font =  UIFont(name: "Inter-Bold", size: 12)

        self.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblStatus.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblDetails.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
       
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
