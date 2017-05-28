//
//  GameView.m
//  Desert Survival
//
//  Created by ali arda eker on 2/26/17.
//  Copyright © 2017 AliArdaEker. All rights reserved.
//

#import "GameView.h"
#import "ViewController.h"

@implementation GameView
@synthesize tilt, cactuses, lines;
int coordinates[2][20];
int lineCoordinates[2][10];
int tankCoordinates[2];
int bombCoordinates[2];
int bulletCoordinates[2];
UIImageView *tank, *gameOverView, *bomb, *bullet;
CGRect bounds;
bool firstTiltFlag = true;
int startingPointRoad, endingPointRoad, score;
UIButton * restartButton;
UILabel * scoreLabel;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void) fixSize
{
    bounds = [[self viewWithTag:10] bounds];
    startingPointRoad = bounds.size.width / 46 * 13;
    endingPointRoad = bounds.size.width / 46 * 33;
    
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(endingPointRoad, 30, bounds.size.width - endingPointRoad, 30)];
    score = 0;
    [scoreLabel setText:@"Score: 0"];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.layer.zPosition = 999;
    [scoreLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
    scoreLabel.textColor = [UIColor whiteColor];
    [[self viewWithTag:10] addSubview:scoreLabel];
    
    restartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [restartButton addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
    [restartButton setTitle:@"Restart" forState:UIControlStateNormal];
    restartButton.frame = CGRectMake(0, 0, 260, 80);
    restartButton.center = CGPointMake(startingPointRoad + (endingPointRoad - startingPointRoad) / 2, bounds.size.height / 2.4);
    restartButton.layer.zPosition = 1002;
    restartButton.titleLabel.font = [UIFont systemFontOfSize:25];
    restartButton.hidden = YES;
    [[self viewWithTag:10] addSubview:restartButton];
    
    gameOverView = [[UIImageView alloc]initWithFrame:bounds];
    gameOverView.layer.zPosition = 1001;
    [gameOverView setImage:[UIImage imageNamed:@"dead"]];
    gameOverView.hidden = YES;
    [[self viewWithTag:10] addSubview:gameOverView];
    
    int width = 65, height = 80, lineWidth = 8, lineHeight = 40;
    int xPoint = bounds.size.width / 20, yPoint = 0;
    int xPointLines = bounds.size.width / 2 - lineWidth / 2;
    int cactusDistance = bounds.size.height/5;
    
    cactuses = [[NSMutableArray alloc] init];
    lines = [[NSMutableArray alloc] init];
    int numOfCactuses = 10;
    int numOfLines = 10;
    
    int bombWidth = 35, bombHeight = 45;
    int xBomb = bounds.size.width / 2 - bombWidth * 2, yBomb = 0;

    bomb = [[UIImageView alloc] initWithFrame:CGRectMake(xBomb, yBomb, bombWidth, bombHeight)];
    UIImage *image = [UIImage imageNamed:@"bomb"];
    [bomb setImage:image];
    [[self viewWithTag:10] addSubview:bomb];
    bomb.layer.zPosition = 997;
    
    bombCoordinates[0] = xBomb + bombWidth / 2;
    bombCoordinates[1] = yBomb + bombHeight / 2;
    
    int tankWidth = 30, tankHeight = 60;
    int xTank = bounds.size.width / 2 - tankWidth * 2;
    int yTank = bounds.size.height - tankHeight * 1.5;
    
    tank = [[UIImageView alloc] initWithFrame:CGRectMake(xTank, yTank, tankWidth, tankHeight)];
    UIImage *image2 = [UIImage imageNamed:@"tank"];
    [tank setImage:image2];
    [[self viewWithTag:10] addSubview:tank];
    tank.layer.zPosition = 998;
    
    tankCoordinates[0] = xTank + tankWidth / 2;
    tankCoordinates[1] = yTank + tankHeight / 2;
    
    for(int i = 0; i < numOfLines; i++)
    {
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(xPointLines, yPoint, lineWidth, lineHeight)];
        UIImage *image = [UIImage imageNamed:@"line"];
        [line setImage:image];
        
        [[self viewWithTag:10] addSubview:line];
        [lines addObject:line];
        
        lineCoordinates[0][i] = xPointLines + lineWidth / 2;
        lineCoordinates[1][i] = yPoint + lineHeight / 2;
        
        yPoint = yPoint + lineHeight * 2;
    }
    yPoint = 0;
    
    for(int i = 0; i < numOfCactuses; i++)
    {
        UIImageView *cactus = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        UIImage *image = [UIImage imageNamed:@"cactus"];
        [cactus setImage:image];
        
        [[self viewWithTag:10] addSubview:cactus];
        [cactuses addObject:cactus];
        
        coordinates[0][i] = xPoint + width / 2;
        coordinates[1][i] = yPoint + height / 2;
        
        yPoint = yPoint + cactusDistance;
    }
    
    xPoint = bounds.size.width - bounds.size.width/20 - width;
    yPoint = 0;
    
    for(int i = 0; i < numOfCactuses; i++)
    {
        UIImageView *cactus = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        UIImage *image = [UIImage imageNamed:@"cactus"];
        [cactus setImage:image];
        
        [[self viewWithTag:10] addSubview:cactus];
        [cactuses addObject:cactus];
        
        coordinates[0][numOfCactuses + i] = xPoint + width / 2;
        coordinates[1][numOfCactuses + i] = yPoint + height / 2;
        
        yPoint = yPoint + cactusDistance;
    }
}

