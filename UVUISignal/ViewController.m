//
//  ViewController.m
//  UVUISignal
//
//  Created by 伍学俊 on 2017/4/8.
//  Copyright © 2017年 伍学俊. All rights reserved.
//

#import "ViewController.h"
#import "UVUISignal.h"
#import "TestSignalView.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark -

UVSpecialClassAndSignalCallMethodDefine(TestSignalView, TestSignal)
{
    NSLog(@"source responder:%@ receive signal:%@ parameters:%@ data:%@", responder, signalName, parameters, data);
    NSLog(@"UVSpecialClassAndSignalCallMethodDefine");
}

UVDefaultSignalCallMethodDefine
{
    NSLog(@"UVDefaultSignalCallMethodDefine");
}

UVSpecialClassSignalCallMethodDefine(TestSignalView)
{
    NSLog(@"UVSpecialClassSignalCallMethodDefine");
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TestSignalView *signalView = [[TestSignalView alloc] initWithFrame:CGRectMake(0, 20, 100, 40)];
    [self.view addSubview:signalView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
