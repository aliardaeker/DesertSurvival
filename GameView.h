//
//  GameView.h
//  Desert Survival
//
//  Created by ali arda eker on 2/26/17.
//  Copyright © 2017 AliArdaEker. All rights reserved.
//

#ifndef GameView_h
#define GameView_h

#import <UIKit/UIKit.h>

@interface GameView : UIView {}

@property (nonatomic) float tilt;
@property (nonatomic, strong) NSMutableArray * cactuses;
@property (nonatomic, strong) NSMutableArray * lines;

- (void) arrange: (CADisplayLink *) sender;
- (void) fixSize;
- (void) fire;

@end

#endif /* GameView_h */
