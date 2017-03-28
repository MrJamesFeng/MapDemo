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

@interface ViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,MKAnnotation>

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
    
    [self updateMapDisplay];//调整地图当前合适位置

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

    FJAnnotation *annotation = [[FJAnnotation alloc]init];
    annotation.coordinate = location.coordinate;
    //[annotation setCoordinate:location.coordinate];
    //[self.mapView addAnnotation:annotation];
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
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if (annotation == mapView.userLocation) {
      return nil;
    }
    return nil;
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
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
