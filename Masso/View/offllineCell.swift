//
//  offllineCell.swift
//  Masso
//
//  Created by Sunil on 28/03/23.
//

import UIKit

class offllineCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgMachine: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var viewBell: UIView!
    @IBOutlet weak var btnToggel: UIButton!
    @IBOutlet weak var viewMsg: UIView!
    @IBOutlet weak var imgBel: UIImageView!
    @IBOutlet weak var imgMsg: UIImageView!
    @IBOutlet weak var btnMsg: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgMsg.image = self.imgMsg.image?.withRenderingMode(.alwaysTemplate)
        self.imgMsg.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        self.imgBel.image = self.imgBel.image?.withRenderingMode(.alwaysTemplate)
        self.imgBel.tintColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        self.mainView.layer.cornerRadius = 8
        self.mainView.clipsToBounds = true
        
        self.viewBell.layer.cornerRadius = 13
        self.viewBell.clipsToBounds = true
        
        self.viewMsg.layer.cornerRadius = self.viewMsg.frame.size.height / 2
        self.viewMsg.clipsToBounds = true
        
        
        self.lblName.font =  UIFont(name: "Inter-Bold", size: 14)
        self.lblStatus.font =  UIFont(name: "Inter-Regular", size: 12)

        self.lblName.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.lblStatus.textColor = UIColor.init(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
       
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
