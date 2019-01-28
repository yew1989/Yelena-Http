//
//  YLViewController.m
//  YLHttp
//
//  Created by LinWei on 01/28/2019.
//  Copyright (c) 2019 LinWei. All rights reserved.
//

#import "YLViewController.h"
#import <YLHttp/YLHttpTool.h>
#import <YLCore/YLMacro.h>

@interface YLViewController ()

@end

@implementation YLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置鉴权字段
    [YLHttpTool setupAuthorization:@"Basic c3Vubnk6c3Vubnk="];
    
    // 发起请求
    WEAK(self)
    [YLHttpTool POST:@"http://223.71.180.203:8081/authentication/form" params:@{@"password":@"sunny",@"username":@"user"}
    success:^(NSDictionary *JSON) {
        STRONG(self)
        NSLog(@"%@",JSON);
        
    } failure:^(NSError *error) {
          NSLog(@"%@",error.localizedDescription);
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
