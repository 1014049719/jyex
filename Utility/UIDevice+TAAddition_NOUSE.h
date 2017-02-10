//
//  UIDevice+TAAddition.h
//  TQAP_Common_Basic
//
//  Created by chenyan on 12-3-15.
//  Copyright (c) 2012年 TQND. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice(TAAddition)

/*
 获取设备的经过BASE64编码的全球唯一ID（算法来自博远无线, 兼容iOS4-iOS5, iPhone3,3GS,4,4S）
 (每次调用都重新计算)
 */
+ (NSString*) uniqueDeviceIdWithBase64Encode;

/*
 获取网卡地址
 */
+ (NSString *) macAddress;

/*
 获取wifi地址（其实就是网卡地址）
 */
+ (NSString *) getWifiAddr;

/*
 获取机器的类型
 */
+ (NSString *) getMachineType;

@end
