//
//  NoteLocalRef.h
//  CalloutDemo
//
//  Created by Ciprian Rarau on 2015-08-13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Note : NSObject

@property (strong, nonatomic) NSString      *title;
@property (strong, nonatomic) NSString      *businessImageUrl;
@property (assign, nonatomic) NSInteger     avgBusy;
@property (assign, nonatomic) NSInteger     avgSeating;
@property (assign, nonatomic) NSInteger     avgMaleFemaleRatio;
@property (assign, nonatomic) NSInteger     avgHotness;
@property (strong, nonatomic) NSString      *businessId;
@property (assign, nonatomic) NSInteger     recentRateBusy;
@property (assign, nonatomic) NSInteger     recentRateSeating;
@property (assign, nonatomic) NSInteger     recentRateMaleFemaleRatio;
@property (assign, nonatomic) NSInteger     recentRateHotness;
@property (assign, nonatomic) NSInteger     recentRateBadge;
@property (strong, nonatomic) NSString      *recentRateName;
@property (strong, nonatomic) NSString      *recentRateTime;
@property (strong, nonatomic) NSString      *offerName;
@property (strong, nonatomic) NSString      *offerTime;
@property (strong, nonatomic) NSString      *businessTerm;
@property (strong, nonatomic) NSString      *businessAddress;
@property (strong, nonatomic) NSString      *businessDistance;
@property (strong, nonatomic) NSString      *businessCity;
@property (assign, nonatomic) NSInteger     businessHotSpot;


- (id) initWithTitle:(NSString *) title businessID:(NSString *)businessId businessAddress:(NSString *) address  businessDistance:(NSString *)distance profileImg:(NSString *) profileImage businessTerm:(NSString *)businessTerm offerName:(NSString *)offerName offerTime:(NSString *)offerTime avgBusy:(NSInteger)avgBusy avgSeating:(NSInteger) avgSeating avgMF:(NSInteger) avgMF avgHotness:(NSInteger) avgHotness recentRateName:(NSString *)rateName recentRateTime:(NSString *)rateTime recentRateBadge:(NSInteger) rateBadge recentRateBusy:(NSInteger) recentBusy recentRateSeating:(NSInteger) recentSeating recentRateMF:(NSInteger) recentRateMF recentRateHotness:(NSInteger)recentHoteness businessCity:(NSString *) city businessHotSpot:(NSInteger) businessHotSpot;
@end
