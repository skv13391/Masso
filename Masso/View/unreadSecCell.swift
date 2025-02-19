//
//  unreadSecCell.swift
//  Masso
//
//  Created by Sunil on 29/03/23.
//

import UIKit

class unreadSecCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCircel: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblDetrails: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblLeft: UILabel!
    @IBOutlet weak var mHeight: NSLayoutConstraint!
    @IBOutlet weak var cHeight: NSLayoutConstraint!
    @IBOutlet weak var pHeight: NSLayoutConstraint!
    @IBOutlet weak var timeHeight: NSLayoutConstraint!
    @IBOutlet weak var msgHeight: NSLayoutConstraint!
    @IBOutlet weak var cWidth: NSLayoutConstraint!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.2)
        
        self.lblName.text = "G3-7001"
        self.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
        self.lblTime.text = "2min ago"
        self.lblTime.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.6)
        
        
        self.lblPercent.text = "Version 5.0"
        self.lblPercent.textColor = UIColor.init(red: 198.0/255.0, green: 149.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        
        
        self.lblDetrails.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
