//
//  readCell.swift
//  Masso
//
//  Created by Sunil on 29/03/23.
//

import UIKit

class readCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lbldetails: UILabel!
    @IBOutlet weak var lblNAme: UILabel!
    @IBOutlet weak var lblCircel: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.backgroundColor = UIColor.init(red: 28.0/255.0, green: 39.0/255.0, blue: 45.0/255.0, alpha: 0.2)
        
        self.lblNAme.text = "G3-7001"
        self.lblNAme.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblNAme.font =  UIFont(name: "Inter-Medium", size: 12)
        
        self.lblTime.text = "2min ago"
        self.lblTime.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 0.6)
        self.lblTime.font =  UIFont(name: "Inter-Light", size: 10)
        
        
        
        self.lblCircel.layer.cornerRadius = self.lblCircel.frame.size.height / 2
        self.lblCircel.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)
        self.lblCircel.clipsToBounds = true
        
        self.lblPercent.text = "65%"
        self.lblPercent.textColor = UIColor.init(red: 198.0/255.0, green: 149.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        self.lblPercent.font =  UIFont(name: "Inter-SemiBold", size: 13)
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Inter-SemiBold", size: 12), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 12), NSAttributedString.Key.foregroundColor : UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        
        
        let attributedString1 = NSMutableAttributedString(string:"Has been stopped" , attributes:attrs2 as [NSAttributedString.Key : Any])
        
        let attributedString2 = NSMutableAttributedString(string:"Mill 5 Axis " , attributes:attrs1 as [NSAttributedString.Key : Any])
        
        attributedString2.append(attributedString1)
        
        self.lbldetails.font = UIFont(name: "Inter-Medium", size: 12)
        self.lbldetails.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
