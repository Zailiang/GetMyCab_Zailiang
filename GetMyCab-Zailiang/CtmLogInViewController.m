//
//  CtmLogInViewController.m
//  GetMyCab-Zailiang
//
//  Created by Zailiang Yu on 2/8/16.
//  Copyright © 2016 Zailiang Yu. All rights reserved.
//

#import "CtmLogInViewController.h"

@interface CtmLogInViewController ()
- (IBAction)btn_clicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_tapped;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) CLLocationManager * locationManager;

@end

@implementation CtmLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    [self.locationManager setDelegate:self] ;
      [self.locationManager startUpdatingLocation];
}

#pragma mark MapKit delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 1000);
    [self.mapView setRegion:region];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    [self.mapView addAnnotation:point];

}



- (IBAction)btn_clicked:(id)sender {
    [self.mapView setHidden:NO];
    [self.btn_tapped setHidden:YES];
}
@end

