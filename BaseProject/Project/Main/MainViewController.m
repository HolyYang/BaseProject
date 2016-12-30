//
//  MainViewController.m
//  BaseProject
//
//  Created by YangY on 2016/12/30.
//  Copyright © 2016年 羊羊. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [[ApiHelper shareInstance] requestGetWithApi:@"http://apicloud.mob.com/v1/weather/type?key=15dde598bd9d1" andParams:nil andCallback:^(NSURLSessionDataTask *operation, id requestObj, NSError *error) {

    }];
//    [[ApiHelper shareInstance] downloadWithUrl:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4" andProgress:^(NSProgress *progress) {
//        NSLog(@"页面的下载值%.2f",progress.fractionCompleted);
//    } andFinish:^(NSString *str) {
//        NSLog(@"%@",str);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
