//
//  LoginViewController.m
//  GetMyCab-Zailiang
//
//  Created by Zailiang Yu on 2/1/16.
//  Copyright © 2016 Zailiang Yu. All rights reserved.
//

#import "LoginViewController.h"
#import "CtmRegisterViewController.h"
#import "DriverRegisterViewController.h"
#import "CtmLogInViewController.h"
#import "DriverHomeViewController.h"

@interface LoginViewController ()
- (IBAction)btn_signup:(id)sender;
- (IBAction)btn_login:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController

@synthesize str,userName,password;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:self.str];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_signup:(id)sender {
    if ([str isEqualToString:@"Customer LogIn"]) {
        CtmRegisterViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"CtmRegisterViewController" ];
        [self.navigationController pushViewController:vc1 animated:YES];
        
        
    }else if([str isEqualToString:@"Driver LogIn"]){
        DriverRegisterViewController * vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverRegisterViewController"];
        [self.navigationController pushViewController:vc2 animated:YES];
    }
}

- (IBAction)btn_login:(id)sender {
    
    NSURL * url;
    bool isCostomer = NO;
    bool isDriver = NO;
    
    if ([str isEqualToString:@"Customer LogIn"]){
     url = [NSURL URLWithString:[NSString stringWithFormat:@"http://rjtmobile.com/ansari/dbConnect.php?mobile=%@&password=%@",userName.text,password.text]];
        isCostomer = YES;
        
    }else if([str isEqualToString:@"Driver LogIn"]){
      url = [NSURL URLWithString:[NSString stringWithFormat:@"http://rjtmobile.com/ansari/driver_login.php?mobile=%@&password=%@",userName.text,password.text]];
        isDriver = YES;
    }
    
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:[self getURLRequestForUser:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString* responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"response string from server:%@",responseString);
                
                
               if([responseString isEqualToString:@"success"]&& isCostomer){
                    
                    CtmLogInViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CtmLogInViewController"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else if([responseString isEqualToString:@"success"]&& isDriver){
                    DriverHomeViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverHomeViewController"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else  {
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:responseString preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            });
        }
    } ]resume ];
    
   
    
    
}


-(NSURLRequest*)getURLRequestForUser:(NSURL*)url{
//    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://rjtmobile.com/ansari/dbConnect.php?username=%@&password=%@",userName.text,password.text]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:180];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];//??????? setValue????
    return urlRequest   ;
}



#pragma mark textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField  {
    [textField resignFirstResponder];
}


@end
