//
//  ViewController.m
//  GetMyCab-Zailiang
//
//  Created by Zailiang Yu on 2/1/16.
//  Copyright © 2016 Zailiang Yu. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"

@interface ViewController ()

- (IBAction)btn_login:(id)sender;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_login:(id)sender {
    
    LoginViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    if ([sender tag] == 0) {
        [vc setStr:@"Customer LogIn"];
    }else if ([sender tag]== 1){
        [vc setStr:@"Driver LogIn"];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
@end
