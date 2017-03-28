//
//  FJAnnotation.h
//  MapDemo
//
//  Created by LDY on 17/3/28.
//  Copyright © 2017年 LDY. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;
@interface FJAnnotation : NSObject<MKAnnotation>

@property(nonatomic,copy)NSString *latitude;

@property(nonatomic,copy)NSString *longitude;


@end
