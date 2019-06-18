#import "NoteCalloutViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NoteCalloutViewController()
@end

@implementation NoteCalloutViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.businessImageView.layer.masksToBounds = YES;
    self.businessImageView.layer.cornerRadius  = 5.0;
    
    if (self.note.businessImageUrl != nil){
        
        self.businessImageView.image = [self getBusinessImage];
    }
    
    self.businessTitleLabel.text      = self.note.title;
    self.addressLabel.text            = [NSString stringWithFormat:@"%@\n%@", self.note.businessAddress, self.note.businessCity];
    self.searchTermLabel.text         = self.note.businessTerm;
    self.offerNameLabel.text          = self.note.offerName;
    self.offerTimeLabel.text          = self.note.offerTime;
    self.rateTimeLabel.text           = self.note.recentRateTime;
    self.rateNameLabel.text           = self.note.recentRateName;
    self.distanceLabel.text           = [NSString stringWithFormat:@"%@ Miles Away", self.note.businessDistance];
    self.crowdImageView.image         = [self setAverageRating:self.note.recentRateBusy];
    self.maleFemaleImageView.image    = [self setMaleFemaleSelected:self.note.recentRateMaleFemaleRatio];
    self.hotImageView.image           = [self setAverageRating:self.note.recentRateHotness];
    self.goImageView.image            = [self setAverageRating:self.note.recentRateSeating];
    self.badgeImageView.image         = [self getBadgeImage:self.note.recentRateBadge];
    self.avgCrowdImageView.image      = [self setAverageRating:self.note.avgBusy];
    self.avgMaleFemaleImageView.image = [self setMaleFemaleSelected:self.note.avgMaleFemaleRatio];
    self.avgHotImageView.image        = [self setAverageRating:self.note.avgHotness];
    self.avgGoImageView.image         = [self setAverageRating:self.note.avgSeating];
    
    CGRect frame     = self.view.frame;
    frame.size.width = [[UIScreen mainScreen] bounds].size.width - 30;
    frame.origin.x   = 15;
    
    if ([self.note.offerTime isEqualToString:@""]){
        self.offerNALabel.hidden        = NO;
        self.offerNameLabel.hidden      = YES;
        self.offerTimeLabel.hidden      = YES;
        self.offerTimeTitleLabel.hidden = YES;
    }else{
        
        self.offerNALabel.hidden        = YES;
        self.offerNameLabel.hidden      = NO;
        self.offerTimeLabel.hidden      = NO;
        self.offerTimeTitleLabel.hidden = NO;
    }
    
    if ([self.note.recentRateTime isEqualToString:@""]){
        
        self.recentRatingView.hidden             = YES;
        self.ratingViewHeightConstraint.constant = 0.0;
        frame.size.height                       -= 42;
        
    }else{
        
        self.recentRatingView.hidden             = NO;
        self.ratingViewHeightConstraint.constant = 42.0;
        self.ratingNALabel.hidden                = YES;
    }
    
    if (self.note.avgBusy == 0) {
        
        self.ratingNALabel.hidden                = NO;
        self.avgRatingContainerView.hidden       = YES;
        
    }else{

        self.ratingNALabel.hidden                = YES;
        self.avgRatingContainerView.hidden       = NO;
    }
    
    if (self.note.avgBusy != 0 && [self.note.recentRateTime isEqualToString:@""]) {
        
        self.currentAvgView.hidden = NO;
    }else{
        
        self.currentAvgView.hidden = YES;
    }
    
    self.view.frame  = frame;
    [self.view layoutIfNeeded];
}


- (IBAction)goBusinessAction:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoBusiness" object:self userInfo:@{@"business_id":self.note.businessId}];
}

- (UIImage *)getBusinessImage{
    
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    documentDir = [documentDir stringByAppendingPathComponent:@"should_i_go"];
    NSArray *pathComponents = self.note.businessImageUrl.pathComponents;
    documentDir = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@", [pathComponents objectAtIndex:pathComponents.count - 2], [pathComponents objectAtIndex:pathComponents.count - 1]]];
    return [UIImage imageWithContentsOfFile:documentDir];
}


-(UIImage *)setMaleFemaleSelected:(NSInteger) rating{
    
   UIImage *image = nil;

    if (rating == 1){
        
        image     = [UIImage imageNamed:@"male.png"];
        
    }else if (rating == 2){
        
        image     = [UIImage imageNamed:@"equal.png"];
        
    }else{
        
        image     = [UIImage imageNamed:@"female.png"];
    }
    return image;
}

- (UIImage *)setAverageRating:(NSInteger) rating{
    
    UIImage *image = nil;
    if (rating == 1){
     
        image     = [UIImage imageNamed:@"red_selected.png"];
        
    }else if (rating == 2){

        image     = [UIImage imageNamed:@"yellow_selected.png"];

    }else{
        
        image     = [UIImage imageNamed:@"green_selected.png"];
    }
    return image;
}

- (UIImage *)getBadgeImage:(NSInteger)badgePoint{
    
     UIImage *image = nil;
    if (badgePoint >= 0 && badgePoint <= 4) {
        image = [UIImage imageNamed:@"beer-taster.png"];
    }else if (badgePoint >= 5 && badgePoint <= 10){
        image = [UIImage imageNamed:@"beer-chugger.png"];
    }else if (badgePoint >= 11 && badgePoint <= 18){
        image = [UIImage imageNamed:@"wine-sipper.png"];
    }else if (badgePoint >= 19 && badgePoint <= 25){
        image = [UIImage imageNamed:@"wine-connoisseur.png"];
    }else if (badgePoint >= 26 && badgePoint <= 35){
        image = [UIImage imageNamed:@"House-Margarita.png"];
    }else if (badgePoint >= 36 && badgePoint <= 45){
        image = [UIImage imageNamed:@"cadilac-margarita.png"];
    }else if (badgePoint >= 46 && badgePoint <= 57){
        image = [UIImage imageNamed:@"straight-up-martini.png"];
    }else if (badgePoint >= 60 && badgePoint <= 70){
        image = [UIImage imageNamed:@"dirty-martini.png"];
    }else if (badgePoint >= 71 && badgePoint <= 86){
        image = [UIImage imageNamed:@"single-shot.png"];
    }else{
        image = [UIImage imageNamed:@"shot-caller.png"];
    }
    return image;
}

@end

