#import "appdel.h"

@interface vibtn:UIButton

-(vibtn*)init:(NSInteger)_xpos ypos:(NSInteger)_ypos;

@property(strong, nonatomic)UIColor *maincolor;

@end

@interface vibtnpause:vibtn

@end