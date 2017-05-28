//
//  ViewController.m
//  Desert Survival
//
//  Created by ali arda eker on 2/26/17.
//  Copyright © 2017 AliArdaEker. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation ViewController
@synthesize fire;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    _displayLink = [CADisplayLink displayLinkWithTarget:_gameView selector:@selector(arrange:)];
    [_displayLink setPreferredFramesPerSecond:30];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Background image is set with dessert road.
    UIImageView *iView;
    UIImage *image = [UIImage imageNamed:@"desert"];
    CGRect bounds = [[_gameView viewWithTag:10] bounds];
    
    UIGraphicsBeginImageContext(bounds.size);
    [image drawInRect:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    iView = [[UIImageView alloc] initWithImage:destImage];
    [[_gameView viewWithTag:10] addSubview:iView];
    iView.layer.zPosition = -1;
    
    [_gameView fixSize];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)speedChange:(id)sender
{
    UISlider *s = (UISlider *)sender;
    // NSLog(@"tilt %f", (float)[s value]);
    [_gameView setTilt:(float)[s value]];
}

- (IBAction) fire:(UIButton *)sender
{
    [_gameView fire];
}

@end
