//
//  XiuXiuView.h
//  咻咻界面实现
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 范文哲. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, FlashButtonType){
// 风格定义一个枚举类型的去表示 分别是代表动画在里面和外面 (便于理解)
    DDFlashButtonInner = 0,
    DDFlashButtonOuter = 1
    
};

@interface XiuXiuView : UIView
@property (strong, nonatomic) UIColor *flashColor;
@property (assign, nonatomic) FlashButtonType buttonType;
@property UILabel *textLabel;
 -(void)setText:(NSString *)text withTextColor:(UIColor *)textColor;
@end
