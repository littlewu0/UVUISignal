//
//  UVUISignal.m
//  UVUISignal
//
//  Created by 伍学俊 on 2017/4/8.
//  Copyright © 2017年 伍学俊. All rights reserved.
//

#import "UVUISignal.h"

@interface UVUISignal ()

@property (nonatomic, weak) UIResponder *responder;
@property (nonatomic, copy) NSString *signalName;
@property (nonatomic, copy) NSDictionary *parameters;
@property (nonatomic, strong) id data;
// 上级responder可响应方法列表
@property (nonatomic, copy) NSArray<NSString *> *callSelectorNames;
@property (nonatomic, assign) BOOL isInterruptted;

@end

@implementation UVUISignal

#pragma mark -

- (id)initWithResponder:(UIResponder *)responder signalName:(NSString *)signalName
{
    if (self = [super init]) {
        self.responder = responder;
        self.signalName = signalName;
        NSStringFromClass(responder.class);
        // 用于响应特定的源responder发出的特定信号
        NSString *firstSelector = [NSString stringWithFormat:@"uv_%@_%@_signal:callFrom:signalName:parameters:data:", NSStringFromClass(responder.class), signalName];
        // 用于响应特定的源responder发出的任意信号
        NSString *secondSelector = [NSString stringWithFormat:@"uv_%@_signal:callFrom:signalName:parameters:data:", NSStringFromClass(responder.class)];
        // 用于响应任意的源responder发出的任意信号
        NSString *thirdSelector = @"uv_signal:callFrom:signalName:parameters:data:";
        self.callSelectorNames = @[firstSelector, secondSelector, thirdSelector];
    }
    return self;
}

#ifdef DEBUG
- (void)dealloc
{
    NSLog(@"uisignal dealloc");
}
#endif

#pragma mark public api

/**
 * 发送信号
 */
- (void)send
{
    [self sendWithParameters:nil data:nil];
}

- (void)sendWithParameters:(NSDictionary *)parameters data:(id)data
{
    self.parameters = parameters;
    self.data = data;
    UIResponder *nextResponder = [self.responder nextResponder];
    while (nextResponder && !self.isInterruptted) {
        [self.callSelectorNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SEL selector = NSSelectorFromString(obj);
            if ([nextResponder respondsToSelector:selector]) {
                NSMethodSignature *signature = [nextResponder methodSignatureForSelector:selector];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                invocation.selector = selector;
                invocation.target = nextResponder;
                [invocation setArgument:&(self) atIndex:2];
                [invocation setArgument:&(_responder) atIndex:3];
                [invocation setArgument:&(_signalName) atIndex:4];
                if (parameters) [invocation setArgument:&(_parameters) atIndex:5];
                if (data) [invocation setArgument:&(_data) atIndex:6];
                [invocation retainArguments];
                [invocation invoke];
            }
        }];
        nextResponder = [nextResponder nextResponder];
    }
}

/**
 * 中断信号的继续发送
 */
- (void)interrupt
{
    self.isInterruptted = YES;
}

@end

@implementation UIResponder (UVUISignal)

- (void)uv_sendSignal:(NSString *)singalName
{
    [self uv_sendSignal:singalName parameters:nil data:nil];
}

- (void)uv_sendSignal:(NSString *)singalName parameters:(NSDictionary *)parameters data:(id)data
{
    UVUISignal *signal = [[UVUISignal alloc] initWithResponder:self signalName:singalName];
    [signal sendWithParameters:parameters data:data];
}

@end
