//
//  SMHAlertController.h
//  HSF Container
//
//  Created by Sam Harman on 07/07/2015.
//  Copyright © 2015 Sam Harman. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Subclass of UIAlertController which allows presentation of alert controllers from 
 *  any NSObject subclass without the need to provide a view controller from which to 
 *  present the alert controller.
 *
 *  The class also deals with the queing of multiple alert controllers, and will display
 *  the next queued alert on dismissal of the currently visible alert.
 */
@interface SMHAlertController : UIAlertController

+ ( SMHAlertController * _Nonnull )alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

/**
 *  Calling this method will show the alert controller regardless of the current view heirachy,
 *  and will also queue the alert controller if another instance of 'SMHAlertController' is currently
 *  being shown. Replicating similar functionality to that of UIAlertView's 'show' method we are used to.
 */
- (void)show;

/**
 *  Calling this method will show the alert controller regardless of the current view heirachy,
 *  and will also queue the alert controller if another instance of 'SMHAlertController' is currently
 *  being shown. Replicating similar functionality to that of UIAlertView's 'show' method we are used to.
 *
 *  @param animated Should animate the display of the alert controller or not.
 */
- (void)showAnimated:(BOOL)animated;

/**
 *  Calling this method will show the alert controller regardless of the current view heirachy,
 *  and will also queue the alert controller if another instance of 'SMHAlertController' is currently
 *  being shown. Replicating similar functionality to that of UIAlertView's 'show' method we are used to.
 *
 *  @param animated Should animate the display of the alert controller or not.
 *  @param completion Optional completion block to be called once the presentation of the alert view has completed,
 *                    note that this means once the alert controller is on screen, not that it has been dismissed.
 */
- (void)showAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

@end