- (void) arrange:(CADisplayLink *)sender
{
    CGRect bounds = [[self viewWithTag:10] bounds];
    int counter = 0, r;
    
    bombCoordinates[1] = bombCoordinates[1] + 9;
    [bomb setCenter:CGPointMake(bombCoordinates[0], bombCoordinates[1])];
    
    if (bombCoordinates[1] > bounds.size.height + 40)
    {
        score = score + 1;
        NSString *str = [NSString stringWithFormat:@"%i", score];
        NSString *newScore = [@"Score: " stringByAppendingString:str];
        [scoreLabel setText:newScore];
        
        r = startingPointRoad + arc4random_uniform(endingPointRoad - startingPointRoad);
        bombCoordinates[1] = -40;
        bombCoordinates[0] = r;
        [bomb setCenter:CGPointMake(bombCoordinates[0], bombCoordinates[1])];
    }
    
    for (UIImageView *cactus in cactuses)
    {
        coordinates[1][counter] = coordinates[1][counter] + 3;
        [cactus setCenter:CGPointMake(coordinates[0][counter], coordinates[1][counter])];
        
        if (coordinates[1][counter] > bounds.size.height + 40)
        {
            coordinates[1][counter] = -40;
            [cactus setCenter:CGPointMake(coordinates[0][counter], coordinates[1][counter])];
        }
        
        counter = counter + 1;
    }
    counter = 0;
    
    for (UIImageView *line in lines)
    {
        lineCoordinates[1][counter] = lineCoordinates[1][counter] + 3;
        [line setCenter:CGPointMake(lineCoordinates[0][counter], lineCoordinates[1][counter])];
        
        if (lineCoordinates[1][counter] > bounds.size.height + 40)
        {
            lineCoordinates[1][counter] = -40;
            [line setCenter:CGPointMake(lineCoordinates[0][counter], lineCoordinates[1][counter])];
        }
        
        counter = counter + 1;
    }
    
    if(firstTiltFlag && tilt == 0) {}
    else
    {
        firstTiltFlag = false;
        
        if(tilt > 0.9) tankCoordinates[0] = tankCoordinates[0] + 3;
        else if(tilt > 0.725 && tilt <= 0.9) tankCoordinates[0] = tankCoordinates[0] + 2;
        else if(tilt > 0.525 && tilt <= 0.725) tankCoordinates[0] = tankCoordinates[0] + 1;
        else if(tilt > 0.275 && tilt <= 0.475) tankCoordinates[0] = tankCoordinates[0] - 1;
        else if(tilt > 0.1 && tilt <= 0.275) tankCoordinates[0] = tankCoordinates[0] - 2;
        else if(tilt <= 0.1) tankCoordinates[0] = tankCoordinates[0] - 3;
    }
    
    [tank setCenter:CGPointMake(tankCoordinates[0], tankCoordinates[1])];
    
    if (tankCoordinates[0] < startingPointRoad && tankCoordinates[0] > 0) [self gameOver];
    else if (tankCoordinates[0] > endingPointRoad) [self gameOver];
    
    CGPoint bombCenter = [bomb center];
    CGRect tankFrame = [tank frame];
    
    if (CGRectContainsPoint(tankFrame, bombCenter)) [self gameOver];
    
    bulletCoordinates[1] = bulletCoordinates[1] - 30;
    [bullet setCenter:CGPointMake(bulletCoordinates[0], bulletCoordinates[1])];
    
    CGRect bombFrame = [bomb frame];
    CGPoint bulletCenter = [bullet center];
    
    if (CGRectContainsPoint(bombFrame, bulletCenter))
    {
        score = score + 10;
        NSString *str = [NSString stringWithFormat:@"%i", score];
        NSString *newScore = [@"Score: " stringByAppendingString:str];
        [scoreLabel setText:newScore];
        
        r = startingPointRoad + arc4random_uniform(endingPointRoad - startingPointRoad);
        bombCoordinates[1] = -40;
        bombCoordinates[0] = r;
        [bomb setCenter:CGPointMake(bombCoordinates[0], bombCoordinates[1])];
        
        [bullet removeFromSuperview];
        bullet = nil;
    }
}

- (void) gameOver
{
    score = 0;
    NSString *str = [NSString stringWithFormat:@"%i", score];
    NSString *newScore = [@"Score: " stringByAppendingString:str];
    [scoreLabel setText:newScore];
    
    tankCoordinates[0] = -50;
    [tank setCenter:CGPointMake(tankCoordinates[0], tankCoordinates[1])];
    
    gameOverView.hidden = NO;
    restartButton.hidden = NO;
}

-(void) restart:(UIButton *) sender
{
    int r = startingPointRoad + arc4random_uniform(endingPointRoad - startingPointRoad);
    tankCoordinates[0] = r;
    [tank setCenter:CGPointMake(tankCoordinates[0], tankCoordinates[1])];
    
    gameOverView.hidden = YES;
    restartButton.hidden = YES;
    tilt = 0.5;
}

- (void) fire
{
    CGPoint bulletCenter = [bullet center];
    
    if(bulletCenter.x == 0 || !CGRectContainsPoint(bounds, bulletCenter))
    {
        int bulletWidth = 8, bulletHeight = 25;
        int xBullet = tankCoordinates[0] - 5;
        int yBullet = tankCoordinates[1] - 50;
        bullet = [[UIImageView alloc] initWithFrame:CGRectMake(xBullet, yBullet, bulletWidth, bulletHeight)];
    
        UIImage *image = [UIImage imageNamed:@"bullet"];
        [bullet setImage:image];
        [[self viewWithTag:10] addSubview:bullet];
        bullet.layer.zPosition = 1000;
    
        bulletCoordinates[0] = xBullet + bulletWidth / 2;
        bulletCoordinates[1] = yBullet + bulletHeight / 2;
    }
}

@end
