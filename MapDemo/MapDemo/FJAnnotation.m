//
//  FJAnnotation.m
//  MapDemo
//
//  Created by LDY on 17/3/28.
//  Copyright © 2017年 LDY. All rights reserved.
//

#import "FJAnnotation.h"

@implementation FJAnnotation
-(CLLocationCoordinate2D)coordinate{
    CLLocationDegrees latitude = [[self valueForKeyPath:@"latitude"] doubleValue];
    CLLocationDegrees lontitude = [[self valueForKeyPath:@"longtitude"] doubleValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, lontitude);
    return coordinate;
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    [self setValue:@(newCoordinate.latitude) forKeyPath:@"latitude"];
    [self setValue:@(newCoordinate.longitude) forKeyPath:@"longitude"];
}

 

-(NSString *)title{
    return [self valueForKeyPath:@"placeName"];
}
-(NSString *)subtitle{
    NSString *subtitle = @"";
    NSString *addressString = [self valueForKeyPath:@"placeStreetAdress"];
    if (addressString.length>0) {
        NSString *city = [self valueForKeyPath:@"placeCity"];
        NSString *state = [self valueForKeyPath:@"placeState"];
        NSString *zip = [self valueForKeyPath:@"placePostal"];
        subtitle = [NSString stringWithFormat:@"%@ %@ %@ %@",addressString,city,state,zip];
    }
    return subtitle;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"UndefinedKey=%@",key);
};
@end
