//
//  BaiDuMapView.m
//  Map_Factory
//
//  Created by 丰静 on 2017/5/21.
//  Copyright © 2017年 丰静. All rights reserved.
//

#import "BaiDuMapView.h"
@interface BaiDuMapView()

@property(nonatomic,strong)BMKMapView *mapView;

@end

@implementation BaiDuMapView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super init]) {
        _mapView = [[BMKMapView alloc]initWithFrame:frame];
    }
    
    return self;
}

-(UIView *)getMapView{
    return _mapView;
}

@end
