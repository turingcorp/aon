#import "appdel.h"

extern NSInteger screenwidth;
extern NSInteger screenwidth_2;
extern NSInteger screenheight;
extern NSInteger screenheight_2;
extern NSInteger displayheight;
extern CGRect screenrect;
extern apptype applicationtype;

@interface updater:NSObject<UIAlertViewDelegate>

+(updater*)sha;
-(void)update;
-(void)asktorate;

@end
