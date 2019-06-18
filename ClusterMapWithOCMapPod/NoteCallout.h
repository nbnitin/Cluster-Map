#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Note.h"

@interface NoteCallout : NSObject

@property (nonatomic,copy) Note * note;

- (UIViewController *) calloutCell;
- (instancetype)initWithNote:(Note *)note;

@end
