//
//  MapEngineParser.m
//  Map_Factory
//
//  Created by 丰静 on 2017/5/21.
//  Copyright © 2017年 丰静. All rights reserved.
//

#import "MapEngineParser.h"
@interface MapEngineParser()<NSXMLParserDelegate>

@property(nonatomic,strong)NSMutableArray<MapEngineModel *> *results;

@end
@implementation MapEngineParser

-(NSMutableArray<MapEngineModel *> *)parser{
    _results = [NSMutableArray array];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"MapEngineConfig" ofType:@"xml"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSXMLParser *parser = [[NSXMLParser alloc]initWithContentsOfURL:fileUrl];
    parser.delegate = self;
    [parser parse];
    return _results;
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    if ([elementName isEqualToString:@"MapFactory"]) {
        MapEngineModel *engineModel = [MapEngineModel new];
        [engineModel setValuesForKeysWithDictionary:attributeDict];
        [_results addObject:engineModel];
    }
}
@end
