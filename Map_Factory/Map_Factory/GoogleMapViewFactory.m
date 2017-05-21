//
//  GoogleMapViewFactory.m
//  Map_Factory
//
//  Created by 丰静 on 2017/5/21.
//  Copyright © 2017年 丰静. All rights reserved.
//

#import "GoogleMapViewFactory.h"
@interface GoogleMapViewFactory()

@property(nonatomic,strong)GMSServices *mapManager;

@end
@implementation GoogleMapViewFactory

-(void)startWithAppkey:(NSString *)appKey{
    [GMSServices provideAPIKey:appKey];
    
}

-(id<MapViewProtocol>)getMapViewWithFrame:(CGRect)frame{
    return [[[GoogleMapView alloc]init] initWithFrame:frame];
}
@end
