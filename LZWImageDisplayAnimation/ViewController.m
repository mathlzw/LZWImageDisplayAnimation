//
//  ViewController.m
//  LZWImageDisplayAnimation
//
//  Created by liuziwen on 16/6/28.
//  Copyright © 2016年 liuziwen. All rights reserved.
//

#import "ViewController.h"
#import "UIView+LZWRevealAnimation.h"
#import "LZWHeartFlyView/LZWHeartFlyAnimation.h"

@interface ViewController ()
{
    CGFloat _heartSize;
    NSTimer *_burstTimer;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *fillView;

@property (strong, nonatomic) IBOutlet UILabel *flyAnimationLab;


- (IBAction)animation1:(UIButton *)sender;

- (IBAction)animation2:(UIButton *)sender;

- (IBAction)animation3:(UIButton *)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _heartSize = 36;
    self.view.backgroundColor = [UIColor lightGrayColor];

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTheLove)];
    [self.view addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    longPressGesture.minimumPressDuration = 0.2;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:longPressGesture];
    

}


-(void)showTheLove{
    LZWHeartFlyAnimation* heart = [[LZWHeartFlyAnimation alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(100 + _heartSize/2.0, self.view.bounds.size.height - _heartSize/2.0 - 10);
    heart.center = fountainSource;
    [heart animationInView:self.view];
}

-(void)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture{
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            _burstTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(showTheLove) userInfo:nil repeats:YES];
            break;
        case UIGestureRecognizerStateEnded:
            [_burstTimer invalidate];
            _burstTimer = nil;
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)animation1:(UIButton *)sender {
    _imageView.image = [UIImage imageNamed:@"tupian1.jpg"];
    
    [_imageView LZW_slowRevealAnimationWithRadius:200];
}

- (IBAction)animation2:(UIButton *)sender {
     [_fillView LZW_outLineAnimation];
     [_imageView LZW_revealAnimation];
    _imageView.image = [UIImage imageNamed:@"tupian1.jpg"];

}

- (IBAction)animation3:(UIButton *)sender {
    
    __weak typeof(self) temp = self;
    [_imageView LZW_rotatingAnimationWithImageName:^(BOOL isChanged) {
        temp.imageView.image = [UIImage imageNamed:isChanged ?@"tupian1.jpg":@"tupian2.jpg" ];
    }];
    
}
@end
