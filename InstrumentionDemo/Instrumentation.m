//
//  Instrumentation.m
//  InstrumentionDemo
//
//  Created by Nicolas Flacco on 11/15/13.
//  Copyright (c) 2013 Nicolas Flacco. All rights reserved.
//

#import "Instrumentation.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface Instrumentation ()

// ViewController that gets passed in
@property (nonatomic) UIViewController *viewController;

// For drawing a circle around a tap
@property (nonatomic, weak) CAShapeLayer *circleLayer;
@property (nonatomic) CGPoint circleCenter;
@property (nonatomic) CGFloat circleRadius;

@end

@implementation Instrumentation

-(id) initWithViewController:(UIViewController *)vc
{
    self = [super init];
    if(self)
    {
        self.viewController = vc;
        [self addGestureInstrumentation];
//        [self addKeyboardInstrumentation];

    }
    return self;
}

- (void)dealloc {
    // Should really happen when view disappears
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

// Keyboard stuff
- (void)addKeyboardInstrumentation
{
    // Should really happen with view did appear
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

// Keyboard Handlers
- (void)keyboardDidShow: (NSNotification *) notif{
    NSLog(@"keyboardDidShow");
}

- (void)keyboardDidHide: (NSNotification *) notif{
    NSLog(@"keyboardDidHide");
}


// Gesture Handlers
- (void)addGestureInstrumentation
{
    
    // double tap (one finger)
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2; // Can use this to differentiate between single/double tap
    doubleTap.numberOfTouchesRequired = 1;  // Number of fingers uses (huh huh)
    [self.viewController.view addGestureRecognizer:doubleTap];
    
    // single tap (one finger)
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    // [tap setCancelsTouchesInView:NO]; // pass tap through to subviews?
    [self.viewController.view addGestureRecognizer:singleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap]; // Can force recognition of double vs single tap
    // see: http://stackoverflow.com/questions/8876202/uitapgesturerecognizer-single-tap-and-double-tap
    
    // long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [longPress setMinimumPressDuration:2.0];
    [self.viewController.view addGestureRecognizer:longPress];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:gesture.view];
    [self drawCircle:location radius:40.0 width:3.0 color:[UIColor redColor] attachTo:gesture.view];
    NSLog(@"single tap location:%@", NSStringFromCGPoint(location));
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:gesture.view];
    [self drawCircle:location radius:40.0 width:3.0 color:[UIColor greenColor] attachTo:gesture.view];
    NSLog(@"double tap location:%@", NSStringFromCGPoint(location));
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    // NOTE: UILongPressGestureRecognizer is continuous so we have to check it has ended.
    // see: http://stackoverflow.com/questions/3319591/uilongpressgesturerecognizer-gets-called-twice-when-pressing-down
    
    if (UIGestureRecognizerStateBegan == gesture.state){
        // Do nothing
    } else if(UIGestureRecognizerStateEnded == gesture.state) {
        // Do end work here when finger is lifted
        
        CGPoint location = [gesture locationInView:gesture.view];
        [self drawCircle:location radius:40.0 width:5.0 color:[UIColor blueColor] attachTo:gesture.view];
        NSLog(@"longPress location:%@", NSStringFromCGPoint(location));
    }
    
}

- (void)drawCircle:(CGPoint)location radius:(CGFloat)radius width:(CGFloat)width color:color attachTo:(UIView *)view
{
    // if there was a previous circle, get rid of it
    [self.circleLayer removeFromSuperlayer];
    
    self.circleCenter = location;
    self.circleRadius = radius;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:self.circleCenter
                    radius:self.circleRadius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    
    // create new CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.fillColor = nil;
    shapeLayer.lineWidth = width;
    [view.layer addSublayer:shapeLayer]; // Add CAShapeLayer to our view
    self.circleLayer = shapeLayer;
    
}

@end
