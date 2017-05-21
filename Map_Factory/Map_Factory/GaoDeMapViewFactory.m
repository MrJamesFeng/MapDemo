//
//  GaoDeMapViewFactory.m
//  Map_Factory
//
//  Created by 丰静 on 2017/5/21.
//  Copyright © 2017年 丰静. All rights reserved.
//

#import "GaoDeMapViewFactory.h"
@interface GaoDeMapViewFactory()

@property(nonatomic,strong)AMapServices *mapManager;

@end
@implementation GaoDeMapViewFactory

-(void)startWithAppkey:(NSString *)appKey{
    _mapManager = [AMapServices sharedServices];
    _mapManager.apiKey = appKey;
    
}

-(id<MapViewProtocol>)getMapViewWithFrame:(CGRect)frame{
    return [[[GaodeMapView alloc]init] initWithFrame:frame];
}
@end
