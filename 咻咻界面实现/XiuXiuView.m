//
//  XiuXiuView.m
//  咻咻界面实现
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 范文哲. All rights reserved.
//

#import "XiuXiuView.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation XiuXiuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype) initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
//# 创建手势  并添加到 View 上
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [self addGestureRecognizer:tap];
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.backgroundColor = [UIColor clearColor];
        [self.textLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.textLabel];
        self.backgroundColor = [UIColor cyanColor];
//# 给一个默认的风格  不设置就是代表 动画在里面
        self.buttonType = DDFlashButtonInner;
    }
    return self;
}
- (void)setText:(NSString *)text withTextColor:(UIColor *)textColor
{//# 就是给 Label 赋外界传来的值  若有其他的控件可以改一些参数用此方法
    if (text){
        [self.textLabel setText:text];
    }
    if (textColor){
        [self.textLabel setTextColor:textColor];
    }
}
//这里就是重写了ButtonType setter方法,同时判断一下风格根据风格选择是否把超过视图 View 的部分裁剪掉
- (void)setButtonType:(FlashButtonType)buttonType
{
    _buttonType = buttonType;
    if (buttonType == DDFlashButtonInner){
        // 内容和子视图是夹在视图的边界内 ( 只允许 view范围内有子视图和类容可以显示 )
        self.clipsToBounds = 1;
    }else{// 外面可以显示
        self.clipsToBounds = 0;
    }
}
- (CAAnimationGroup *)createFlashAnimationWisthScale:(CGFloat)scale
                                            duration:(CGFloat)duratiton{
//# 创建按比例收缩变大的动画
    // 指定要在渲染动画性能时的关键路径 也就是图形转换的方式 这里是按收缩比例  这里也可以不用.scale 因为我们初始值设置是根据CATransform3D
    CABasicAnimation  *scaleAnnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画开始点
    // 这个动画效果初值  就是本身的原始的位置
    scaleAnnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    // 等价 scaleAnnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    // 动画结束点
    //  在 x 轴和 y 轴的变化比例
    scaleAnnimation.toValue = [NSValue valueWithCATransform3D:(CATransform3DMakeScale(scale, scale, 1))];
    
//# 创建透明度变换的动画
    CABasicAnimation *alphaAnimation = [CABasicAnimation  animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
//#  创建动画组把上面两个动画加进去
    CAAnimationGroup *animation = [CAAnimationGroup new];
    animation.animations = @[scaleAnnimation,alphaAnimation];
    // 动画效果 (节奏, Timing Function的会被用于变化起点和终点之间的插值计算.形象点说是Timing Function决定了动画运行的节奏(Pacing),比如是均匀变化(相同时间变化量相同),先快后慢,先慢后快还是先慢再快再慢.)
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
//# 返回我们想要的动画效果组
    return animation;
}
- (CAShapeLayer *)creatCircleShapWithPostion:(CGPoint)position
                                    pathRect:(CGRect)rect
                                      radius:(CGFloat)radius
{
    CAShapeLayer *circleShap = [CAShapeLayer layer];
    
    // 从贝塞尔曲线取到形状
//    circleShap.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
    circleShap.path = [UIBezierPath bezierPathWithOvalInRect:rect].CGPath;
    
    // 虽然得到了形状, 但是并没有得到具体的 frame(bounds) 也就是实际上并没有范围  只是可以展现动画的效果  那么锚点其实就是设置的位置点
    circleShap.position = position;
    if (self.buttonType == DDFlashButtonInner)
    {
//# 在这里设置 frame 就是为了满足我们想要的锚点位置让动画效果动起来, 下面也一样, 可以不设置试试效果就明白了!
        // circleShap.bounds = CGRectMake(0, 0, radius *2, radius *2);
        circleShap.frame = CGRectMake(position.x-radius, position.y-radius, radius*2, radius*2);
        // 线宽
        circleShap.lineWidth = 1;
        // 填充的颜色  不设置默认就给黄色
        circleShap.fillColor = self.flashColor ? self.flashColor.CGColor:[UIColor yellowColor].CGColor;
        
    }else
    {
        circleShap.frame = self.bounds;
        // 线宽
        circleShap.lineWidth = 5;
        circleShap.fillColor = [UIColor clearColor].CGColor;
        // 边缘线的颜色  不设置就默认给个紫色
        circleShap.strokeColor = self.flashColor ? self.flashColor.CGColor:[UIColor cyanColor].CGColor;
        
    }
    
    // 不透明度  要设置成透明的  不然内部风格的时候会画出来图案点点
    circleShap.opacity = 0;
    return circleShap;
}
//必须得是自定义的声音，经过测试系统的声音好像都带振动
- (void)playNotifySound {
    //获取路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"candoNotifySound" ofType:@"mp3"];
    //定义一个带振动的SystemSoundID
    SystemSoundID soundID = 1000;
    //判断路径是否存在
    if (path) {
        //创建一个音频文件的播放系统声音服务器
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:path]), &soundID);
        //判断是否有错误
        if (error != kAudioServicesNoError) {
            NSLog(@"%d",(int)error);
        }
    }
    //只播放声音，没振动
    AudioServicesPlaySystemSound(soundID);
}
- (void)didTap:(UITapGestureRecognizer *)tapGesture
{
    
    [self playNotifySound];
    SystemSoundID soundID = 1300;//具体参数详情下面贴出来
    //1300 微信 通知
    //1321 魔鬼音
    //1330 长号
    // 1335  欢乐
    //1336
    //1337
    //播放声音
    AudioServicesPlaySystemSound(soundID);
    
    
    // 获取点击点的位置
    CGPoint tapLocation = [tapGesture locationInView:self];
    // 定义一个图层  下面分情况去给予不同形状
    CAShapeLayer *circleShape = nil;
    // 默认一个变化比例 1 倍
    CGFloat scale = 1.0f;
    // 获取 View 的宽和高
    CGFloat width = self.bounds.size.width, height = self.bounds.size.height;
    if (self.buttonType == DDFlashButtonInner)
    {
//# 这里就是在视图内部效果, 就是以点击的点为圆心 画一个小圆(这里是半径为1) 然后让它动画起来 (不断的变大并变透明) 所以放大倍数只要能到最大的变就行了 不一定非要这样写, 你开心就好!
        CGFloat biggerEdge = width > height ? width :height;
        CGFloat radius = 1;
        scale = biggerEdge / radius + 0.5;
//# 调用方法获得图层 锚点位置就是点击的位置
        circleShape = [self creatCircleShapWithPostion:CGPointMake(tapLocation.x , tapLocation.y ) pathRect:CGRectMake(0, 0, radius * 2, radius * 2) radius:radius];
    }else
    {
//# 这个是外部动画效果  设置能放大5.5倍
        scale = 5.5f;
//# 锚点位置在 View 的中心  这个图层和 View 是一样的形状范围
        circleShape = [self creatCircleShapWithPostion:CGPointMake(width /2 , height / 2) pathRect:self.bounds radius:self.layer.cornerRadius];
    }
    // view图层 上添加 有形状的自定义图层
    [self.layer addSublayer:circleShape];
    
//# 给自定义图层添加动画
    [circleShape addAnimation:[self createFlashAnimationWisthScale:scale duration:1.0f] forKey:nil];
}




@end
