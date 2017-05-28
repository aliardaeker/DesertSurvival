//
//  ViewController.h
//  Desert Survival
//
//  Created by ali arda eker on 2/26/17.
//  Copyright © 2017 AliArdaEker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameView.h"

@interface ViewController : UIViewController
@property (nonatomic, strong) IBOutlet GameView *gameView;
@property (nonatomic, strong) IBOutlet UIButton *fire;

@end

