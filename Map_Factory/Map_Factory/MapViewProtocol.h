//
//  MapView.h
//  Map_Factory
//
//  Created by 丰静 on 2017/5/21.
//  Copyright © 2017年 丰静. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
@protocol MapViewProtocol <NSObject>

/**
 创建mapView

 @param frame frame
 @return mapView
 */
-(instancetype)initWithFrame:(CGRect)frame;


/**
 获取mapView

 @return mapView
 */
-(UIView *)getMapView;

@end
    
