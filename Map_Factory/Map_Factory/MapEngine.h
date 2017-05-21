//
//  MapEngine.h
//  Map_Factory
//
//  Created by 丰静 on 2017/5/21.
//  Copyright © 2017年 丰静. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapViewFactoryProtocol.h"

/**
 地图类型
 
 - BaiDuMapType: 百度地图
 - GaoDeMapType: 高德地图
 - GoogleMapType: 谷歌地图
 */
typedef NS_ENUM(NSInteger,MapTyp) {
    BaiDuMapType = 0,
    GaoDeMapType = 1,
    GoogleMapType = 2
};

@interface MapEngine : NSObject

+(instancetype)shareMapEngine;

/**
 初始化SDK
 */
-(void)start;

/**
 获取mapView

 @param mapType mapType
 @return mapView
 */
-(id<MapViewFactoryProtocol>)getMapFactoryWithMapType:(MapTyp)mapType;

@end
