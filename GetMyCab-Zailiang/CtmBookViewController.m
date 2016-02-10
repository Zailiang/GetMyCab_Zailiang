//
//  CtmBookViewController.m
//  GetMyCab-Zailiang
//
//  Created by Zailiang Yu on 2/9/16.
//  Copyright © 2016 Zailiang Yu. All rights reserved.
//

#import "CtmBookViewController.h"
#import "AppDelegate.h"
#import "CtmLogInViewController.h"


@interface CtmBookViewController ()
{
    MKPointAnnotation *pin_start;
    MKPointAnnotation *pin_end;
    
    CLLocationCoordinate2D coordinate;
    
    MKCoordinateRegion region;
    
    CLGeocoder * geocoder;
    CLPlacemark * placemark;

}

@property (weak, nonatomic) IBOutlet UITextField *txtField_PickUp;
@property (weak, nonatomic) IBOutlet UITextField *txtField_DropOff;


@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(nonatomic)CLLocationManager * locationManager;


@end

@implementation CtmBookViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mapView.delegate=self;
    _locationManager.delegate=self;
    
    UIBarButtonItem * btn_done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = btn_done   ;
   
    UIBarButtonItem * btn_back = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = btn_back;
    
     geocoder = [[CLGeocoder alloc]init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.mapView.showsUserLocation = YES;
    
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    [self.locationManager setDelegate:self] ;
    [self.locationManager startUpdatingLocation];
   // NSLog(@"%f,%f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude);
    
    coordinate = self.locationManager.location.coordinate;
    coordinate.latitude += 0.001;
    pin_start = [[MKPointAnnotation alloc] init];
    pin_start.title = @"Pick-Up Place";
    pin_start.coordinate = coordinate;
    
    coordinate.longitude+=0.001;
    pin_end = [[MKPointAnnotation alloc]init];
    pin_end.title = @"Drop-Off Place";
    pin_end.coordinate = coordinate;
    
    region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 800, 800);
    [self.mapView setRegion:region];
    


}

#pragma mark MapKit delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    // method called when user is moving
    
    //---display the  point pin
    [self.mapView addAnnotation:pin_start];
    
    [self.mapView addAnnotation:pin_end];
    
    //---show the coordination
    [self.txtField_PickUp setText:[NSString stringWithFormat: @"%.4f+%.4f",pin_start.coordinate.latitude,pin_start.coordinate.longitude]];
    
    [self.txtField_DropOff setText:[NSString stringWithFormat: @"%.4f+%.4f",pin_end.coordinate.latitude,pin_end.coordinate.longitude]];


    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView* )view{
    [self.txtField_PickUp setText:[NSString stringWithFormat: @"%.4f+%.4f",pin_start.coordinate.latitude,pin_start.coordinate.longitude]];
    
    [self.txtField_DropOff setText:[NSString stringWithFormat: @"%.4f+%.4f",pin_end.coordinate.latitude,pin_end.coordinate.longitude]];}

#pragma mark- Annotation delegate

-(MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
   
    if ([annotation isKindOfClass:[MKUserLocation class]]){
         return nil;
    }else if([annotation isKindOfClass:[MKPointAnnotation class]]){

     MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
        pinView.draggable = YES;
        pinView.canShowCallout=YES;
       
        if([annotation.title isEqualToString:@"Pick-Up Place"])
        {
                    }
        else if ([annotation.title isEqualToString:@"Drop-Off Place"])
        {
            pinView.pinTintColor = [UIColor greenColor];
        }
        return pinView;

        
        
    }else{
        return nil;

    }
}

-(void)done{
    
    //transfer Pick-Up coordinate to location format
    CLLocation *location = [[CLLocation alloc]
                            initWithLatitude:pin_start.coordinate.latitude
                            longitude:pin_start.coordinate.longitude];

    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error==nil && [placemarks count]>0) {
            placemark = [placemarks lastObject];
            
            NSLog(@"inside:%@",placemark.locality);
            
            AppDelegate* myappdelegate = [[UIApplication sharedApplication ]delegate];
            myappdelegate.pickupLocation=placemark.locality;
            
        }else{
            NSLog(@"%@",error.debugDescription);
        }
    }];

    NSLog(@"outside:%@",placemark.locality);// null!!!

    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}



-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
