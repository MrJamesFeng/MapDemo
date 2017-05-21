//
//  ViewController.m
//  MapDemo
//
//  Created by LDY on 17/3/28.
//  Copyright © 2017年 LDY. All rights reserved.
//

#import "ViewController.h"
#import "FJAnnotation.h"
@import CoreLocation;
@import MapKit;

@interface ViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

@property(nonatomic,strong)CLLocationManager *locationManager;

@property(nonatomic,strong)MKMapView *mapView;

@property(nonatomic,assign)MKCoordinateSpan coordinateSpan;


@end
#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self checkLocationServices];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.mapView];
//    [self.mapView removeAnnotations:self.mapView.annotations];
//    [self.mapView removeOverlays:self.mapView.overlays];
    [self updateMapDisplay];//调整地图当前合适位置
    
//    [self geocoderEvent];//反／地理编码
    
    [self regionMonitorEvent];//地理围栏
    

}
-(void)mapPlan:(MKMapItem *)currentMapItem{
    
    
    //目的地
    CLLocationCoordinate2D destionationCoordinate = CLLocationCoordinate2DMake(22.58240600, 113.95438400);
    MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:destionationCoordinate];
    MKMapItem *destionaMapItem = [[MKMapItem alloc]initWithPlacemark:placemark];
    destionaMapItem.name = @"西丽";
    NSDictionary *launchOptions = @{
    MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
    MKLaunchOptionsMapTypeKey:[NSNumber numberWithInt:MKMapTypeStandard]
                                    };
    NSArray<MKMapItem *>*mapItems = @[destionaMapItem];
    BOOL success = [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
    if (success) {
        NSLog(@"打开成功");
    }else{
        NSLog(@"打开失败");
    }
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc]init];
    [directionsRequest setDestination:destionaMapItem];
    [directionsRequest setSource:currentMapItem];
    
    MKDirections *directions = [[MKDirections alloc]initWithRequest:directionsRequest];
    //添加路线
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error description%@",[error description]);
        }else{
//            MKRoute *firstRoute = response.routes.firstObject;
            for (MKRoute *route in response.routes) {
                for (MKRouteStep * routeStep in route.steps) {
                    NSLog(@"%f %@",routeStep.distance,routeStep.instructions);
                }
            }
            
            
        }
    }];
}
-(void)geocoderEvent{
    //地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
     [geocoder geocodeAddressString:@"深圳前海联动云汽车租赁有限公司" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
     for (CLPlacemark * mark in placemarks) {
     NSLog(@"%@",mark);
     }
     }];
//    +22.52388300,+113.91114400 深圳前海联动云汽车租赁有限公司
    
    
    //+22.58240600,+113.95438400 丽新花园
    CLLocation *location = [[CLLocation alloc]initWithLatitude:22.58240600 longitude:113.95438400];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error:%@",[error description]);
        }
        for (CLPlacemark * mark in placemarks) {
            NSLog(@"%@",mark);
        }
    }];
}
-(void)regionMonitorEvent{
    //监控能力检测
    if ([CLLocationManager isMonitoringAvailableForClass:[CLRegion class]]) {
        NSLog(@"Available OK");
        //监控位置信息
        NSSet *regions = [self.locationManager monitoredRegions];
        for (CLRegion *region in regions) {
            NSLog(@"region=%@",region);
        }
        CLRegion *region = [[CLRegion alloc]initCircularRegionWithCenter:CLLocationCoordinate2DMake(22.52388300, 113.91114400) radius:500 identifier:@"LDY"];
        [self.locationManager startMonitoringForRegion:region];
        
    }
}
-(void)updateMapDisplay{
    //调整地图显示位置
    CLLocationCoordinate2D maxCoordinate = CLLocationCoordinate2DMake(-90.0, -180.0);
    CLLocationCoordinate2D minCoordinate = CLLocationCoordinate2DMake(90.0, 180.0);
    NSArray *currentPlaces = [self.mapView annotations];
    maxCoordinate.latitude = [[currentPlaces valueForKeyPath:@"@max.latitude"] doubleValue];
    minCoordinate.latitude = [[currentPlaces valueForKeyPath:@"@min.latitude"] doubleValue];
    maxCoordinate.longitude = [[currentPlaces valueForKeyPath:@"@max.longitude"] doubleValue];
    minCoordinate.longitude = [[currentPlaces valueForKeyPath:@"@min.longitude"] doubleValue];
    
    //中心位置
    CLLocationCoordinate2D centerCoordinate;
    centerCoordinate.latitude = (maxCoordinate.latitude + minCoordinate.latitude)/2.0;
    centerCoordinate.longitude = (maxCoordinate.longitude + minCoordinate.longitude)/2.0;
    
    //跨度
    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = (maxCoordinate.latitude - minCoordinate.latitude) *1.2;
    coordinateSpan.longitudeDelta = (maxCoordinate.longitude - minCoordinate.longitude) *1.2;
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);
    
    self.coordinateSpan = coordinateSpan;
    
    [self.mapView setRegion:coordinateRegion animated:YES];
  
}

