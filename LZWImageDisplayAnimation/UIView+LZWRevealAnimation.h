//
//  UIView+LZWRevealAnimation.h
//  LZWImageDisplayAnimation
//
//  Created by liuziwen on 16/6/28.
//  Copyright © 2016年 liuziwen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^imageNameBlock)(BOOL isChanged);

@interface UIView (LZWRevealAnimation)

- (void)LZW_slowRevealAnimationWithRadius:(CGFloat)radius;

- (void)LZW_outLineAnimation;
- (void)LZW_revealAnimation;

/**
 *  旋转动画
 *
 *  @param block 切换图片
 */
- (void)LZW_rotatingAnimationWithImageName:(imageNameBlock)block;

@end
