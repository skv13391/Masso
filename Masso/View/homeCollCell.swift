//
//  homeCollCell.swift
//  Masso
//
//  Created by Sunil on 27/03/23.
//

import UIKit

class homeCollCell: UICollectionViewCell {
    
    @IBOutlet weak var imgUSer: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMCode: UILabel!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var lblCircle: UILabel!
    @IBOutlet weak var lblStateNaem: UILabel!
    @IBOutlet weak var lblHr: UILabel!
    @IBOutlet weak var btnMsg: UIButton!
    
    @IBOutlet weak var lblRunningBy: UILabel!
    @IBOutlet weak var bellView: UIView!
    @IBOutlet weak var msgView: UIView!
    @IBOutlet weak var btnToggel: UIButton!
    @IBOutlet weak var imgMsg: UIImageView!
    @IBOutlet weak var imgBell: UIImageView!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.stateView.layer.cornerRadius = self.stateView.frame.size.height / 2
        self.stateView.clipsToBounds = true
        
        self.bellView.layer.cornerRadius = 13
        self.bellView.clipsToBounds = true
        
        self.msgView.layer.cornerRadius = self.msgView.frame.size.height / 2
        self.msgView.clipsToBounds = true
        self.lblName.textColor = UIColor.white
        self.lblName.font =  UIFont(name: "Inter-Bold", size: 14)

        self.lblMCode.textColor = UIColor.init(red: 122.0/255.0, green: 144.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        self.lblMCode.font =  UIFont(name: "Inter-Regualr", size: 12)
        self.lblMCode.text = "G3-7001"
        // Initialization code
    }

   
    
    
}
