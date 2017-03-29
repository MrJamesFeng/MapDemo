//
//  FJAnnotation.h
//  MapDemo
//
//  Created by LDY on 17/3/28.
//  Copyright © 2017年 LDY. All rights reserved.
//

#import <MapKit/MKFoundation.h>
#import <MapKit/MKAnnotation.h>
#warning bug 待解决FJAnnotation 0x17024e220> valueForUndefinedKey:]: this class is not key value coding-compliant for the key latitude
@interface FJAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;


@end
