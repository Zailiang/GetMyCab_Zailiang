//
//  CtmRegisterViewController.m
//  GetMyCab-Zailiang
//
//  Created by Zailiang Yu on 2/1/16.
//  Copyright © 2016 Zailiang Yu. All rights reserved.
//

#import "CtmRegisterViewController.h"
#import "textfieldTableViewCell.h"


@interface CtmRegisterViewController ()
{
    NSArray * arrItem;
    NSMutableArray * arrItemValue;
    textfieldTableViewCell * cell;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)btn_submit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_submitTapped;

@end

@implementation CtmRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    arrItem = [NSArray arrayWithObjects:@"Full Name",@"Email",@"Mobile NO.",@"Password",@"Confirm Password", nil];
    arrItemValue = [[NSMutableArray alloc]initWithCapacity:14];
    
    
    //----  hide the unused tableView cell  ----//
   // self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //hide the separator line
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrItem.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell_textfield"];
   // [cell.lbl setTag:indexPath.row+1];
    [cell.lbl setText:[arrItem objectAtIndex:indexPath.row]];
  //  [cell.lbl setTextColor:[UIColor redColor]];
    
    [cell.textfield setTag:indexPath.row+1];
    
    return cell;
}


#pragma mark- textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
   // UILabel * lb = [self.view viewWithTag:cell.textfield.tag];
    //  UILabel * lb = (UILabel*) [self.view viewWithTag:i];
    NSString * password;
  
    
    //for (int i=1; i<(arrItem.count+1); i++) {
      //  UITextField* tf = (UITextField*)[self.view viewWithTag:i];
   // UITextField* tf1 = (UITextField*)[self.view viewWithTag:1];
//    UITextField* tf2 = (UITextField*)[self.view viewWithTag:2];
//    UITextField* tf3 = (UITextField*)[self.view viewWithTag:3];
//    UITextField* tf4 = (UITextField*)[self.view viewWithTag:4];
//    UITextField* tf5 = (UITextField*)[self.view viewWithTag:5];

        if (textField.tag == 1) { // textField == tf1 full name
            NSString *nameRegex = @"[A-Za-z\\s]{5,20}";
            NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
            BOOL nameValidate = [nameTest evaluateWithObject: textField.text ];
            if (!nameValidate){
                [textField setTextColor:[UIColor redColor]];
                
                textField.text = @"Name invalid";
            }
            else{
                [textField setTextColor:[UIColor blueColor]];
        }
 //[tf2 becomeFirstResponder];

        }else if(textField.tag == 2){ //Email
            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            BOOL emailValidate = [emailTest evaluateWithObject:textField.text];
            if (!emailValidate){
                [textField setTextColor:[UIColor redColor]];
                textField.text = @"Please enter corrent Email";
            }
            else{
                [textField setTextColor:[UIColor blueColor]];
            }
 //[tf3 becomeFirstResponder];

        }else if(textField.tag == 3){ //Telephone
            
            NSString *phoneRegex = @"[0-9]{10,11}";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
            BOOL phoneValidate = [phoneTest evaluateWithObject:textField.text];
            if (!phoneValidate) {
               [ textField setTextColor:[UIColor redColor]];
                textField.text = @"TelNO. is 10 or 11 digits";
            }
            else{
                 [textField setTextColor:[UIColor blueColor]];
            }
 //[tf4 becomeFirstResponder];

        }else if(textField.tag == 4){//password
            
            NSString *qualRegex = @"[A-Z0-9a-z._%+-@!]{5,10}";
            NSPredicate *qualTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",qualRegex];
            BOOL qualValidate = [qualTest evaluateWithObject:textField.text];
            if (!qualValidate) {
                [ textField setTextColor:[UIColor redColor]];
                textField.text = @"Enter 5 to 10 characters";
           
            }
            else{
                [textField setTextColor:[UIColor blueColor]];
                 }

             password = [NSString stringWithFormat:@"%@",textField.text];
//[tf5 becomeFirstResponder];
            
        }else if(textField.tag == 5){
            if (![textField.text isEqualToString:password]) {
                [ textField setTextColor:[UIColor redColor]];
                textField.text = @"password not same";
                //[self.btn_submitTapped setEnabled:NO];
//[tf5 resignFirstResponder];
            }else{
                [textField setTextColor:[UIColor blueColor]];
            }

        }

//    }
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
        [textField setText:nil];

    UITableViewCell *cell1 = (UITableViewCell*) [[textField superview] superview];
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES  ;
}



#pragma mark- tableview delegate


/****************************/


- (IBAction)btn_submit:(id)sender {
    
    for (int i=1; i<=arrItem.count; i++){
        UITextField *tf = (UITextField*)[self.view viewWithTag:i];
        [arrItemValue addObject:tf.text];
    }

    NSLog(@"%@",arrItemValue);
    
//    for (int i=0; i<arrItem.count; i++) {
//        NSIndexPath *indexpath_transfer = [NSIndexPath indexPathForRow:i inSection:0];
//        TextFieldTableViewCell *cell_transfer = [_customer_reg_tbl cellForRowAtIndexPath:indexpath_transfer];
//        arrItemValue[i]=cell_transfer.customer_textfield.text;
//    }
    
//    NSString* stringEmail = arrItemValue [1];
//    NSString* stringPass = arrItemValue [3];
//    NSString* stringPhoneNum = arrItemValue [2];

    
    
//    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//    NSURL *url = [NSURL URLWithString:@"http://rjtmobile.com/ansari/regtest.php?"];
//    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:url];
//    NSString *params = [NSString stringWithFormat:@"http://rjtmobile.com/ansari/regtest.php?username=%@&password=%@&mobile=%@",stringEmail,stringPass,stringPhoneNum];
//    [urlrequest setHTTPMethod:@"POST"];
//    [urlrequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSLog(@"%@",params);
//    
//    
//    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse* )response;
//        NSLog(@"response state code%ld",(long)[httpResponse statusCode]);
//
//    }];
//    
//    
//    
//    [dataTask resume];
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:[self getURLRequestForRegistration] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString* responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"response string from server:%@",responseString);
                if ([responseString isEqualToString:@"success"]) {
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Register successfully" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];

                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];

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

    
    
   // [self.navigationController popToRootViewControllerAnimated:YES];
    

    
    
    
    
}


-(NSURLRequest*)getURLRequestForRegistration{
//    NSString* stringEmail = arrItemValue [1];
//    NSString* stringPass = arrItemValue [3];
//    NSString* stringPhoneNum = arrItemValue [2];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://rjtmobile.com/ansari/regtest.php?username=%@&password=%@&mobile=%@",arrItemValue [1],arrItemValue [3],arrItemValue [2]]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:180];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];//??????? setValue????
    return urlRequest   ;
}






@end
