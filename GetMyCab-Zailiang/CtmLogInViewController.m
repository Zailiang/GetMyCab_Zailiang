//
//  CtmLogInViewController.m
//  GetMyCab-Zailiang
//
//  Created by Zailiang Yu on 2/8/16.
//  Copyright © 2016 Zailiang Yu. All rights reserved.
//

#import "CtmLogInViewController.h"
#import "CtmBookViewController.h"
#import "AppDelegate.h"

@interface CtmLogInViewController (){
    
    NSString * pickUpLocation;
}
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
    
    UIBarButtonItem * btn_back = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = btn_back;

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
    
    
    //--- get pick-up location from AppDelegate ---//
    AppDelegate * myappdelegate = [[UIApplication sharedApplication]delegate];
    pickUpLocation = myappdelegate.pickupLocation;
    
    
    //--URL--//
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"http://rjtmobile.com/ansari/driver_search.php?city=%@",pickUpLocation]];
    NSLog(@"URL: %@",url);
    
    //--- excute URLRequest ---//
    [[[NSURLSession sharedSession]dataTaskWithRequest:[self getURLRequestForRegistration:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //NSLog(@"%@",error);
        if (!error) {
            NSString* responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"response string from server:%@",responseString);
            dispatch_sync(dispatch_get_main_queue(), ^{
    
                //NSLog(@"%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
            });
        }
    }] resume];//resume!!!
    

}

#pragma mark MapKit delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 1000);
    [self.mapView setRegion:region];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    [self.mapView addAnnotation:point];
    

}

//--- booking btn clicked ---//

- (IBAction)btn_clicked:(id)sender {
    
    CtmBookViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CtmBookViewController"];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [self.mapView setHidden:NO];
    //[self.btn_tapped setHidden:YES];
}



#pragma mark- URL

-(NSURLRequest*)getURLRequestForRegistration:(NSURL*)url{
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:180];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    return urlRequest   ;
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

