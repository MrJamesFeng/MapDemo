//
//  MapEngine.m
//  Map_Factory
//
//  Created by 丰静 on 2017/5/21.
//  Copyright © 2017年 丰静. All rights reserved.
//

#import "MapEngine.h"
#import "MapEngineParser.h"
#import "BaiMapViewFactory.h"
#import "GaoDeMapViewFactory.h"
#import "GoogleMapViewFactory.h"
@interface MapEngine()

@property(nonatomic,strong)id<MapViewFactoryProtocol>factory;

@property(nonatomic,strong)NSMutableArray<MapEngineModel *> *results;

@end
@implementation MapEngine
static MapEngine *mapEngine = nil;
+(instancetype)shareMapEngine{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapEngine = [[self alloc]init];
    });
    return mapEngine;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapEngine = [super allocWithZone:zone];
    });
    return mapEngine;
}
-(void)start{
    //读取配置文件
    MapEngineParser *engineParser = [[MapEngineParser alloc]init];
    _results = [engineParser parser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isOpen == %@",@"YES"];
    //初始化sdk
    for (MapEngineModel * engineModel in [_results filteredArrayUsingPredicate:predicate]) {
        [[NSClassFromString(engineModel.name) alloc]startWithAppkey:engineModel.appKey];
    }
}

-(id<MapViewFactoryProtocol>)getMapFactoryWithMapType:(MapTyp)mapType{
    switch (mapType) {
        case BaiDuMapType:
            return [[BaiMapViewFactory alloc]init];
        case GaoDeMapType:
            return [[GaoDeMapViewFactory alloc]init];
        case GoogleMapType:
            return [[GoogleMapViewFactory alloc]init];
        default:
            break;
    }
    return nil;
}

@end
