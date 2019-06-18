//
//  Offer.swift
//  Should I Go
//
//  Created by Nasib Ali Ansari on 29/12/15.
//  Copyright © 2015 Nasib Ali Ansari. All rights reserved.
//

import UIKit

class Offer: NSObject {

    var offerID : Int!
    var offerName : String!
    var offerText : String!
    var offerStartDate : String!
    var offerEndDate : String!
    var offerBusinessName : String!
    var offerBusinessAddress : String!
    var offerBusinessImageURl : String?
    var offerProfileImage = UIImage()
    
    override init(){
        self.offerID                = 0
        self.offerName              = ""
        self.offerText              = ""
        self.offerStartDate         = ""
        self.offerEndDate           = ""
        self.offerBusinessName      = ""
        self.offerBusinessAddress   = ""
    }
    
    
    init(offerDataDic : Dictionary<String, AnyObject>) {
        
        super.init()
        self.offerID                = offerDataDic[NAOfferId]?.intValue
        self.offerName              = offerDataDic[NAOfferName] as? String
        self.offerText              = offerDataDic[NAOfferText] as? String
        self.offerStartDate         = offerDataDic[NAOfferStartDate] as? String
        self.offerEndDate           = offerDataDic[NAOfferEndDate] as? String
        self.offerBusinessName      = offerDataDic[NABusinessNameKey] as? String
        self.offerBusinessAddress   = offerDataDic[NABusinessAddress] as? String
        if !(offerDataDic[NABusinessImageUrlKey]!.isKind(of: NSNull.self)){
            
            self.offerBusinessImageURl  = offerDataDic[NABusinessImageUrlKey] as? String
        }
    }
    
    init(recentOfferDir : Dictionary<String, AnyObject>) {
        
        self.offerName      = recentOfferDir[NAOfferName] as? String
        self.offerStartDate = recentOfferDir[NAOfferStartDate] as? String
        self.offerEndDate   = recentOfferDir[NAOfferEndDate] as? String
    }
    
    
   class func parseOfferData(_ offerDataDic :NSDictionary, completionBlock: (_ success: Bool, _ data: AnyObject?) -> ()){
    
        let offerData = (offerDataDic[NAOffersKey] as? [Dictionary<String, AnyObject>])!
        var offers : [Offer] = Array()
        for index in (0...offerData.count - 1) {
            
            let offerDic :[String:AnyObject] = offerData[index]
            let offer = Offer(offerDataDic: offerDic)
            offers.append(offer)
        }
        CommonMethod.isNextPage = (offerDataDic[NAOfferNextPage] as AnyObject).boolValue
        completionBlock(true, offers as AnyObject)
    }
    
    class func parsePushNotificationData(_ offerDataDic :Dictionary<String, AnyObject>, completionBlock: (_ success: Bool, _ data: AnyObject?) -> ()){
        
        let offer = Offer(offerDataDic: offerDataDic)
        completionBlock(true, offer)
    }
}
