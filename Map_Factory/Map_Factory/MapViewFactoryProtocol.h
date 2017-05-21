//
//  MapViewFactory.h
//  Map_Factory
//
//  Created by 丰静 on 2017/5/21.
//  Copyright © 2017年 丰静. All rights reserved.
//
#import <GoogleMaps/GoogleMaps.h>
#import"MapViewProtocol.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <UIKit/UIKit.h>
#import "GaodeMapView.h"
#import "GoogleMapView.h"

#define kBaiduMapAppkey @"csBRnyo5QyCI3medWcwPUDhYsPSlFxDG"
#define kGoogleMapAppkey @"AIzaSyAosXA1nj59xwl1LfL94GaVTcY4PCrqBeM"
#define kGaodeiMapAppkey @"be25e10f9901d7e9f3eb1358fe6db3a6"

@protocol MapViewFactoryProtocol <NSObject>

/**
 初始化sdk
    
 @param appKey appKey
 */
-(void)startWithAppkey:(NSString *)appKey;

/**
 生产mapView

 @param frame frame
 @return mapView
 */
-(id<MapViewProtocol>)getMapViewWithFrame:(CGRect)frame;

@end
