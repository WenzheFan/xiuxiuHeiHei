//
//  ViewController.m
//  咻咻界面实现
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 范文哲. All rights reserved.
//

#import "ViewController.h"
#import "XiuXiuView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    XiuXiuView *xiuxiu = [[XiuXiuView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    
    [self.view addSubview:xiuxiu];
    
    [xiuxiu setText:@"嘿嘿" withTextColor:[UIColor redColor]];
    
    
     XiuXiuView *xiuxiu2 = [[XiuXiuView alloc]initWithFrame:CGRectMake(100, 400, 200, 200)];
    
    [self.view addSubview:xiuxiu2];
    
    xiuxiu2.buttonType = DDFlashButtonOuter;
    
    [xiuxiu2 setText:@"呵呵" withTextColor: [UIColor yellowColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
