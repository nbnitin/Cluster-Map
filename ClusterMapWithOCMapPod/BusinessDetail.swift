//
//  BusinessDetail.swift
//  Should I Go
//
//  Created by Nasib Ali Ansari on 10/12/15.
//  Copyright © 2015 Nasib Ali Ansari. All rights reserved.
//

import UIKit

class BusinessDetail: NSObject {
    
    
    var businessId : String!
    var businessName : String!
    var businessImage : UIImage!
    var businessDescription : String!
    var businessLatitude : Double!
    var businessLongitude : Double!
    var businessTotalLike : Int!
    var businessTotalDisLike : Int!
    var businessTotalDisLikeStatus: Int!
    var businessAddress : String!
    var businessLikePercent : Int!
    var businessAvgRating : BusinessAverageRating!
    var businessRecentRating : BusinessAverageRating!
    var businessDistance : Double?
    var businessImageUrl : String!
    var businessHeighestRateTime : String?
    var businessFavorit : Int!
    var businessTerm    : String?
    var offer           : Offer?
    var businessUserRating : BusinessAverageRating?
    var businessCity : String?
    var hotSpot : Int!
    

    init(businessDataDic : Dictionary<String, AnyObject>) {
        
        super.init()
        self.businessId                 = (businessDataDic[NABusinessIdKey] as? String)!
        self.businessName               = (businessDataDic[NABusinessNameKey] as? String)!
        self.businessFavorit            = businessDataDic[NABusinessAddFavorite]?.intValue
      //  self.businessTerm               = (businessDataDic[NABusinessTermKey] as? String)!
        if !(businessDataDic[NABusinessImageUrlKey]!.isKind(of: NSNull.self)){
            
            let imageUrl                    = (businessDataDic[NABusinessImageUrlKey] as? String)!
            self.businessImageUrl           = (businessDataDic[NABusinessImageUrlKey] as? String)!

//            CommonMethod.saveFile(imageUrl, completionBlock: { (image) -> () in
//
//                self.businessImage  = image
//            })
            self.businessImage = UIImage(named:"default_img.png")

        }else{
            self.businessImage = UIImage(named:"default_img.png")
        }
        
        if !(businessDataDic[NABusinessAddress]!.isKind(of: NSNull.self)){
            
            self.businessAddress            = (businessDataDic[NABusinessAddress] as? [String])?.first != nil ? (businessDataDic[NABusinessAddress] as? [String])?.first : ""
            self.businessCity               = (businessDataDic[NABusinessAddress] as? [String])?.last != nil ? (businessDataDic[NABusinessAddress] as? [String])?.last : ""
        }
        
        if businessDataDic[NABusinessRecentOffer]!.isKind(of: NSNull.self) == false{
            
             self.offer                      = Offer(recentOfferDir:(businessDataDic[NABusinessRecentOffer]  as? Dictionary)!)
        }else{
            
            self.offer = Offer()
        }
       
        self.businessLatitude           = businessDataDic[NABusinessLatitudeKey]?.doubleValue
        self.businessLongitude          = businessDataDic[NABusinessLongitudeKey]?.doubleValue
        self.businessTotalDisLikeStatus = businessDataDic[NABusinessLikeDisLikeStatusKey]?.intValue
        if businessDataDic[NARecentRatingKey]!.isKind(of: NSNull.self) == false{
            
             self.businessRecentRating       = BusinessAverageRating(rating: (businessDataDic[NARecentRatingKey] as? Dictionary)!)
        }else{
            
            self.businessRecentRating            = BusinessAverageRating()
        }
       
        if businessDataDic[NAAvgRatingKey]!.isKind(of: NSNull.self) == false{
        
            self.businessAvgRating          = BusinessAverageRating(avgRating: (businessDataDic[NAAvgRatingKey] as? Dictionary)!)
        }else{
            
            self.businessAvgRating          = BusinessAverageRating()
        }
        
        if businessDataDic[NABusinessUserRatingKey]!.isKind(of: NSNull.self) == false{
            
            self.businessUserRating = BusinessAverageRating(currentRating: (businessDataDic[NABusinessUserRatingKey] as? Dictionary)!)
        }else{
         
            self.businessUserRating = BusinessAverageRating()
        }
        
        self.hotSpot = businessDataDic[NABusinessHotSpotKey]?.intValue
    }
    
    class func parseBusinessData(_ businessDataArray : [Dictionary<String, AnyObject>], completionBlock: (_ success: Bool, _ data: AnyObject?) -> ()){
        
        
        var businessDetailArray : [BusinessDetail] = Array()
        for index in (0...businessDataArray.count - 1) {
            
            let businessDic :[String:AnyObject] = businessDataArray[index]
            if !(businessDic[NABusinessLatitudeKey] is NSNull || businessDic[NABusinessLatitudeKey] is NSNull){
                
                let business = BusinessDetail(businessDataDic: businessDic)
                businessDetailArray.append(business)
            }
        }
        completionBlock(true, businessDetailArray as AnyObject)
    }
    
    class func parseFavoriteBusinessDetail(_ businessDic : Dictionary<String, AnyObject>, completionBlock: (_ success: Bool, _ data: AnyObject?) -> ()){
    
        let business = BusinessDetail(businessDataDic: businessDic)
        completionBlock(true, business)
    }
}
