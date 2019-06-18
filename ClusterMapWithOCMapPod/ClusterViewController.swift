//
//  ClusterViewController.swift
//  Should I Go
//
//  Created by Nasib Ali Ansari on 12/01/16.
//  Copyright © 2016 Nasib Ali Ansari. All rights reserved.
//

import UIKit
import MapKit

class ClusterViewController: UIViewController, ClusterOptionProtocol {
    
    var cluserListData : [BusinessDetail]?
    var currentLocation : CLLocation?
    var backGroundImage : UIImage?
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         navView.backgroundColor     = UIColor(patternImage: UIImage(named: "top-img.png")!)
        backgroundImageView.image    = backGroundImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        cluserListData?.sort(by: {$0.hotSpot>$1.hotSpot})
        tableView.reloadData()
    }
    
    // MARK: - TableView data source methods -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return (cluserListData?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cluster_cell") as! ClusterListTableViewCell
        
//        if indexPath.row % 2 != 0{
//            
//            cell.contentView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.8)
//        }else{
//            cell.contentView.backgroundColor = UIColor(colorLiteralRed: 85 / 255.0, green: 85 / 255.0, blue: 85 / 255.0, alpha: 0.8)
//        }
        cell.delegate                   = self
        let businessDetail              = cluserListData![indexPath.row]
        cell.business                   = businessDetail
        cell.setBusinessImage(businessDetail.businessImageUrl)
        cell.selectionStyle             = UITableViewCell.SelectionStyle.none
        cell.businessNameLabel.text     = businessDetail.businessName
        cell.businessDistanceLabel.text = String(format: "%0.2f Miles Away", businessDetail.businessDistance!)
        cell.businessImageView.layer.masksToBounds = true
        cell.businessImageView.layer.cornerRadius  = NACornerRadious
        cell.businessAddressLabel.text          = String(format: "%@\n%@", businessDetail.businessAddress, businessDetail.businessCity!)
        cell.notAvailableLabel.isHidden           = businessDetail.offer?.offerName == "" ? false : true
        cell.offerExpireTitle.isHidden            = businessDetail.offer?.offerName == "" ? true : false
        cell.businessOfferNameLabel.text        = businessDetail.offer?.offerName
//        cell.businessOfferDateLabel.text        = CommonMethod.getOfferTime(businessDetail.offer!.offerStartDate, endTime: businessDetail.offer!.offerEndDate)
        cell.businessCategoryLabel.text         = businessDetail.businessTerm
