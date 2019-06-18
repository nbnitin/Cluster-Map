//
//  SMHAlertController.m
//  HSF Container
//
//  Created by Sam Harman on 07/07/2015.
//  Copyright © 2015 Sam Harman. All rights reserved.
//

#import "SMHAlertController.h"

#pragma mark - UIApplication Category

/**
 *  Category on UIApplication allowing us to traverse the view heirachy, we use this to
 *  attempt to find the correct place from which to present the alert controller. It 
 *  contains a couple of convinence methods really, nothing more.
 */
@interface UIApplication (topMostViewController)

/**
 *  The topmost controller is the view controller currently being displayed to 
 *  the user, this includes any modal view controllers that might be being displayed.
 *
 *  @return The top most view controller object
 */
+ (UIViewController*) topMostController;


/**
 *  The controller for which we should use to present the alert, note this is not
 *  inherrently the 'topMostController' as if the top most controller happens to be
 *  a UIAlertController (or subclass of) you cannot display another Alert Controller
 *  ontop, which is why we need the 'SMHAlertQueue' class below.
 *
 *  @return The highest view controller object which can be used to present a UIAlertController
 */
+ (UIViewController *) controllerForPresentingAlert;

@end


@implementation UIApplication (topMostViewController)

+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        
        topController = topController.presentedViewController;
    }
    
    return topController;
}


+ (UIViewController *) controllerForPresentingAlert
{
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *lastController;
    
    while (topController.presentedViewController) {
        
        if ([topController.presentedViewController isKindOfClass:[UIAlertController class]]) {
            return lastController;
        }
        
        lastController = topController.presentedViewController;
        topController = topController.presentedViewController;
    }
    
    return topController;
    
}

@end


#pragma mark - SMH Alert Queue

/**
 *  A singleton class responsible for managing the queing of multiple 'SMHAlertController' objects. 
 *  You should not interact with this class, just use the 'SMHAlertController' methods and this is all
 *  taken care of for you.
 */
@interface SMHAlertQueue : NSObject

/**
 *  If an SMHAlertController is shown (using one of the supplied convineince methods) while another
 *  alert controller is on screen, it will be added to this array which acts as a FIFO queue.
 */
@property (nonatomic, strong) NSMutableArray * alertOperations;

/**
 *  This operation queue is used to execute the operation blocks added to 'alertOperations'.
 */
@property (nonatomic, strong) NSOperationQueue * alertQueue;

+ (SMHAlertQueue *)sharedInstance;

@end

@implementation SMHAlertQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _alertOperations = [[NSMutableArray alloc] initWithCapacity:0];
        _alertQueue = [[NSOperationQueue alloc] init];
        
        [_alertQueue setMaxConcurrentOperationCount:1];
        
    }
    return self;
}

+ (SMHAlertQueue *) sharedInstance {
    
    static SMHAlertQueue *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SMHAlertQueue alloc] init];
    });
    return sharedInstance;
    
}

@end



#pragma mark - SMH Alert Controller



@interface SMHAlertController ()

typedef void (^ _Nullable DisplayCompletionBlock)();

/**
 *  The completion block is called on dismissal of the SMHAlertController and is used
 *  internally within the SMHAlertController class to pull the next alert controller
 *  from the SMHAlertQueue stack, and send to the operation queue to display.
 */
@property (nonatomic, copy) DisplayCompletionBlock completionHandler;

@end

@implementation SMHAlertController

+ (SMHAlertController * _Nonnull )alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message
{
    
    return [SMHAlertController alertControllerWithTitle:title
                                                message:message
                                         preferredStyle:UIAlertControllerStyleAlert];
    
}

- (void)show
{
    
    [self showAnimated:YES completion:nil];
    
}

- (void)showAnimated:(BOOL)animated
{

    [self showAnimated:animated completion:nil];
    
}

- (void)showAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion
{
    
    [self setCompletionHandler:^{
        
        NSBlockOperation * alertOperation = [[[SMHAlertQueue sharedInstance] alertOperations] firstObject];
        
        [[[SMHAlertQueue sharedInstance] alertOperations] removeObject:alertOperation];
        
        [[[SMHAlertQueue sharedInstance] alertQueue] addOperation:alertOperation];
        
        
    }];
    
    
    NSBlockOperation * showAlertOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        //TODO: Messy & Code Duplication (But safe) - Clean this up...
        
        if ([NSThread isMainThread]) {
            
            [[UIApplication controllerForPresentingAlert] presentViewController:self
                                                                       animated:animated
                                                                     completion:completion];

        } else {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [[UIApplication controllerForPresentingAlert] presentViewController:self
                                                                           animated:animated
                                                                         completion:completion];
                
            });

        }
        
    }];
    
    
    /**
     *  If the top most controller is a UIAlertController, we know we have to add our alert to the
     *  queue, if it isn't then we can add it to the operation queue straight away.
     */
    if ([[UIApplication topMostController] isKindOfClass:[UIAlertController class]]) {
        [[[SMHAlertQueue sharedInstance] alertOperations] addObject:showAlertOperation];
    } else {
        [[[SMHAlertQueue sharedInstance] alertQueue] addOperation:showAlertOperation];
    }
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    
    /**
     *  The alert view has been dismissed, so call the completion handler we populated
     *  earlier to pull the next alert controller off the stack and show it.
     */
    
    self.completionHandler();
    
}


@end
