//
//  BaiMapViewFactory.m
//  Map_Factory
//
//  Created by 丰静 on 2017/5/21.
//  Copyright © 2017年 丰静. All rights reserved.
//

#import "BaiMapViewFactory.h"
#import "BaiDuMapView.h"

@interface BaiMapViewFactory()

@property(nonatomic,strong)BMKMapManager *mapManager;

@end
@implementation BaiMapViewFactory

-(void)startWithAppkey:(NSString *)appKey{
    _mapManager = [[BMKMapManager alloc]init];
    [_mapManager start:kBaiduMapAppkey generalDelegate:nil];
    
}

-(id<MapViewProtocol>)getMapViewWithFrame:(CGRect)frame{
    return [[[BaiDuMapView alloc]init] initWithFrame:frame];
}
@end
