//
//  MapEngineParser.h
//  Map_Factory
//
//  Created by 丰静 on 2017/5/21.
//  Copyright © 2017年 丰静. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapEngineModel.h"
@interface MapEngineParser : NSObject

/**
 解析配置文件

 @return 配置
 */
-(NSMutableArray<MapEngineModel *> *)parser;
@end
