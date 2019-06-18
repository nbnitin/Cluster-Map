//
//  HotSpotView.swift
//  Should I Go
//
//  Created by Nitin Bhatia on 01/06/19.
//  Copyright © 2019 Nasib Ali Ansari. All rights reserved.
//

import UIKit

class HotSpotView: UIView {

    @IBOutlet weak var offerTimeLabel: UILabel!
    @IBOutlet weak var offerNALabel: UILabel!
    @IBOutlet weak var offerTimeTitleLabel: UILabel!
    @IBOutlet weak var offerNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var currentAvgView: UIView!
    @IBOutlet weak var ratingNALabel: UILabel!
    @IBOutlet weak var goBusinessAction2: UIButton!
    @IBOutlet weak var goBusinessAction: UIButton!
    @IBOutlet weak var searchTermLabel: UILabel!
    @IBOutlet weak var avgGoImageView: UIImageView!
    @IBOutlet weak var avgHotImageView: UIImageView!
    @IBOutlet weak var avgMaleFemaleImage: UIImageView!
    @IBOutlet weak var avgCrowdImage: UIImageView!
    @IBOutlet weak var avgRatingContainerView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var businessTitleLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var ratingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hotImageView: UIImageView!
    @IBOutlet weak var goImageView: UIImageView!
    @IBOutlet weak var maleFemaleImageView: UIImageView!
    @IBOutlet weak var crowdImageView: UIImageView!
    @IBOutlet weak var rateNameLabel: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var rateTimeLabel: UILabel!
    @IBOutlet weak var recentRatingView: UIView!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var lblBusinessAdd: UILabel!
    @IBOutlet weak var lblBusinessName: UILabel!
    @IBOutlet weak var busImage: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var note : Note? = nil{
        didSet {
            businessImageView.layer.masksToBounds = true
            businessImageView.layer.cornerRadius = 5.0
            
            if note!.businessImageUrl != nil {
                
//                CommonMethod.saveFile(note!.businessImageUrl, completionBlock: { (image) -> () in
//                    self.businessImageView.image = image
//                })
            }
            
            if let x = note!.title as? String {
                businessTitleLabel.text = x
            }
            if let x = note!.businessAddress as? String{
                addressLabel.text = "\(x)\n\(note!.businessCity!)"
            }
            if let x = note!.businessTerm as? String {
                searchTermLabel.text = x
            }
            if let x = note!.offerName as? String {
                offerNameLabel.text = x
            }
            if let x = note!.offerTime as? String {
                offerTimeLabel.text = x
            }
            if let x = note!.recentRateTime as? String {
                rateTimeLabel.text = x
            }
            if let x = note!.recentRateName as? String {
                rateNameLabel.text = x
            }
            if let x = note!.businessDistance as? String {
                distanceLabel.text = x + "Miles Away"
            }

            
            crowdImageView.image = setAverageRating(note!.recentRateBusy)
            maleFemaleImageView.image = setMaleFemaleSelected(note!.recentRateMaleFemaleRatio)
            hotImageView.image = setAverageRating(note!.recentRateHotness)
            goImageView.image = setAverageRating(note!.recentRateSeating)
            badgeImageView.image = getBadgeImage(note!.recentRateBadge)
            avgCrowdImage.image = setAverageRating(note!.avgBusy)
            avgMaleFemaleImage.image = setMaleFemaleSelected(note!.avgMaleFemaleRatio)
            avgHotImageView.image = setAverageRating(note!.avgHotness)
            avgGoImageView.image = setAverageRating(note!.avgSeating)
            
            
           // frame.size.width = UIScreen.main.bounds.size.width - 30
           // frame.origin.x = 15
            
            if (note!.offerTime as! String == "") {
                offerNALabel.isHidden = false
                offerNameLabel.isHidden = true
                offerTimeLabel.isHidden = true
                offerTimeTitleLabel.isHidden = true
            } else {
                
                offerNALabel.isHidden = true
                offerNameLabel.isHidden = false
                offerTimeLabel.isHidden = false
                offerTimeTitleLabel.isHidden = false
            }
            
            
            
            if (note!.recentRateTime as! String == "") {
                
                recentRatingView.isHidden = true
                ratingViewHeightConstraint.constant = 0.0
                //frame.size.height -= 42
            } else {
                
                recentRatingView.isHidden = false
                ratingViewHeightConstraint.constant = 42.0
                ratingNALabel.isHidden = true
            }
            
            if note!.avgBusy as! Int != 0 && (note!.recentRateTime as! String == "") {
                
                currentAvgView.isHidden = false
            } else {
                
                currentAvgView.isHidden = true
            }

        }
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed("HotSpotBusinessView", owner: self, options: nil)![0] as! UIView
        addSubview(view)
        view.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight,.flexibleTopMargin]
        goBusinessAction.addTarget(self, action: #selector(goBusiness(_:)), for: .touchUpInside)
        goBusinessAction2.addTarget(self, action: #selector(goBusiness(_:)), for: .touchUpInside)
    }
    
    func getBusinessImage () -> UIImage{
    
    var documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    documentDir = URL(fileURLWithPath: documentDir ?? "").appendingPathComponent("should_i_go").absoluteString
        let pathComponents = URL(fileURLWithPath: note!.businessImageUrl).pathComponents
    documentDir = URL(fileURLWithPath: documentDir ?? "").appendingPathComponent("\(pathComponents[pathComponents.count - 2])_\(pathComponents[pathComponents.count - 1])").absoluteString
        return UIImage(contentsOfFile: documentDir ?? "")!
    }
    
    func setMaleFemaleSelected(_ rating: Int) -> UIImage? {
        
        var image: UIImage? = nil
        
        if rating == 1 {
            
            image = UIImage(named: "male.png")
        } else if rating == 2 {
            
            image = UIImage(named: "equal.png")
        } else {
            
            image = UIImage(named: "female.png")
        }
        return image
    }

    func setAverageRating(_ rating: Int) -> UIImage? {
        
        var image: UIImage? = nil
        if rating == 1 {
            
            image = UIImage(named: "red_selected.png")
        } else if rating == 2 {
            
            image = UIImage(named: "yellow_selected.png")
        } else {
            
            image = UIImage(named: "green_selected.png")
        }
        return image
    }
    
    func getBadgeImage(_ badgePoint: Int) -> UIImage? {
        
        var image: UIImage? = nil
        if badgePoint >= 0 && badgePoint <= 4 {
            image = UIImage(named: "beer-taster.png")
        } else if badgePoint >= 5 && badgePoint <= 10 {
            image = UIImage(named: "beer-chugger.png")
        } else if badgePoint >= 11 && badgePoint <= 18 {
            image = UIImage(named: "wine-sipper.png")
        } else if badgePoint >= 19 && badgePoint <= 25 {
            image = UIImage(named: "wine-connoisseur.png")
        } else if badgePoint >= 26 && badgePoint <= 35 {
            image = UIImage(named: "House-Margarita.png")
        } else if badgePoint >= 36 && badgePoint <= 45 {
            image = UIImage(named: "cadilac-margarita.png")
        } else if badgePoint >= 46 && badgePoint <= 57 {
            image = UIImage(named: "straight-up-martini.png")
        } else if badgePoint >= 60 && badgePoint <= 70 {
            image = UIImage(named: "dirty-martini.png")
        } else if badgePoint >= 71 && badgePoint <= 86 {
            image = UIImage(named: "single-shot.png")
        } else {
            image = UIImage(named: "shot-caller.png")
        }
        return image
    }

    @objc func goBusiness(_ sender : UIButton){
        NotificationCenter.default.post(name: NSNotification.Name("GoBusiness"), object: self, userInfo: [
            "business_id": note!.businessId
            ])

    }

}
