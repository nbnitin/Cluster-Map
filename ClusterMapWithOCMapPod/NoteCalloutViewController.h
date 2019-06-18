#import <UIKit/UIKit.h>
#import "Note.h"

@interface NoteCalloutViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnGoTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *currentAvgView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong) Note                      * note;
@property (weak, nonatomic) IBOutlet UILabel            *offerNALabel;
@property (weak, nonatomic) IBOutlet UIView             *recentRatingView;
@property (weak, nonatomic) IBOutlet UILabel            *ratingNALabel;
@property (weak, nonatomic) IBOutlet UIView             *avgRatingContainerView;
@property (weak, nonatomic) IBOutlet UILabel            *offerTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *businessImageView;
@property (weak, nonatomic) IBOutlet UILabel            *businessTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *badgeImageView;
@property (weak, nonatomic) IBOutlet UILabel            *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel            *searchTermLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ratingViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel            *offerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *offerTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel            *rateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel            *rateNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *crowdImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *maleFemaleImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *hotImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *goImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *avgCrowdImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *avgMaleFemaleImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *avgHotImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *avgGoImageView;

@end
