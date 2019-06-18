//
//  NoteLocalRef.m
//  CalloutDemo
//
//  Created by Ciprian Rarau on 2015-08-13.
//
//

#import "Note.h"

@implementation Note

- (id) initWithTitle:(NSString *) title businessID:(NSString *)businessId businessAddress:(NSString *) address  businessDistance:(NSString *)distance profileImg:(NSString *) profileImage businessTerm:(NSString *)businessTerm offerName:(NSString *)offerName offerTime:(NSString *)offerTime avgBusy:(NSInteger)avgBusy avgSeating:(NSInteger) avgSeating avgMF:(NSInteger) avgMF avgHotness:(NSInteger) avgHotness recentRateName:(NSString *)rateName recentRateTime:(NSString *)rateTime recentRateBadge:(NSInteger) rateBadge recentRateBusy:(NSInteger) recentBusy recentRateSeating:(NSInteger) recentSeating recentRateMF:(NSInteger) recentRateMF recentRateHotness:(NSInteger)recentHoteness businessCity:(NSString *) city businessHotSpot:(NSInteger) businessHotSpot
{
    self = [super init];
    if (self) {
        _title                      = title;
        _businessImageUrl           = profileImage;
        _businessId                 = businessId;
        _businessTerm               = businessTerm;
        _offerName                  = offerName;
        _offerTime                  = offerTime;
        _avgBusy                    = avgBusy;
        _avgSeating                 = avgSeating;
        _avgMaleFemaleRatio         = avgMF;
        _avgHotness                 = avgHotness;
        _recentRateName             = rateName;
        _recentRateTime             = rateTime;
        _recentRateBadge            = rateBadge;
        _recentRateBusy             = recentBusy;
        _recentRateSeating          = recentSeating;
        _recentRateMaleFemaleRatio  = recentRateMF;
        _recentRateHotness          = recentHoteness;
        _businessAddress            = address;
        _businessDistance           = distance;
        _businessCity               = city;
        _businessHotSpot            = businessHotSpot;
    }
    return self;
}
@end
