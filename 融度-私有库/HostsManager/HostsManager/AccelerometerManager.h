//
//  AccelerometerManager.h
//  HostsManager
//
//  Created by Mr_zhaohy on 2017/11/21.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CMMotionManager.h>

@interface AccelerometerManager : NSObject

/**
 初始化

 @return AccelerometerManager实例
 */
+(instancetype)sharedManager;
/**
 激活速度传感器
 
 @param accelerameter 触发阈值
 @param callBack 回调
 */
-(void)startAccelerometer:(CGFloat)accelerameter withHandel:(void (^)(BOOL active))callBack;

/**
 停止速度传感器检测
 */
-(void)stopAccelerometer;

@end
