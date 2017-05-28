//
//  SecondViewController.m
//  Desert Survival
//
//  Created by ali arda eker on 3/2/17.
//  Copyright © 2017 AliArdaEker. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    // Background image is set with dessert road.
    UIImageView *iView;
    UIImage *image = [UIImage imageNamed:@"combat"];
    CGRect bounds = [self.view bounds];
    
    UIGraphicsBeginImageContext(bounds.size);
    [image drawInRect:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    iView = [[UIImageView alloc] initWithImage:destImage];
    [self.view addSubview:iView];
    iView.layer.zPosition = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