-(void)checkLocationServices{
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
        if ([CLLocationManager headingAvailable]) {
            CLLocationDegrees headingDegree = 2.0f;
            self.locationManager.headingFilter = headingDegree;
        }
    }else{
        NSLog(@"locationServicesEnabled = NO");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)mapTypeSelection:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.mapView setMapType:MKMapTypeStandard];
            break;
        case 1:
            [self.mapView setMapType:MKMapTypeSatellite];
            break;
        case 2:
            [self.mapView setMapType:MKMapTypeHybrid];
            break;
        default:
            break;
    }
}
#pragma CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit{
    
}
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    
}
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = [locations lastObject];
    CLLocationAccuracy horizionAccuracy = location.horizontalAccuracy;//单位:米
    CLLocationAccuracy verticalAccuracy = location.verticalAccuracy;
    NSDate *timeStamp = location.timestamp;
    CLLocationSpeed speed = location.speed;//m/s
    CLLocationDirection course = location.course;
    //NSLog(@"horizionAccuracy=%f verticalAccuracy=%f timeStamp=%@ speed=%f direction=%f location.coordinate.latitude=%f location.coordinate.longitude=%f",horizionAccuracy,verticalAccuracy,timeStamp,speed,course,location.coordinate.latitude,location.coordinate.longitude);
    
    [self.mapView setRegion:MKCoordinateRegionMake(location.coordinate,self.coordinateSpan) animated:YES];
    /*
     //bug 待解决
    FJAnnotation *annotation = [[FJAnnotation alloc]init];
    annotation.coordinate = location.coordinate;
    [self.mapView addAnnotation:annotation];
     */
    //[annotation setCoordinate:location.coordinate];
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc]init];
    pointAnnotation.coordinate = location.coordinate;
    pointAnnotation.title = @"xxxx";
    pointAnnotation.subtitle = @"ooooo";
    [self.mapView addAnnotation:pointAnnotation];
    
    //添加遮盖
    CLLocationDistance radius = 10;
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:location.coordinate radius:radius];
    [self.mapView addOverlay:circle];
    MKPlacemark *currentPlacemark = [[MKPlacemark alloc]initWithCoordinate:location.coordinate];
    MKMapItem *currentMapItem = [[MKMapItem alloc]initWithPlacemark:currentPlacemark];
    [self mapPlan:currentMapItem];//要在地图加载成功后调用
    
    
}
-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager{
    
    
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined :
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            break;
        case kCLAuthorizationStatusRestricted :
            NSLog(@"kCLAuthorizationStatusDenied");
            break;
        case kCLAuthorizationStatusAuthorizedAlways :
            NSLog(@"kCLAuthorizationStatusAuthorizedAlways");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse :
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
            break;
        default:
            NSLog(@"kCLAuthorizationStatusUnKnown");
            break;
    }
}
#pragma MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{//CalloutAccessory 为UIControl
    
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    MKPinAnnotationView//继承MKAnnotationView
//    MKAnnotationView//静态图片作为大头针图片
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if (!pinAnnotationView) {
      pinAnnotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
        [pinAnnotationView setPinTintColor:[UIColor greenColor]];
        [pinAnnotationView setCanShowCallout:YES];
        [pinAnnotationView setDraggable:YES];
//        pinAnnotationView.centerOffset = CGPointMake(100, 200);
//        pinAnnotationView.calloutOffset = CGPointMake(0, -200);//calloutOffset偏离大头针的位置

       
        
        
        //accessory left
        NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"line.png" ofType:nil];
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:imagePath]];
        [pinAnnotationView setLeftCalloutAccessoryView:leftView];
        //accessory right
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [pinAnnotationView setRightCalloutAccessoryView:rightBtn];
    }
    
    
    return pinAnnotationView;
 
    
    if (annotation == mapView.userLocation) {
      return nil;
    }
    return nil;
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        
//        MKCircleView *circleView = [[MKCircleView alloc]initWithOverlay:overlay];
        
        MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc]initWithCircle:overlay];
        circleRenderer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        circleRenderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        circleRenderer.lineWidth = 3.0f;
        return circleRenderer;
         