//        cell.highRateTimeLabel.text             = businessDetail.businessRecentRating.ratingTime != "" ?CommonMethod.getTime(businessDetail.businessRecentRating.ratingTime!) : ""
        cell.highRatedUserNamLabel.text         = businessDetail.businessRecentRating.userName
        cell.highRatedUserBadgeImageView.image  = CommonMethod.getBadgeImage(businessDetail.businessRecentRating.badgePoint!)
        cell.highRatedUserCrowdImageView.image  = CommonMethod.setRatioButtonImage(businessDetail.businessRecentRating.busy!)
        cell.highRatedUserHotImageView.image    = CommonMethod.setRatioButtonImage(businessDetail.businessRecentRating.hotness!)
        cell.highRatedUserMaleFemaleImageView.image = CommonMethod.setMaleFemaleImage(businessDetail.businessRecentRating.femaleMaleRatio!)
        cell.highRatedUserGoImageView.image     = CommonMethod.setRatioButtonImage(businessDetail.businessRecentRating.seating!)
        cell.avgCrowdImageVIew.image            = CommonMethod.setRatioButtonImage(businessDetail.businessAvgRating.busy!)
        cell.avgMaleFemaleImageView.image       = CommonMethod.setMaleFemaleImage(businessDetail.businessAvgRating.femaleMaleRatio!)
        cell.avgHotImageView.image              = CommonMethod.setRatioButtonImage(businessDetail.businessAvgRating.hotness!)
        cell.avgGoImageView.image               = CommonMethod.setRatioButtonImage(businessDetail.businessAvgRating.seating!)
        
        if businessDetail.businessAvgRating.busy == 0{
            
            cell.avgRatingContainerView.isHidden             = true
            cell.naLabel.isHidden                            = false
        }
        else{
            
            cell.avgRatingContainerView.isHidden             = false
            cell.naLabel.isHidden                            = true
        }
        
        if businessDetail.businessRecentRating.ratingTime == ""{
            
            cell.recentRatingViewHeightConstraint.constant = 0
            cell.recentRatingContainerView.isHidden          = true
        }
        else{
            
            cell.recentRatingViewHeightConstraint.constant = 40
            cell.recentRatingContainerView.isHidden          = false
        }
        
        if businessDetail.businessRecentRating.ratingTime == "" && businessDetail.businessAvgRating.busy != 0{
            
            cell.avgRateTitleView.isHidden = false
        }
        else{
            
            cell.avgRateTitleView.isHidden = true
        }
        
        if ( cell.business.hotSpot == 1 ) {
            cell.contentView.backgroundColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 0.8)
        } else {
            cell.contentView.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.8)
        }
        
        
        return cell
    }
    
    // MARK: - UITableView delegate -
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        
        let businessDetail = cluserListData![indexPath.row]
        if businessDetail.businessRecentRating.ratingTime == ""{
            
            return 170
        }
        return 210
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        
//        let businessDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "UserRatingViewController") as! UserRatingViewController
//        let businessDetail               = cluserListData![indexPath.row]
//        businessDetailVC.businessDetail  = businessDetail
//       // businessDetailVC.loginDetail     = loginDetail
//        businessDetailVC.backgroundImage = backGroundImage
//        let businessCoordinate : CLLocation = CLLocation(latitude: businessDetail.businessLatitude, longitude: businessDetail.businessLongitude)
//        let radius : CLLocationDistance = businessCoordinate.distance(from: CLLocation(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude))
//
//        if Testing == false{
//
//            //Checking radius if user come under business radius then he will able to rate the business
//            if ((radius * 3.28084) <= NARatingRadius){
//                businessDetailVC.isUserRate     = true
//            }
//        }else{
//             businessDetailVC.isUserRate     = true
//        }
//        self.navigationController?.pushViewController(businessDetailVC, animated: true)
    }
    
    // MARK: - ClusteringOptionProtocol -
    
    func getCluserOption(_ option: BusinessSelection, business : BusinessDetail) {
        
        if option == BusinessSelection.showDirection{
            
            let endingCoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(business.businessLatitude, business.businessLongitude)
            let endLocation     = MKPlacemark(coordinate: endingCoord, addressDictionary: nil)
            let endingItem      = MKMapItem(placemark: endLocation)
            let launchOptions   = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            endingItem.name     = business.businessName
            endingItem.openInMaps(launchOptions: launchOptions)
            
            
        }else if option == BusinessSelection.bookUber{
            
            // showing the uber app if install in user phone else open web in safari for book the uber
            if (UIApplication.shared.canOpenURL(URL(string: NAUberAppURlString)!)) {
                
                UIApplication.shared.openURL(URL(string: NAUberAppURlString)!)
                
            }else {
                
                UIApplication.shared.openURL(URL(string: NAUberWebURLString)!)
            }
            
        }else{
            
//            let businessDetail = self.storyboard?.instantiateViewController(withIdentifier: "UserRatingViewController") as! UserRatingViewController
//            businessDetail.businessDetail  = business
//            businessDetail.loginDetail     = loginDetail
//            businessDetail.backgroundImage = backGroundImage
//            let businessCoordinate : CLLocation = CLLocation(latitude: business.businessLatitude, longitude: business.businessLongitude)
//            let radius : CLLocationDistance = businessCoordinate.distance(from: CLLocation(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude))
//            
//            if Testing == false{
//            
//                //Checking radius if user come under business radius then he will able to rate the business
//                if ((radius * 3.28084) <= NARatingRadius){
//                    businessDetail.isUserRate     = true
//                }
//            }else{
//                businessDetail.isUserRate = true
//            }
//            self.navigationController?.pushViewController(businessDetail, animated: true)
        }
    }
    
    
    // MARK: - IBAction methods -
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        sender.isEnabled = false
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Class suport methods -
    
    /*
    @description : Set image on ratio button
    @parameter   : ratio of type Int
    @return      : UIImage for ratio
    */
    func setRatioButtonImage(_ ratio: Int) -> UIImage{
        
        if ratio == 1{
            return UIImage(named: "red_selected.png")!
        }else if ratio == 2{
            return UIImage(named: "yellow_selected.png")!
        }else if ratio == 3{
            return UIImage(named: "green_selected.png")!
        }else{
            return UIImage(named: "red_unselected.png")!
        }
    }
    
    func setMaleFemaleImage(_ ratio: Int) -> UIImage{
        
        if ratio == 1{
            return UIImage(named: "male.png")!
        }else if ratio == 2{
            return UIImage(named: "equal.png")!
        }else if ratio == 3{
            return UIImage(named: "female.png")!
        }
        
        return UIImage(named: "equal.png")!
        
    }
}
