//
//  ClusterListTableViewCell.swift
//  Should I Go
//
//  Created by Nasib Ali Ansari on 12/01/16.
//  Copyright © 2016 Nasib Ali Ansari. All rights reserved.
//

import UIKit

protocol ClusterOptionProtocol : class{
    
    func getCluserOption(_ option: BusinessSelection, business : BusinessDetail)
}


class ClusterListTableViewCell: UITableViewCell {

    @IBOutlet weak var avgRateTitleView: UIView!
    @IBOutlet weak var avgRatingContainerView: UIView!
    @IBOutlet weak var recentRatingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var naLabel: UILabel!
    @IBOutlet weak var recentRatingContainerView: UIView!
    @IBOutlet weak var offerExpireTitle: UILabel!
    @IBOutlet weak var notAvailableLabel: UILabel!
    @IBOutlet weak var businessOfferDateLabel: UILabel!
    @IBOutlet weak var businessOfferNameLabel: UILabel!
    @IBOutlet weak var businessAddressLabel: UILabel!
    @IBOutlet weak var businessCategoryLabel: UILabel!
    @IBOutlet weak var highRateTimeLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var highRatedUserNamLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessDistanceLabel: UILabel!
    @IBOutlet weak var highRatedUserBadgeImageView: UIImageView!
    @IBOutlet weak var avgCrowdImageVIew: UIImageView!
    @IBOutlet weak var avgMaleFemaleImageView: UIImageView!
    @IBOutlet weak var avgHotImageView: UIImageView!
    @IBOutlet weak var avgGoImageView: UIImageView!
    @IBOutlet weak var highRatedUserCrowdImageView: UIImageView!
    @IBOutlet weak var highRatedUserMaleFemaleImageView: UIImageView!
    @IBOutlet weak var highRatedUserHotImageView: UIImageView!
    @IBOutlet weak var highRatedUserGoImageView: UIImageView!
    var delegate : ClusterOptionProtocol!
    var business : BusinessDetail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: Class suport methods
    
   
    func setBusinessImage(_ imageUrl : String?){
        
        if imageUrl == nil{
        
            self.businessImageView.image = UIImage(named:"default_img.png")
            return
        }
        
//        CommonMethod.saveFile(imageUrl!) { (image) -> () in
//            DispatchQueue.main.async(execute: { () -> Void in
//             
//                self.businessImageView.image = image
//            })
//        }
    }

    
    // MARK: - IBAction methods
    
    @IBAction func detailButtonAction(_ sender: UIButton) {
        
        delegate.getCluserOption(BusinessSelection.placeDetail, business: business)
    }
  
    @IBAction func uberButtonAction(_ sender: UIButton) {
    
        delegate.getCluserOption(BusinessSelection.bookUber, business: business)
    }
    
    @IBAction func showOnMapButtonAction(_ sender: UIButton) {
    
        delegate.getCluserOption(BusinessSelection.showDirection, business: business)
    }
    
}
