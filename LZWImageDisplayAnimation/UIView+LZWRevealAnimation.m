//
//  UIView+LZWRevealAnimation.m
//  LZWImageDisplayAnimation
//
//  Created by liuziwen on 16/6/28.
//  Copyright © 2016年 liuziwen. All rights reserved.
//

#import "UIView+LZWRevealAnimation.h"



static CAShapeLayer *circleLayer;
static BOOL isChanged = YES;

@implementation UIView (LZWRevealAnimation)


#pragma mark -- 旋转动画
- (void)LZW_rotatingAnimationWithImageName:(imageNameBlock)block
{
    // 标记翻转状态
    isChanged = !isChanged;
    
    // 动画配置
    NSTimeInterval duration = 0.5;
    UIViewAnimationTransition transition = isChanged ?UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft;
    
    // 提交动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationTransition:transition forView:self cache:NO];
    [UIView commitAnimations];
    
    // 动画进行到一半，设置图片
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration/2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        block(isChanged);
    });
}


#pragma mark --- 外圈旋转
- (void)LZW_outLineAnimation
{
    [self startoutLineAnimation];
   
}
- (void)LZW_revealAnimation
{
     [self startRevealAnimation];
}

- (void)startoutLineAnimation
{
    [circleLayer removeFromSuperlayer];
    //创建外圆的layer
    circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = 3.0f;
    circleLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.path = [self drawOutLine].CGPath;
    [self.layer addSublayer:circleLayer];
    
    //执行外圆layer的动画
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.duration = 2;
    circleAnimation.fromValue = @(0.0f);
    circleAnimation.toValue = @(1.0f);
    circleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleLayer addAnimation:circleAnimation forKey:@"outlineAnimation"];

}

- (void)startRevealAnimation {
    
    self.hidden = YES;
    CAShapeLayer *revealLayer = [CAShapeLayer layer];
    revealLayer.bounds = self.bounds;
    revealLayer.fillColor = [UIColor blackColor].CGColor;
    
    //开始的路径
    CGFloat fromRadius = 1.0f;
    CGFloat fromRectWidth = fromRadius * 2;
    CGFloat fromRectHeight = fromRadius * 2;
    CGRect fromRect = CGRectMake(CGRectGetMidX(self.bounds) - fromRadius,
                                 CGRectGetMidY(self.bounds) - fromRadius,
                                 fromRectWidth,
                                 fromRectHeight);
    
    UIBezierPath *fromPath = [self drawRevealPath:fromRect cornerRadius:fromRadius];
    
    //结束的路径
    CGFloat endRadius = self.bounds.size.width / 2;
    UIBezierPath *endPath = [self drawRevealPath:self.bounds cornerRadius:endRadius];
    
    
    revealLayer.path = endPath.CGPath;
    revealLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.layer.mask = revealLayer;
    
    //    开始动画
    CABasicAnimation *revealAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    revealAnimation.fromValue = (__bridge id)(fromPath.CGPath);
    revealAnimation.toValue = (__bridge id)(endPath.CGPath);
    revealAnimation.duration = 1;
    revealAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    revealAnimation.beginTime = CACurrentMediaTime() + 1;
    revealAnimation.repeatCount = 1.0f;
    revealAnimation.fillMode = kCAFillModeForwards;
    
    dispatch_time_t timeToShow = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(timeToShow, dispatch_get_main_queue(), ^{
        
        self.hidden = NO;
    });
    [revealLayer addAnimation:revealAnimation forKey:@"revealAnimation"];
    
}


- (void)LZW_slowRevealAnimationWithRadius:(CGFloat)radius
{
    circleLayer = [CAShapeLayer layer];
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = [UIColor redColor].CGColor;
    circleLayer.path = [self pathWithRadius:radius].CGPath;
    self.layer.mask = circleLayer;
    
    CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnimation.toValue = @(radius);
    lineWidthAnimation.duration = 2.0;
    lineWidthAnimation.delegate = self;
    lineWidthAnimation.removedOnCompletion = NO;
    lineWidthAnimation.fillMode = kCAFillModeForwards;
    [circleLayer addAnimation:lineWidthAnimation forKey:@"slowRevealAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
        self.layer.mask = nil;
}


- (UIBezierPath *)pathWithRadius:(CGFloat)radius
{
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake((CGRectGetWidth(self.bounds) - radius)/2, (CGRectGetWidth(self.bounds) - radius)/2, radius, radius)];
}

- (UIBezierPath *)drawOutLine {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width / 2];
    return path;
}

- (UIBezierPath *)drawRevealPath:(CGRect)roundRect cornerRadius:(CGFloat)radius{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:roundRect cornerRadius:radius];
    return path;
}



@end
