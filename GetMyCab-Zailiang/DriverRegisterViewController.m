//
//  DriverRegisterViewController.m
//  GetMyCab-Zailiang
//
//  Created by Zailiang Yu on 2/1/16.
//  Copyright © 2016 Zailiang Yu. All rights reserved.
//

#import "DriverRegisterViewController.h"
#import "textfieldTableViewCell2.h"
#import "ImagePickerTableViewCell.h"
#import "DriverHomeViewController.h"


@interface DriverRegisterViewController (){
    
    NSArray * arrItem;
    NSString *selectedDate;
    NSData * imgData;
    
    NSMutableArray * arrItemValue;
    DriverInfo * driverInfo;
    
    CLLocationManager * locationManager;
    CLGeocoder * geocoder;
    CLPlacemark * placemark;
    
    NSString* errorMsg;
}


@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btn_submit:(id)sender;


- (IBAction)btn_tapped:(id)sender;


@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)datePickerTapped:(id)sender;
- (IBAction)btn_datePiker_Done:(id)sender;
- (IBAction)btn_datePiker_Cancel:(id)sender;

@end

@implementation DriverRegisterViewController

static bool nameFLAG=NO;
static bool emailFLAG=NO;
static bool mobileFLAG=NO;
static bool pwdFLAG=NO;
static bool confirmpwdFLAG=NO;
static bool vehicleNoFLAG=NO;
static bool licenseNoFLAG=NO;
static bool emergencyNoFLAG=NO;
static bool ageFLAG=NO;
static bool photoFLAG=NO;
static bool eqFlag=NO;
static bool bloodFlag = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrItem = [NSArray arrayWithObjects:@"Full Name",@"Email",@"Mobile No.",@"Password",@"Confirm Password",@"Vehicle No.",@"License No.",@"Emergency No.",@"DOB",@"Edu-Quali",@"Blood Type",@"Photo",@"City", nil];
    
    [self.datePicker setEnabled:NO];
    [self.datePicker setHidden:YES];
    [self.subView setHidden:YES];
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    arrItemValue = [[NSMutableArray alloc]initWithCapacity:14];
    for (int i=0; i<13; i++) {
        arrItemValue[i]=@" ";
        //[arrItemValue insertObject:@" " atIndex:i];
        
        
        UIBarButtonItem * btn_back = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = btn_back;

    }
 
    
   // driverInfo = [[DriverInfo alloc] init];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    errorMsg= @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrItem.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row<11) {
        textfieldTableViewCell2 * cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        [cell.label setText:arrItem[indexPath.row]];
        [cell.textfield setTag:indexPath.row+1];
        
        if (indexPath.row==3||indexPath.row==4) {
            cell.textfield.placeholder = @"5 to 10 charactor";
            [cell.textfield setSecureTextEntry:YES];
        }else{
            [cell.textfield setSecureTextEntry:NO];
        }
        
        if (indexPath.row==8||indexPath.row==9||indexPath.row==10) {
            [cell.btn_enable setHidden:NO];
            [cell.btn_enable setTag:indexPath.row+1];
        }else{
            [cell.btn_enable setHidden:YES]; //[cell.btn_enable setEnabled:NO];
        }
        
        
        if ([arrItemValue[indexPath.row] isEqualToString:@" "]) {
            [cell.textfield setText:@""];
        }else{
       [cell.textfield setText:arrItemValue[indexPath.row]];
        }
        
        return cell;
    }else if(indexPath.row==12){  // city
        textfieldTableViewCell2  * cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        [cell.label setText:arrItem[indexPath.row]];
        [cell.textfield setTag:indexPath.row+1];
        [self getCurrentLocation];
        cell.textfield.text=arrItemValue[12];
        [cell.textfield setSecureTextEntry:NO];
        return cell;
        
    }else { //  if(indexPath.row == 11)   image picture
        ImagePickerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        [cell.label setText:arrItem[indexPath.row]];
        
        /////////////////////////////////////////
        [cell.imgview setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
        [singleTap setNumberOfTapsRequired:1];
        [cell.imgview addGestureRecognizer:singleTap];
        
        //////////////////////////////////////////
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==11) {
        return 150;
    }else
        return 50;
}


