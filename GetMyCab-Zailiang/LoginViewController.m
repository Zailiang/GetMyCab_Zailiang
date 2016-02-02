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
@interface LoginViewController ()
- (IBAction)btn_signup:(id)sender;

@end

@implementation LoginViewController

@synthesize str;

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
@end
