#import "appdel.h"

typedef enum
{
    alerttypegood,
    alerttypebad
}alerttype;

@interface ctralert:UIButton

+(void)alert:(alerttype)_type message:(NSString*)_message;
-(void)display;

@end