//
//  DriverHomeViewController.m
//  GetMyCab-Zailiang
//
//  Created by Zailiang Yu on 2/8/16.
//  Copyright © 2016 Zailiang Yu. All rights reserved.
//

#import "DriverHomeViewController.h"

@interface DriverHomeViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic)CLLocationManager * locationManager;


- (IBAction)btn_onDuty:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_onDutyClicked;

- (IBAction)btn_offDuty:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_offDutyClicked;


@end

@implementation DriverHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",self.mobile);
    
    self.mapView.showsUserLocation = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MapKit delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 1000);
    [self.mapView setRegion:region];
    
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://rjtmobile.com/ansari/driver_cords.php?mobile=%@&latitude=%f&longitude=%f",self.mobile,userLocation.coordinate.latitude,userLocation.coordinate.longitude]];
    
    //--- excute URLRequest ---//
    [[[NSURLSession sharedSession]dataTaskWithRequest:[self getURLRequestForRegistration:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",error);
        if (!error) {
            NSString* responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"response string from server:%@",responseString);
            dispatch_sync(dispatch_get_main_queue(), ^{

            NSLog(@"%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
            });
        }
    }] resume];//resume!!!
   
}

//---- prepare the URL Request ------//
-(NSURLRequest*)getURLRequestForRegistration:(NSURL*)url{
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:180];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    return urlRequest   ;
}


- (IBAction)btn_onDuty:(id)sender {
    [self.btn_onDutyClicked setEnabled:NO];
    [self.btn_offDutyClicked setEnabled:YES];
    
    self.mapView.showsUserLocation = YES;
    
    self.locationManager.delegate = self;
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    
    [self.locationManager startUpdatingLocation];
    
    


}
- (IBAction)btn_offDuty:(id)sender {
    [self.btn_onDutyClicked setEnabled:YES];
    [self.btn_offDutyClicked setEnabled:NO];
    
    [self.locationManager stopUpdatingLocation];
    self.mapView.showsUserLocation = NO;

    
}
@end
