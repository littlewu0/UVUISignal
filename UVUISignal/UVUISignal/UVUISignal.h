//
//  UVUISignal.h
//  UVUISignal
//
//  Created by 伍学俊 on 2017/4/8.
//  Copyright © 2017年 伍学俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * 用于定义接受信号的协议方法
 */
/**
 * 定义用于接受任意源发出的任意信号的方法
 */
#define UVDefaultSignalCallMethodDefine - (void)uv_signal:(UVUISignal *)signal \
    callFrom:(UIResponder *)responder \
    signalName:(NSString *)signalName \
    parameters:(NSDictionary *)parameters \
    data:(id)data

/**
 * 定义用于接受特定源发出的任意信号的方法
 */
#define UVSpecialClassSignalCallMethodDefine(ClassName) - (void)uv_##ClassName##_signal:(UVUISignal *)signal \
    callFrom:(UIResponder *)responder \
    signalName:(NSString *)signalName \
    parameters:(NSDictionary *)parameters \
    data:(id)data

/**
 * 定义用于接受特定源发出的特定信号的方法
 */
#define UVSpecialClassAndSignalCallMethodDefine(ClassName, SignalName) - (void)uv_##ClassName##_##SignalName##_signal:(UVUISignal *)signal \
    callFrom:(UIResponder *)responder \
    signalName:(NSString *)signalName \
    parameters:(NSDictionary *)parameters \
    data:(id)data

/**
 * 基于UIResponse响应链传递信号和数据
 */
@interface UVUISignal : NSObject

#pragma mark -

/**
 * @Param responder : 信号发送者
 * @Param signalName : 信号名称
 */
- (id)initWithResponder:(UIResponder *)responder signalName:(NSString *)signalName;

#pragma mark -

/**
 * 发送信号
 */
- (void)send;
- (void)sendWithParameters:(NSDictionary *)parameters data:(id)data ;

/**
 * 中断信号的传递过程
 */
- (void)interrupt;

@end

#define UVResponderSendSignal(responder, signalName) [responder uv_sendSignal:signalName]
#define UVResponderSendSignalAndData(responder, _signalName, _parameters, _data) [responder uv_sendSignal:(_signalName) parameters:(_parameters) data:(_data)]

@interface UIResponder (UVUISignal)

- (void)uv_sendSignal:(NSString *)singalName;
- (void)uv_sendSignal:(NSString *)singalName parameters:(NSDictionary *)parameters data:(id)data;

@end
