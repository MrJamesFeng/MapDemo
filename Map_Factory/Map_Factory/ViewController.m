//
//  ViewController.m
//  Map_Factory
//
//  Created by 丰静 on 2017/5/21.
//  Copyright © 2017年 丰静. All rights reserved.
//

#import "ViewController.h"
#import "MapEngine.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    id<MapViewFactoryProtocol>factory = [[MapEngine shareMapEngine]getMapFactoryWithMapType:GoogleMapType];
    id<MapViewProtocol>mapView = [factory getMapViewWithFrame:self.view.bounds];
    UIView *map = [mapView getMapView];
    [self.view addSubview:map];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
