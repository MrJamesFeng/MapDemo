//
//  GoogleMapView.m
//  Map_Factory
//
//  Created by 丰静 on 2017/5/21.
//  Copyright © 2017年 丰静. All rights reserved.
//

#import "GoogleMapView.h"
@interface GoogleMapView()

@property(nonatomic,strong)GMSMapView *mapView;

@end
@implementation GoogleMapView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super init]) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                                longitude:151.20
                                                                     zoom:6];
        _mapView = [GMSMapView mapWithFrame:frame camera:camera];
        _mapView.myLocationEnabled = YES;
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
        marker.title = @"Sydney";
        marker.snippet = @"Australia";
        marker.map = _mapView;
        
    }
    return self;
}

-(UIView *)getMapView{
    return _mapView;
}
@end