#pragma mark textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField setText:nil];
    
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
   
    
//    if (textField.tag == 9) {
//        [self.datePicker setEnabled:YES];
//        [self.datePicker setHidden:NO];
//        [self.subView setHidden:NO];
//       // [textField resignFirstResponder];
//    }else if (textField.tag == 10){
//        [self presentAlertEQ];
//        //[textField resignFirstResponder];
//    }else if (textField.tag == 11){
//        [self presentAlertBloodType];
//       // [textField resignFirstResponder];
//    }

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length==0) {
        textField.text=@" ";
        arrItemValue[([textField tag]-1)]=textField.text;
    }else{
        arrItemValue[([textField tag]-1)]=textField.text;
        }
   
    [textField resignFirstResponder];
    

    
    
    
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    [textField resignFirstResponder];
    
    
    ////////    validation     /////////////
    
    if(textField.tag==1){
        //full name
        NSString *conditionName = @"[A-Za-z\\s-]{1,10}";
        NSPredicate *predicatename = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", conditionName];
        if ([predicatename evaluateWithObject:arrItemValue[0]]) {
            nameFLAG = YES;
            [textField setTextColor:[UIColor blackColor]];
        }else{
            nameFLAG = NO;
            [textField setTextColor:[UIColor redColor]];
            textField.text=@"Not valid name";
            errorMsg = [errorMsg stringByAppendingString:@"Please enter valid Name.\n"];
            [self alert];
        }
        
    }else if (textField.tag == 2){
        // Email
        NSString *conditionEmail = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}";
        NSPredicate *predicateEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", conditionEmail];
        if ([predicateEmail evaluateWithObject:arrItemValue[1]]) {
            emailFLAG = YES;
            [textField setTextColor:[UIColor blackColor]];
        }else{
            emailFLAG = NO;
            [textField setTextColor:[UIColor redColor]];
            textField.text=@"Not valid Email";
            errorMsg = [errorMsg stringByAppendingString:@"Please enter valid Email.\n"];
            [self alert];
        }
        
    }else if (textField.tag == 3){
        // Mobile No.
        NSString *conditionMobile = @"[0-9]{10}";
        NSPredicate *predicateMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", conditionMobile];
        if ([predicateMobile evaluateWithObject:arrItemValue[2]]) {
            mobileFLAG = YES;
            [textField setTextColor:[UIColor blackColor]];
        }else{
            mobileFLAG = NO;
            [textField setTextColor:[UIColor redColor]];
            textField.text=@"Should be 10 digits";
            errorMsg = [errorMsg stringByAppendingString:@"Telephone No. should be 10 digits.\n"];
            [self alert];
        }
        
    }else if (textField.tag ==4){
        // Password
        NSString *conditionPassword = @"[A-Z0-9a-z._%+-@!]{5,10}";
        NSPredicate *predicatePassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", conditionPassword];
        if ([predicatePassword evaluateWithObject:arrItemValue[3]]) {
            pwdFLAG = YES;
            [textField setTextColor:[UIColor blackColor]];
        }else{
            pwdFLAG = NO;
            [textField setTextColor:[UIColor redColor]];
            textField.text=@"5 to 10 characters";
            errorMsg = [errorMsg stringByAppendingString:@"Password should be 5 to 10 characters.\n"];
            [self alert];
        }
        
    }else  if (textField.tag==5){
        // Confirm Password
        if ([arrItemValue[4]isEqualToString:arrItemValue[3]]) {
            confirmpwdFLAG = YES;
            [textField setTextColor:[UIColor blackColor]];
        }else{
            confirmpwdFLAG = NO;
            [textField setTextColor:[UIColor redColor]];
            textField.text=@"Password not same";
            errorMsg = [errorMsg stringByAppendingString:@"Confirm Password should be same.\n"];
            [self alert];
        }
        
    }else if (textField.tag ==6){
        // Vehicle No.
        if ([textField.text isEqualToString:@" "]) {
            [textField setTextColor:[UIColor redColor]];
            textField.text=@"Necessary";
            errorMsg = [errorMsg stringByAppendingString:@"VIN can't be empty.\n"];
            [self alert];
            vehicleNoFLAG = NO;
        }else{
            vehicleNoFLAG = YES;
            [textField setTextColor:[UIColor blackColor]];
        }
    }else if(textField.tag==7){
        // License No.
        if ([textField.text isEqualToString:@" "]) {
            [textField setTextColor:[UIColor redColor]];
            textField.text=@"Necessary";
            errorMsg = [errorMsg stringByAppendingString:@"Licence NO. can't be empty.\n"];
            [self alert];
            licenseNoFLAG = NO;
        }else{
            licenseNoFLAG = YES;
            [textField setTextColor:[UIColor blackColor]];
            
        }
        
    }else if(textField.tag == 8){
        // Emergency No.
        NSString *conditionemergencyNo = @"[0-9]{10}";
        NSPredicate *predicateemergencyNo = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", conditionemergencyNo];
        if ([predicateemergencyNo evaluateWithObject:arrItemValue[7]]) {
            emergencyNoFLAG = YES;
            [textField setTextColor:[UIColor blackColor]];
        }else{
            [textField setTextColor:[UIColor redColor]];
            textField.text=@"Phone No. is 10 digits";
            errorMsg = [errorMsg stringByAppendingString:@"Emergency No. should be 10 digits.\n"];
            [self alert];
            emergencyNoFLAG = NO;
        }
        
    }

    
    
    return YES  ;
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    return YES;
//}


