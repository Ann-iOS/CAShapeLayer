//
//  ViewController.m
//  CAShapeLayer_Demo
//
//  Created by 永昌达集团 on 2018/7/17.
//  Copyright © 2018年 永昌达集团. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)CAShapeLayer *layer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    // 填充颜色
    layer.fillColor = [UIColor yellowColor].CGColor;
    //
    layer.strokeColor = [UIColor redColor].CGColor;
    // 线两头样式   方形/圆形/
    layer.lineCap = kCALineCapRound;
    //  斜切角/ 圆角/ 斜角  默认为 切角
    layer.lineJoin = kCALineJoinRound;
    layer.lineWidth = 5;
    layer.frame = self.view.bounds;
    
    layer.path = [self arcPath].CGPath;
    self.layer = layer;
    [self.view.layer addSublayer:layer];
    
//   Slider
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height - 150, self.view.bounds.size.width - 100, 100)];
    slider.tintColor = [UIColor redColor];
    slider.minimumValue = layer.strokeStart;
    slider.maximumValue = layer.strokeEnd;
    slider.value = 0;
    slider.continuous = YES;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
//    动画按钮
    UIButton *startAnimation = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 100, self.view.bounds.size.height - 150, 100, 100)];
    [startAnimation addTarget:self action:@selector(startAnimationEvent) forControlEvents:UIControlEventTouchUpInside];
    [startAnimation setTitle:@"开始动画" forState:UIControlStateNormal];
    [startAnimation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    startAnimation.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:startAnimation];
}

#pragma mark-  开始动画事件
-(void)startAnimationEvent{
    [self.layer addAnimation:[self animationGroup] forKey:@"animate"];
}

-(void)sliderValueChanged:(UISlider *)sender {
    self.layer.strokeStart = sender.value;
    NSLog(@" %0.2f  ",sender.value);
}


#pragma mark - CAAnimationGroup

- (CAAnimationGroup *)animationGroup
{
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"position"];
    animate.removedOnCompletion = NO;
    animate.fillMode = kCAFillModeForwards;
    animate.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width / 2 + 200, self.view.frame.size.height/2)];
    
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    keyframeAnimation.values = @[(__bridge id)[self classOneBezierPath].CGPath,
                                 (__bridge id)[self classTwoBezierPath].CGPath,
                                 (__bridge id)[self arcPath].CGPath,
                                 (__bridge id)[self DIYPath].CGPath];
    // 从0-1变化的时间
    keyframeAnimation.keyTimes = @[@(0.25),@(0.5),@(0.75),@(1)];
    keyframeAnimation.fillMode = kCAFillModeForwards;
    keyframeAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animate,keyframeAnimation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.duration = 5;
    return group;
}


#pragma mark - CAKeyframeAnimation  多动画

- (CAKeyframeAnimation *)keyframeAnimation
{
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    keyframeAnimation.duration = 3;
    // 动画的 形态集合
    keyframeAnimation.values = @[(__bridge id)[self classOneBezierPath].CGPath,
                                 (__bridge id)[self classTwoBezierPath].CGPath,
                                 (__bridge id)[self arcPath].CGPath,
                                 (__bridge id)[self DIYPath].CGPath];
    // 从0-1变化的时间
    keyframeAnimation.keyTimes = @[@(0.25),@(0.5),@(0.75),@(1)];
    keyframeAnimation.fillMode = kCAFillModeForwards;
    keyframeAnimation.removedOnCompletion = NO;
    return keyframeAnimation;
}


#pragma mark - CABaseAnimation  --- 单一动画

- (CABasicAnimation *)pathBasicAnimation {
    
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"path"];
    animate.removedOnCompletion = NO;  //设置为NO时. fillMode 才会起作用.
    animate.duration = 2;
    //  kCAFillModeRemoved  动画结束后,layer会恢复到之前的状态
    //  kCAFillModeBackwards 和kCAFillModeForwards是相对的 , 只要动画被加入了layer,layer便处于动画初始状态
    //  kCAFillModeForwards   当动画结束后,layer会一直保持着动画最后的状态
    //  kCAFillModeBoth   动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.  是上面两个的集合
    animate.fillMode = kCAFillModeBoth;
    animate.toValue = (__bridge id _Nullable)([self DIYPath].CGPath);   // 最终的形态
    return animate;
}


/**
 平移
 */
- (CABasicAnimation *)positionBasicAnimate {
    
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"position"];
    animate.removedOnCompletion = NO;
    animate.fillMode = kCAFillModeForwards;
    animate.duration = 1;
    animate.toValue = [NSValue valueWithCGPoint:CGPointMake(300, 500)];
    return animate;
}


/**
 旋转
 */
- (CABasicAnimation *)rotationBasicAnimate {
    
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animate.removedOnCompletion = NO;
    animate.fillMode = kCAFillModeForwards;
    animate.duration = 1;
    animate.toValue = @(M_PI * 2);
    return animate;
}


#pragma mark - 贝塞尔曲线  UIBezierPath
/**
 自定义path
 */
- (UIBezierPath *)DIYPath {
    
    UIBezierPath *diyPath = [UIBezierPath bezierPath];
    [diyPath moveToPoint:CGPointMake(100, 60)];  // 中间直线 终点 位置.
    [diyPath addLineToPoint:CGPointMake(100, 200)];  //中间直线 起点位置点
    [diyPath addLineToPoint:CGPointMake(80, 170)];  // 左边线的起始点
    [diyPath moveToPoint:CGPointMake(100, 200)];      // 右边线的终点位置.
    [diyPath addLineToPoint:CGPointMake(120, 170)];   // 右边线的 起点 位置.,
    return diyPath;
}


/**
 二级贝塞尔
 */
- (UIBezierPath *)classTwoBezierPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(20, 100)];     // 起点 位置
    
    // 第一个 point  结束点位置..
    // 第二个point   第一个弧形的位置,
    // 第三个point  第二个弧形的 位置
    
    [path addCurveToPoint:CGPointMake(200, 100) controlPoint1:CGPointMake(120, 40) controlPoint2:CGPointMake(120, 180)];
    return path;
}


/**
 一级贝塞尔
 */
- (UIBezierPath *)classOneBezierPath{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(100, 50)];  // 起点位置.
//    终点和 两个控制点绘制贝塞尔曲线
    // 第一个 point. 为划线的 结束点的位置.
    // 第二个 point. 为弧线的最低点位置.
    [path addQuadCurveToPoint:CGPointMake(300, 100) controlPoint:CGPointMake(200, 200)];
    return path;
}

/**
 圆弧
 */
- (UIBezierPath *)arcPath{
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:50 startAngle:M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
}

/**
 圆角矩形

 */
-(UIBezierPath *)roundedPath{
    return [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100, 100, 100, 100) cornerRadius:5];
}


/**
直角 矩形
 */
-(UIBezierPath *)rectanglePath{
    return [UIBezierPath bezierPathWithRect:CGRectMake(0, 200, 100, 100)];
}

/**
 画圆
 */
- (UIBezierPath *)circlePath
{
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
}




@end
