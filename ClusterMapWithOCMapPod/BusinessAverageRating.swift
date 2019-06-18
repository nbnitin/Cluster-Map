//
//  BusinessAverageRating.swift
//  Should I Go
//
//  Created by Nasib Ali Ansari on 10/12/15.
//  Copyright © 2015 Nasib Ali Ansari. All rights reserved.
//

import UIKit

class BusinessAverageRating: NSObject {

    var busy : Int?
    var femaleMaleRatio : Int?
    var hotness : Int?
    var seating : Int?
    var ratingTime : String?
    var userName : String?
    var badgePoint : Int?
    var likeStatus : Int?
    var ratingId : Int?
    var ratingText : String?
    var ratingPhotos : [AnyObject]?
    var ratingVideos : [AnyObject]?

    
    override init() {
        
        self.busy               = 0
        self.femaleMaleRatio    = 0
        self.hotness            = 0
        self.seating            = 0
        self.ratingTime         = ""
        self.badgePoint         = 0
        self.userName           = ""
        self.likeStatus         = 0
        self.ratingId           = 0
        self.ratingTime         = ""
        self.ratingPhotos       = nil
    }
    
    init(currentRating : [String : AnyObject]) {
        
        super.init()
        self.busy               = (currentRating[NABusyRatingKey]?.intValue)!
        self.femaleMaleRatio    = (currentRating[NAMaleFemaleRatingKey]?.intValue)!
        self.hotness            = (currentRating[NAHotnessRatingKey]?.intValue)!
        self.seating            = (currentRating[NASeatingRatingKey]?.intValue)!
        self.ratingText         =  currentRating[NAReviewText]?.isKind(of: NSNull.self) == false ? (currentRating[NAReviewText] as? String)! : ""
        self.ratingPhotos       = currentRating[NAReviewPhoto]?.isKind(of: NSNull.self) == true ? nil : currentRating[NAReviewPhoto] as? [AnyObject]
        self.ratingVideos       = currentRating[NAReviewVideo]?.isKind(of: NSNull.self) == true ? nil : currentRating[NAReviewVideo] as? [AnyObject]
    }
    
    
    init(rating : [String:AnyObject]) {
    
        super.init()
        self.busy               = (rating[NABusyRatingKey]?.intValue)!
        self.femaleMaleRatio    = (rating[NAMaleFemaleRatingKey]?.intValue)!
        self.hotness            = (rating[NAHotnessRatingKey]?.intValue)!
        self.seating            = (rating[NASeatingRatingKey]?.intValue)!
        self.ratingTime         = (rating[NARatingTimeKey] as? String)!
        self.badgePoint         = (rating[NARatingPointKey]?.intValue)!
        self.userName           = rating[NALoginName]?.isKind(of: NSNull.self) == true ? "" : (rating[NALoginName] as? String)!
        self.likeStatus         = rating[NAReviewLikeStatus]?.isKind(of: NSNull.self) == false ? (rating[NAReviewLikeStatus]?.intValue)! : 0
        self.ratingId           = (rating[NAReviewId]?.intValue)!
    }
    
    init(userRating: [String:AnyObject]){
        super.init()
        self.busy               = (userRating[NABusyRatingKey]?.intValue)!
        self.femaleMaleRatio    = (userRating[NAMaleFemaleRatingKey]?.intValue)!
        self.hotness            = (userRating[NAHotnessRatingKey]?.intValue)!
        self.seating            = (userRating[NASeatingRatingKey]?.intValue)!
    }
    
    init(avgRating : [String:AnyObject]) {
        
        super.init()
        self.busy               = (avgRating[NAAvgBusyRatingKey]?.intValue)!
        self.femaleMaleRatio    = (avgRating[NAAvgMaleFemaleRatingKey]?.intValue)!
        self.hotness            = (avgRating[NAAvgHotnessRatingKey]?.intValue)!
        self.seating            = (avgRating[NAAvgSeatingRatingKey]?.intValue)!
    }
}
