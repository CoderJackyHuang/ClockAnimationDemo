//
//  ViewController.m
//  HYBClockDemo
//
//  Created by huangyibiao on 16/3/15.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "ViewController.h"
#import "HYBClockView.h"
#import "HYBAnimationClock.h"

@interface ViewController ()

@property (nonatomic, strong) HYBClockView *clockView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  CGFloat x = ([UIScreen mainScreen].bounds.size.width - 200) / 2;
  self.clockView = [[HYBClockView alloc] initWithFrame:CGRectMake(x, 40, 200, 200)
                                             imageName:@"clock"];
//  [self.view addSubview:self.clockView];
  
  HYBAnimationClock *aniClockView = [[HYBAnimationClock alloc] initWithFrame:CGRectMake(x, 250, 200, 200)
imageName:@"clock"];

  [self.view addSubview:aniClockView];
  
  [self.clockView releaseTimer];
//  [self.clockView removeFromSuperview];
  self.clockView = nil;
}

@end