#pragma mark AlertSheet method
-(void)presentAlertEQ{
    UIAlertController *alertEQ;
    alertEQ=[UIAlertController alertControllerWithTitle:@"Education Qualification" message:@"Your Education Qualification" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction * actionhigh=[UIAlertAction actionWithTitle:@"High school" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:10];
        textfield.text=@"High school";
        arrItemValue[9]=textfield.text;
    }];
    UIAlertAction * actionbachelor=[UIAlertAction actionWithTitle:@"Bachelor" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:10];
        textfield.text=@"Bachelor";
        arrItemValue[9]=textfield.text;
    }];
    UIAlertAction * actionmaster=[UIAlertAction actionWithTitle:@"Master" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:10];
        textfield.text=@"Master";
        arrItemValue[9]=textfield.text;
    }];
    UIAlertAction * actionDoctor=[UIAlertAction actionWithTitle:@"PHD" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:10];
        textfield.text=@"PHD";
        arrItemValue[9]=textfield.text;
    }];
        UIAlertAction * actionOther=[UIAlertAction actionWithTitle:@"Other" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:10];
        textfield.text=@"Other";
            arrItemValue[9]=textfield.text;
    }];
    
    [alertEQ addAction:actionhigh];
    [alertEQ addAction:actionbachelor];
    [alertEQ addAction:actionmaster];
    [alertEQ addAction:actionDoctor];
    [alertEQ addAction:actionOther];
    eqFlag = YES;
    [self presentViewController:alertEQ animated:YES completion:nil];
}


-(void)presentAlertBloodType{
     UIAlertController *alertBT;
    alertBT=[UIAlertController alertControllerWithTitle:@"Blood Type" message:@"Your Blood Type" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * actionA=[UIAlertAction actionWithTitle:@"A" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:11];
        textfield.text=@"A";
        arrItemValue[10]=textfield.text;
    }];
    UIAlertAction * actionB=[UIAlertAction actionWithTitle:@"B" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:11];
        textfield.text=@"B";
        arrItemValue[10]=textfield.text;
    }];
    UIAlertAction * actionAB=[UIAlertAction actionWithTitle:@"AB" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:11];
        textfield.text=@"AB";
        arrItemValue[10]=textfield.text;
    }];
    UIAlertAction * actionO=[UIAlertAction actionWithTitle:@"O" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:11];
        textfield.text=@"O";
        arrItemValue[10]=textfield.text;
    }];
    UIAlertAction * actionRH=[UIAlertAction actionWithTitle:@"RH" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:11];
        textfield.text=@"RH";
        arrItemValue[10]=textfield.text;
    }];
    [alertBT addAction:actionA];
    [alertBT addAction:actionB];
    [alertBT addAction:actionAB];
    [alertBT addAction:actionO];
    [alertBT addAction:actionRH];
    bloodFlag=YES;
    [self presentViewController:alertBT animated:YES completion:nil];
}


