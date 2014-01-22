//
//  NACircularControl.m
//  NACircularControl
//
//  Created by Dronna .com on 25/09/13.
//
//

#import "NACircularControl.h"


//convert degrees to radians
#define deg2Rad(degrees)  ((degrees/180.0f)*M_PI)
// convert radians to degrees
#define rad2Deg(radians)  ((radians*180.0f)/M_PI)
// square function
#define sqr(x)			((x)*(x))

#pragma mark --Private Part--

@interface NACircularControl(){
    // Can be defined by the calling class, in degrees
    float startAngle;
    float endAngle;
    
    // Whether to rotate Clockwise(1) or Anti-Clockwise(0-default)
    int isClockwise; // currently not in use
    
    // --background line--
    //width: default-40
    float backgroundLineWidth;
    //color: default-black
    UIColor *backgroundLineColor;
    
    // the value of angle(in degrees) at which control is currently located used for internal library
    int angle;
    // the value of angle(in degrees) at which control is currently located relative to start angle
    int outputAngle;
    
    // --glowing line--
    //width: default-40
    float glowingLineWidth;
    //color: default-blue
    UIColor *glowingLineColor;
    //shadow blur: default-3.0f
    float glowingLineShadowBlur;
    
    // --Handle--
    //shadow blur: default-3.0f
    float handleShadowBlur;
    //color: default-blue
    UIColor *handleColor;
    
    
    float radius;
}
@end


#pragma mark --Implementation--

@implementation NACircularControl

@synthesize delegate;

-(id) initWithDict:(NSDictionary*)parametersDict {
    CGRect frame = [[parametersDict valueForKey:kNAFrame] CGRectValue];
    self = [self initWithFrame:frame];
    if (self) {
        //start angle
        if ([parametersDict valueForKey:kNAstartAngle]) {
            startAngle = [[parametersDict valueForKey:kNAstartAngle] floatValue];
        } else {
            startAngle = 0.0f;
        }
        
        //end angle
        if ([parametersDict valueForKey:kNAendAngle]) {
            endAngle = 360.0f;
        }
        
        //isClockwise
        if (YES || [parametersDict valueForKey:kNAisClockwise]) {
            isClockwise = 0.0f;
        }
        
        //background line width
        if ([parametersDict valueForKey:kNAbackgroundLineWidth]) {
            backgroundLineWidth = [[parametersDict valueForKey:kNAbackgroundLineWidth] floatValue];
        } else {
            backgroundLineWidth = 60.0f;
        }
        
        //background line color
        if ([parametersDict valueForKey:kNAbackgroundLineColor]) {
            backgroundLineColor = [parametersDict valueForKey:kNAbackgroundLineColor];
        } else {
            backgroundLineColor = [UIColor blackColor];
        }
        
        //initial angle
        if ([parametersDict valueForKey:kNAangle]) {
            angle = [[parametersDict valueForKey:kNAangle] intValue];
        } else {
            angle = startAngle + 0.0f;
            outputAngle = angle;
        }
        
        //glowing line width
        if ([parametersDict valueForKey:kNAglowingLineWidth]) {
            glowingLineWidth = [[parametersDict valueForKey:kNAglowingLineWidth] floatValue];
        } else {
            glowingLineWidth = 40.0f;
        }
        
        //glowing line color
        if ([parametersDict valueForKey:kNAglowingLineColor]) {
            glowingLineColor = [parametersDict valueForKey:kNAglowingLineColor];
        } else {
            glowingLineColor = [UIColor blueColor];
        }
        
        //glowing line shadow blur
        if ([parametersDict valueForKey:kNAglowingLineShadowBlur]) {
            glowingLineShadowBlur = [[parametersDict valueForKey:kNAglowingLineShadowBlur] floatValue];
        } else {
            glowingLineShadowBlur = 3.0f;
        }
        
        //handle color
        if ([parametersDict valueForKey:kNAhandleColor]) {
            handleColor = [parametersDict valueForKey:kNAhandleColor];
        } else {
            handleColor = [UIColor whiteColor];
        }
        
        //handle shadow blur
        if ([parametersDict valueForKey:kNAhandleShadowBlur]) {
            handleShadowBlur = [[parametersDict valueForKey:kNAhandleShadowBlur] floatValue];
        } else {
            handleShadowBlur = 3.0f;
        }
        
        // other initializers
        radius = self.frame.size.width/2.0f - 60.0f;
        self.opaque = NO;
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

#pragma mark - Touch Action Handlers -

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    //We need to track continuously
    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    //Get touch location
    CGPoint lastPoint = [touch locationInView:self];

    //Use the location to design the Handle
    [self movehandle:lastPoint];
    
    //Notifying that value has changed
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
}


#pragma mark --Drawing Functions--

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // --Draw the background -- //
    
    //Create the path
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, deg2Rad(startAngle), M_PI*2, 0.0f);
    //Set the stroke color to black
    [backgroundLineColor setStroke];
    //Define line width and cap
    CGContextSetLineWidth(ctx, backgroundLineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    
    //draw it!
    CGContextDrawPath(ctx, kCGPathStroke);
    
    
    // --Draw the circle with a clipped gradient-- //
    
    
    //The mask image
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef imageCtx = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(imageCtx, self.frame.size.width/2  , self.frame.size.height/2, radius, deg2Rad(startAngle), deg2Rad(angle), 0.0f);
    [[UIColor redColor]set];
    
    //Shadow to create the Blur effect
    CGContextSetShadowWithColor(imageCtx, CGSizeMake(0, 0), glowingLineShadowBlur, [UIColor blackColor].CGColor);
    
    //Define the path
    CGContextSetLineWidth(imageCtx, glowingLineWidth);
    CGContextDrawPath(imageCtx, kCGPathStroke);
    
    //Save the context content into the image mask
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    
    
    //Clip the context onto Image Mask
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, self.bounds, mask);
    CGImageRelease(mask);
    
    //Highlighted Area
    CGRect selfRect = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    CGContextAddRect(ctx, selfRect);
    [glowingLineColor setFill];
    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);

    [self drawTheHandle:ctx];
}

-(void) drawTheHandle:(CGContextRef)ctx{
    // --Draws the white handle-- //
    
    CGContextSaveGState(ctx);
    
    //Shadows
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3.0f, [UIColor blackColor].CGColor);
    
    //Get the handle position
    CGPoint handleCenter =  [self pointFromAngle: angle];
    
    //Draw It!
    [[UIColor whiteColor]set];
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, glowingLineWidth, glowingLineWidth));
    
    CGContextRestoreGState(ctx);
}

#pragma mark - Mathamatical Functions -

-(void)movehandle:(CGPoint)lastPoint{
    
    //Get the center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
    int angleInt = floor(currentAngle);

    //Store the new angle
    angle = 360 - angleInt;
    
    //Redraw
    [self setNeedsDisplay];
    outputAngle = angle - startAngle;
    if (outputAngle < 0) {
        outputAngle += 360;
    }
    [delegate NAangleChanged:outputAngle];
}

-(CGPoint)pointFromAngle:(int)angleInt{
    // --Returns point position on circumference at particular angle--
    
    //Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - glowingLineWidth/2, self.frame.size.height/2 - glowingLineWidth/2);
    
    //The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(deg2Rad(-angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(deg2Rad(-angleInt)));
    
    return result;
}

//Sourcecode from Apple example clockControl
//Calculate the direction in degrees from a center point to an arbitrary position.
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(sqr(v.x) + sqr(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = rad2Deg(radians);
    return (result >=0  ? result : result + 360.0);
}

@end
