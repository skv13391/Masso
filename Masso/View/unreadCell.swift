//
//  unreadCell.swift
//  Masso
//
//  Created by Sunil on 29/03/23.
//

import UIKit

class unreadCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblCircel: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.2)
        
        self.lblName.text = "G3-7001"
        self.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblName.font =  UIFont(name: "Inter-Medium", size: 12)
        
        self.lblTime.text = "2min ago"
        self.lblTime.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.6)
        self.lblTime.font =  UIFont(name: "Inter-Light", size: 10)
        
        
        
        self.lblCircel.layer.cornerRadius = self.lblCircel.frame.size.height / 2
        self.lblCircel.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)
        self.lblCircel.clipsToBounds = true
        
        self.lblPercent.text = "65%"
        self.lblPercent.textColor = UIColor.init(red: 198.0/255.0, green: 149.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        self.lblPercent.font =  UIFont(name: "Inter-SemiBold", size: 12)
        
        let details = "Has been stopped, We are trying to connect with you but you are not approchable can you assign someone so we can meet and disucss about it..."
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 13), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 12), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        
        let attributedString1 = NSMutableAttributedString(string:"Mill 5 Axis " , attributes:attrs1 as [NSAttributedString.Key : Any])
        
        let attributedString2 = NSMutableAttributedString(string:details.capitalized , attributes:attrs2 as [NSAttributedString.Key : Any])
        
        attributedString1.append(attributedString2)
        
        self.lblDetails.attributedText = attributedString1
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
