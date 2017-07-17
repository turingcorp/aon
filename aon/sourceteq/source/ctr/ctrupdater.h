#import "appdel.h"

@class ctrgame;

@interface ctrupdater:NSObject<GLKViewControllerDelegate>

-(ctrupdater*)init:(ctrgame*)_game;

@property(weak, nonatomic)ctrgame *game;

@end