//
//  HYBAnimationClock.m
//  HYBClockDemo
//
//  Created by huangyibiao on 16/3/15.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBAnimationClock.h"

#define kAngleToRadio(angle) ((angle) / 180.0 * M_PI)

@interface HYBAnimationClock ()

@property (nonatomic, strong) CALayer *hourLayer;
@property (nonatomic, strong) CALayer *minuteLayer;
@property (nonatomic, strong) CALayer *secondLayer;

@end

@implementation HYBAnimationClock

- (void)dealloc {
  NSLog(@"hybanimcation dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName {
  if (self = [super initWithFrame:frame]) {
    UIImage *image = [UIImage imageNamed:imageName];
    self.layer.contents = (__bridge id _Nullable)(image.CGImage);
    
    // hour layer set up
    self.hourLayer = [self layerWithBackgroundColor:[UIColor blackColor]
                                               size:CGSizeMake(3, self.frame.size.width / 2 - 40)];
    // 秒针与分针一样长
    self.minuteLayer = [self layerWithBackgroundColor:[UIColor blackColor]
                                                 size:CGSizeMake(3, self.frame.size.width / 2 - 20)];
    self.secondLayer = [self layerWithBackgroundColor:[UIColor redColor]
                                                 size:CGSizeMake(1, self.frame.size.width / 2 - 20)];
    self.secondLayer.cornerRadius = 0;
    [self updateUI];
  }
  
  return self;
}

- (void)addSecondAnimationWithAngle:(CGFloat)angle {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  animation.repeatCount = HUGE_VALF;
  animation.duration = 60;
  animation.removedOnCompletion = NO;
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  animation.fromValue = @(angle * M_PI / 180);
  animation.byValue = @(2 * M_PI);
  [self.secondLayer addAnimation:animation forKey:@"SecondAnimationKey"];
}

- (void)addMinuteAnimationWithWithAngle:(CGFloat)angle {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  animation.repeatCount = HUGE_VALF;
  animation.duration = 60 * 60;
  animation.removedOnCompletion = NO;
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  animation.fromValue = @(angle * M_PI / 180);
  animation.byValue = @(2 * M_PI);
  [self.minuteLayer addAnimation:animation forKey:@"MinuteAnimationKey"];
}

- (void)addHourAnimationWithAngle:(CGFloat)angle {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
  animation.repeatCount = HUGE_VALF;
  animation.duration = 60 * 60 * 60 * 12;
  animation.removedOnCompletion = NO;
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  animation.fromValue = @(angle * M_PI / 180);
  animation.byValue = @(2 * M_PI);
  [self.hourLayer addAnimation:animation forKey:@"HourAnimationKey"];
}

#pragma mark - Private
- (void)updateUI {
  NSCalendar *calender = [NSCalendar currentCalendar];
  
  NSDateComponents *date = [calender components:NSCalendarUnitSecond
                            | NSCalendarUnitMinute
                            | NSCalendarUnitHour
                                       fromDate:[NSDate date]];
  
  NSInteger second = date.second;
  NSInteger minute = date.minute;
  NSInteger hour = date.hour;
  
  CGFloat perHourMove = 1.0 / 12. * 360.0;
  CGFloat hourAngle = hour * perHourMove + minute * (1.0 / 60.0) * perHourMove;
  self.hourLayer.transform = CATransform3DMakeRotation(kAngleToRadio(hourAngle), 0, 0, 1);
  
  // 一分钟就是一圈，也就是每秒走度
  CGFloat minuteAngle = minute * 360.0 / 60.0;
  self.minuteLayer.transform = CATransform3DMakeRotation(kAngleToRadio(minuteAngle), 0, 0, 1);
  
  CGFloat secondAngle = second * 360.0 / 60.0;
  self.secondLayer.transform = CATransform3DMakeRotation(kAngleToRadio(secondAngle), 0, 0, 1);
  
  [self addSecondAnimationWithAngle:secondAngle];
  [self addMinuteAnimationWithWithAngle:minuteAngle];
  [self addHourAnimationWithAngle:hourAngle];
}

- (CALayer *)layerWithBackgroundColor:(UIColor *)color size:(CGSize)size {
  CALayer *layer = [CALayer layer];
  
  layer.backgroundColor = color.CGColor;
  layer.anchorPoint = CGPointMake(0.5, 1);
  // 设置为中心
  layer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
  // 时针、分针、秒针长度是不一样的
  layer.bounds = CGRectMake(0, 0, size.width, size.height);
  // 加个小圆角
  layer.cornerRadius = 4;
  
  [self.layer addSublayer:layer];
  
  return layer;
}

@end
