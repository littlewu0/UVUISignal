//
//  TestSignalView.m
//  UVUISignal
//
//  Created by 伍学俊 on 2017/4/9.
//  Copyright © 2017年 伍学俊. All rights reserved.
//

#import "TestSignalView.h"
#import "UVUISignal.h"

@implementation TestSignalView

- (void)onTap:(UITapGestureRecognizer *)tap
{
//    UVUISignal *signal = [[UVUISignal alloc] initWithResponder:self signalName:@"TestSignal"];
//    [signal sendWithParameters:@{@"a" : @"b"} data:@"abc"];
//    [signal sendWithParameters:nil data:@"abc"];
    UVResponderSendSignalAndData(self, @"TestSignal", @{@"a" : @"b"} , @"abc");
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

@end
