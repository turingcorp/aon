#import "vibtn.h"

@implementation vibtn

@synthesize maincolor;

-(vibtn*)init:(NSInteger)_xpos ypos:(NSInteger)_ypos
{
    self = [super initWithFrame:CGRectMake(_xpos, _ypos, 60, 50)];
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self hover];
    
    return self;
}

-(void)setSelected:(BOOL)_selected
{
    [super setSelected:_selected];
    [self hover];
}

-(void)setHighlighted:(BOOL)_highlighted
{
    [super setHighlighted:_highlighted];
    [self hover];
}

#pragma mark functionality

-(void)hover
{
    if(self.isSelected || self.isHighlighted)
    {
        [self setTintColor:maincolor];
    }
    else
    {
        [self setTintColor:[UIColor colorWithWhite:0.7 alpha:1]];
    }
    
    [self setNeedsDisplay];
}

@end

@implementation vibtnpause
{
    CGRect rectcirca;
    CGRect rectcircb;
    CGRect rectcircc;
    CGRect rectcircd;
}

-(vibtnpause*)init:(NSInteger)_xpos ypos:(NSInteger)_ypos
{
    self = [super init:_xpos ypos:_ypos];
 
    rectcirca = CGRectMake(18, 1, 8, 8);
    rectcircb = CGRectMake(18, 21, 8, 8);
    rectcircc = CGRectMake(34, 1, 8, 8);
    rectcircd = CGRectMake(34, 21, 8, 8);
    self.maincolor = colorred;
    
    [self hover];
    
    return self;
}

-(void)drawRect:(CGRect)_rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 8);
    CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor);
    CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
    CGContextMoveToPoint(context, 22, 5);
    CGContextAddLineToPoint(context, 22, 25);
    CGContextMoveToPoint(context, 38, 5);
    CGContextAddLineToPoint(context, 38, 25);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextAddEllipseInRect(context, rectcirca);
    CGContextAddEllipseInRect(context, rectcircb);
    CGContextAddEllipseInRect(context, rectcircc);
    CGContextAddEllipseInRect(context, rectcircd);
    CGContextDrawPath(context, kCGPathFill);
}

@end