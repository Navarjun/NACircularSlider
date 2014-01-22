//
//  NACircularControl.h
//  NACircularControl
//
//  Created by Dronna .com on 25/09/13.
//
//

#import <UIKit/UIKit.h>

#define kNAFrame                    @"NAframe"
#define kNAstartAngle               @"NAstartAngle"
#define kNAendAngle                 @"NAendAngle"
#define kNAisClockwise              @"NAisClockwise"
#define kNAbackgroundLineWidth      @"NAbackgroundLineWidth"
#define kNAbackgroundLineColor      @"NAbackgroundLineColor"
#define kNAangle                    @"NAangle"
#define kNAglowingLineWidth         @"NAglowingLineWidth"
#define kNAglowingLineColor         @"NAglowingLineColor"
#define kNAglowingLineShadowBlur    @"NAglowingLineShadowBlur"
#define kNAhandleColor              @"NAhandleColor"
#define kNAhandleShadowBlur         @"NAhandleShadowBlur"


@protocol NACircularControlDelegate

-(void) NAangleChanged:(int) angle;

@end


@interface NACircularControl : UIControl {
    id<NACircularControlDelegate> delegate;
}

@property(nonatomic, strong) id<NACircularControlDelegate> delegate;

-(id) initWithDict:(NSDictionary*)parametersDict;
/* ------- Parameters Dict details --------
 Key : Value
 
 @compulsary
 kNAFrame : NSValue wrapped CGrect
 
 @optional
 kNAstartAngle :            NSNumber wrapped float value
 kNAendAngle :              currently not in use
 kNAisClockwise :           currently not in use
 kNAbackgroundLineWidth :   NSNumber wrapped float value
 kNAbackgroundLineColor :   UIColor Object
 kNAangle :                 NSNumber wrapped int(relative to startAngle, but will be returned absolutely and you have to handle it)
 kNAglowingLineWidth :      NSNumber wrapped float value
 kNAglowingLineColor :      UIColor object
 kNAglowingLineShadowBlur : NSNumber wrapped float value
 kNAhandleColor :           UIColor object
 kNAhandleShadowBlur :      NSNumber wrapped float value
 
 ----------------------------------------*/


@end
