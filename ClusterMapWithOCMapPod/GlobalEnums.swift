//
//  GlobalEnums.swift
//  Should I Go
//
//  Created by Nasib Ali Ansari on 01/12/15.
//  Copyright © 2015 Nasib Ali Ansari. All rights reserved.
//

import UIKit


struct GlobalEnum {
    
    enum ServiceApis : Int{
        case loginApi = 0
        case searchLocationApi
        case getUserRatingApi
        case businessRatingApi
        case businessReviewApi
        case likedisLikeReview
        case photoUploadApi
        case vedioUploadApi
        case offerListApi
        case userLocationApi
        case pushNotificationApi
        case getSettingApi
        case setSettingApi
        case businessFavoriteGetApi
        case businessFavoriteSetApi
        case businessFavoriteDetailApi
        case registrationApi
    };
    
    enum ServiceStatus : Int{
      
        case success = 1, fail = 0
    };
    
    enum BusinessSelectionPopUp : Int{
        case placeDetail = 0, bookUber, showDirection
    };
    
    enum PostRating : Int{
        
        case postRatingText = 1, postRatingUploadPhoto, postRatingEditText
    };
    
    enum SettingMenu : Int{
        
        case settingMenuSearchItem           = 0
        case settingMenuStoreItem            = 1
        case settingMenuDiscountItem         = 10
        case settingMenuPushNotify           = 11
        case settingMenuSpecificBusinessItem = 12
    };
}

typealias ServiceApi        = GlobalEnum.ServiceApis;
typealias ServiceStatus     = GlobalEnum.ServiceStatus;
typealias BusinessSelection = GlobalEnum.BusinessSelectionPopUp;
typealias PostRating        = GlobalEnum.PostRating;
typealias SettingMenu       = GlobalEnum.SettingMenu;