#pragma mark button Actions
- (IBAction)btn_submit:(id)sender {
    
    
    // Photo
    if (imgData) {
        photoFLAG=YES;
        
    }else{
        photoFLAG=NO;
    }
    
    
    //--------- check validate-----------/
    if (nameFLAG&&emailFLAG&&mobileFLAG&&pwdFLAG&&confirmpwdFLAG&&vehicleNoFLAG&&licenseNoFLAG&&emergencyNoFLAG&&ageFLAG&&photoFLAG&&bloodFlag&&eqFlag){
        //NSLog(@"Register successful");
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:[self getURLRequestForRegistration] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString* responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                NSLog(@"response string from server:%@",responseString);
                if ([responseString rangeOfString:@"success"].location !=NSNotFound) {
                    
//                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Register successfully!" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                        DriverHomeViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverHomeViewController"];
                        [self.navigationController pushViewController:vc animated:YES];
                        
//                    }];
//                    [alert addAction:action];
//                    [self presentViewController:alert animated:YES completion:nil];
                    
                }else {
                    
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:responseString preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
            });
        }
    } ]resume ];

    }else{
        [self alertSubmin];
    }

    
}

-(NSURLRequest*)getURLRequestForRegistration{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://rjtmobile.com/ansari/regtestdriver.php?name=%@&email=%@&mobile=%@&password=%@&vechile=%@&license=%@&city=%@",arrItemValue[0],arrItemValue[1],arrItemValue[2],arrItemValue[3],arrItemValue[5],arrItemValue[6],arrItemValue[12]]];

    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:180];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];//??????? setValue????
    return urlRequest   ;
}


- (IBAction)btn_tapped:(id)sender {
    [self.view endEditing:NO];
    
    if ([sender tag] == 9) {
        [self.datePicker setEnabled:YES];
        [self.datePicker setHidden:NO];
        [self.subView setHidden:NO];

    }else if ([sender tag] == 10){
        [self presentAlertEQ];
    }else if ([sender tag] == 11){
        [self presentAlertBloodType];
    }

}


#pragma image button
-(void)imageTapped{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    picker.allowsEditing = YES;
    picker.navigationBar.barStyle = UIBarStyleBlack;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:picker animated:YES completion:nil];

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    ImagePickerTableViewCell * cell  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
    [cell.imgview setImage:img];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    imgData=UIImagePNGRepresentation(img);
    
    arrItemValue[11]= imgData;
}

#pragma mark datePicker

- (IBAction)datePickerTapped:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    selectedDate = formatedDate;

}

- (IBAction)btn_datePiker_Done:(id)sender {
    [_datePicker setEnabled:NO];
    [_datePicker setHidden:YES];
    [self.subView setHidden:YES];
    
     UITextField *textField=(UITextField*)[self.view viewWithTag:9];
     textField.text=selectedDate;
    arrItemValue[[textField tag]-1]=selectedDate;
    
    
    // Age validationg
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *nowDate = [dateFormatter stringFromDate:[NSDate date]];
    NSArray *nowDateArr = [nowDate componentsSeparatedByString:@"-"];
    NSArray *infoDateArr = [arrItemValue[8] componentsSeparatedByString:@"-"];
    NSLog(@"%@", infoDateArr);
    if (arrItemValue[8]) {
        if ([nowDateArr[2] intValue]-[infoDateArr[2] intValue]>18) {
            ageFLAG = YES;
        }else if ([nowDateArr[2] intValue]-[infoDateArr[2] intValue]<18){
            ageFLAG = NO;
            errorMsg = [errorMsg stringByAppendingString:@"Too young for driving.\n"];
            [self alert];
        }else{
            if ([nowDateArr[0] intValue]-[infoDateArr[0] intValue]>0) {
                ageFLAG = YES;
            }
            else if ([nowDateArr[0] intValue]-[infoDateArr[0] intValue]<0){
                ageFLAG = NO;
                errorMsg = [errorMsg stringByAppendingString:@"Too young for driving.\n"];
                [self alert];
            }
            else{
                if ([nowDateArr[1] intValue]-[infoDateArr[1] intValue]>=0) {
                    NSLog(@"Age is valid");
                    ageFLAG = YES;
                }
                else if ([nowDateArr[1] intValue]-[infoDateArr[1] intValue]<0){
                    ageFLAG = NO;
                    errorMsg = [errorMsg stringByAppendingString:@"Too young for driving.\n"];
                    [self alert];

                }
            }
        }
    }else{
        ageFLAG = NO;
    }

}

