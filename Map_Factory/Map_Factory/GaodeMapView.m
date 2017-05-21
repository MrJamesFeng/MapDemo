//
//  GaodeMapView.m
//  Map_Factory
//
//  Created by 丰静 on 2017/5/21.
//  Copyright © 2017年 丰静. All rights reserved.
//

#import "GaodeMapView.h"
@interface GaodeMapView()

@property(nonatomic,strong)MKMapView *mapView;

@end
@implementation GaodeMapView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super init]) {
        _mapView = [[MKMapView alloc]initWithFrame:frame];
    }
    return self;
}

-(UIView *)getMapView{
    return _mapView;
}
@end