//        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
//        circleView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
//        circleView.lineWidth = 3.0f;
//        return circleView;
    }
   
    return nil;
}
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    return nil;
}
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    MKCoordinateRegion coordinateRegion = [mapView region];
    CLLocationCoordinate2D coordinate = coordinateRegion.center;
    MKCoordinateSpan coordinateSpan = coordinateRegion.span;
    //NSLog(@"latitude=%f longitude=%f latitudeDelta=%f longitudeDelta=%f",coordinate.latitude,coordinate.longitude,coordinateSpan.latitudeDelta,coordinateSpan.longitudeDelta);
    
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{
    switch (newState) {
        case MKAnnotationViewDragStateNone:
            NSLog(@"MKAnnotationViewDragStateNone");
            break;
        case MKAnnotationViewDragStateStarting:
            NSLog(@"MKAnnotationViewDragStateStarting");
            break;
        case MKAnnotationViewDragStateDragging:
            NSLog(@"MKAnnotationViewDragStateDragging");
            break;
        case MKAnnotationViewDragStateCanceling:
            NSLog(@"MKAnnotationViewDragStateCanceling");
            break;
        case MKAnnotationViewDragStateEnding:
            NSLog(@"MKAnnotationViewDragStateEnding");
//            [self addActivityIndicatorView:view];
           
        {
            UIActivityIndicatorViewStyle activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:activityIndicatorViewStyle];
            [activityIndicatorView startAnimating];
            [view setLeftCalloutAccessoryView:activityIndicatorView];
            
//            for (MKCircle *circle in [mapView overlays]) {
//                circle.coordinate = [view.annotation coordinate];
//               
//                [self.mapView addOverlay:circle];
//            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [activityIndicatorView stopAnimating];
            });
        }
          
            break;
            
        default:
            break;
    }

    
}


-(void)addActivityIndicatorView:(MKAnnotationView *)annotationView{
    UIActivityIndicatorViewStyle activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:activityIndicatorViewStyle];
    [activityIndicatorView startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [activityIndicatorView stopAnimating];
    });
    [annotationView setLeftCalloutAccessoryView:activityIndicatorView];
    
}
#pragma getter
-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.desiredAccuracy =  kCLLocationAccuracyBest;//精度
        _locationManager.distanceFilter = 100.0f;//位置变化后需要遍历的位置长度
        _locationManager.delegate = self;
        [_locationManager startMonitoringSignificantLocationChanges];//重大变更通知：位置变化>500m，两次通知时间>5min
    }
    return _locationManager;
}
-(MKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 64, kscreenWidth, kscreenHeight)];
        _mapView.delegate = self;
    }
    return _mapView;
}
@end