- (IBAction)btn_datePiker_Cancel:(id)sender {
    [_datePicker setEnabled:NO];
    [_datePicker setHidden:YES];
    [self.subView setHidden:YES];

}

#pragma mark - CLLocationManagerDelegate
-(void)getCurrentLocation{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    

}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    
    //NSLog(@"Location array:%@",locations);
    //NSLog(@"didUpdateToLocation: %@", [locations lastObject]);
    
    CLLocation* currentLocation = [locations lastObject];
   // NSLog(@"Lat: %f- Long:%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    [locationManager stopUpdatingLocation];
    
    //Reverse Geocoding
    //NSLog(@"Resolving the Address");
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error==nil && [placemarks count]>0) {
            placemark = [placemarks lastObject];
            
           textfieldTableViewCell2 * cell  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];
            NSString* string =[NSString stringWithFormat:@"%@", placemark.locality];
            [cell.textfield setText:string];
            arrItemValue[12]=string;
            //[arrItemValue insertObject:string atIndex:12];
            
            // UITextField *textfield=(UITextField*)[self.view viewWithTag:13];
           // textfield.text = [NSString stringWithFormat:@"%@", placemark.locality];
            
            //NSLog(@"%@",placemark);
            
        }
    }];
    
    
}

#pragma mark alertTextfield
-(void)alert{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        errorMsg=@"";
    }];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)alertSubmin{
    if (nameFLAG==NO) {
        errorMsg = [errorMsg stringByAppendingString: @"Please enter valid Name.\n"];
    }
    if(emailFLAG==NO ){
        errorMsg = [errorMsg stringByAppendingString:@"Please enter valid Email.\n"];
     }
    if(mobileFLAG==NO){
        errorMsg = [errorMsg stringByAppendingString:@"Telephone No. should be 10 digits.\n"];
                    }
    if( pwdFLAG==NO ){
     errorMsg = [errorMsg stringByAppendingString:@"Password should be 5 to 10 characters.\n"];
                    }
    if(confirmpwdFLAG==NO  ){
       errorMsg = [errorMsg stringByAppendingString:@"Confirm Password should be same.\n"];
                    }
    if( vehicleNoFLAG ==NO ){
     errorMsg = [errorMsg stringByAppendingString:@"VIN can't be empty.\n"];
                    }
    if(  licenseNoFLAG  ==NO ){
    errorMsg = [errorMsg stringByAppendingString:@"Licence NO. can't be empty.\n"];
                    }
    if(   emergencyNoFLAG  ==NO){
    errorMsg = [errorMsg stringByAppendingString:@"Emergency No. should be 10 digits.\n"];
                }
    if(   ageFLAG  ==NO){
    errorMsg = [errorMsg stringByAppendingString:@"D.O.B is necessary.\n"];
                    }
    if(   photoFLAG ==NO ){
    errorMsg = [errorMsg stringByAppendingString:@"Photo is necessary.\n"];
                    }
    if(   eqFlag ==NO ){
      errorMsg = [errorMsg stringByAppendingString:@"Education Qualification is necessary\n"];
                                    }
    if(   bloodFlag ==NO ){
      errorMsg = [errorMsg stringByAppendingString:@"Blood Group can't be blank\n"];
                                                    }    
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        errorMsg=@"";
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
