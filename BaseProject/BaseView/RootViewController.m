//
//  RootViewController.m
//  BaseProject
//
//  Created by YangY on 2016/12/30.
//  Copyright © 2016年 羊羊. All rights reserved.
//

#import "RootViewController.h"
#import "MainViewController.h"
#import "MeViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadController
{
    MainViewController *main = [[MainViewController alloc] init];
    UINavigationController *na1 = [[UINavigationController alloc] initWithRootViewController:main];
    //返回键只保留返回箭头
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    na1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"home_01.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"home_02.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //设置顶部栏阴影颜色
//    [na1.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    //设置所有页面title文本样式
    [na1.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:16],
       NSForegroundColorAttributeName:[UIColor blueColor]}];

    
    MeViewController *me = [[MeViewController alloc] init];
    UINavigationController *na2 = [[UINavigationController alloc] initWithRootViewController:me];
    //返回键只保留返回箭头
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    na2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[[UIImage imageNamed:@"me_01.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"me_02.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //设置顶部栏阴影颜色
    //    [na1.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    //设置所有页面title文本样式
    [na2.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:16],
       NSForegroundColorAttributeName:[UIColor blueColor]}];
    
    self.viewControllers = @[na1,na2];
    //默认选中的tabBar
    [self setSelectedIndex:0];
    
}

@end
