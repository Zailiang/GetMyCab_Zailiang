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
    arrItemValue = [[NSMutableArray alloc]init];
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
    UITextField* tf1 = (UITextField*)[self.view viewWithTag:1];
    UITextField* tf2 = (UITextField*)[self.view viewWithTag:2];
    UITextField* tf3 = (UITextField*)[self.view viewWithTag:3];
    UITextField* tf4 = (UITextField*)[self.view viewWithTag:4];
    UITextField* tf5 = (UITextField*)[self.view viewWithTag:5];

        if (textField == tf1) { // full name
            NSString *nameRegex = @"[A-Za-z\\s]{5,20}";
            NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
            BOOL nameValidate = [nameTest evaluateWithObject: tf1.text ];
            if (!nameValidate){
                [tf1 setTextColor:[UIColor redColor]];
                tf1.text = @"Name invalid";
            }
            else{
                [tf1 setTextColor:[UIColor blueColor]];
        }
 //[tf2 becomeFirstResponder];

        }else if(textField == tf2){ //Email
            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            BOOL emailValidate = [emailTest evaluateWithObject:tf2.text];
            if (!emailValidate){
                [tf2 setTextColor:[UIColor redColor]];
                tf2.text = @"Email invalid";
            }
            else{
                [tf2 setTextColor:[UIColor blueColor]];
            }
 //[tf3 becomeFirstResponder];

        }else if(textField == tf3){ //Telephone
            
            NSString *phoneRegex = @"[0-9]{10,11}";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
            BOOL phoneValidate = [phoneTest evaluateWithObject:tf3.text];
            if (!phoneValidate) {
               [ tf3 setTextColor:[UIColor redColor]];
                tf3.text = @"Phone NO. invalid";
            }
            else{
                 [tf3 setTextColor:[UIColor blueColor]];
            }
 //[tf4 becomeFirstResponder];

        }else if(textField == tf4){//password
            
            NSString *qualRegex = @"[A-Z0-9a-z._%+-@!]{5,10}";
            NSPredicate *qualTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",qualRegex];
            BOOL qualValidate = [qualTest evaluateWithObject:tf4.text];
            if (!qualValidate) {
                [ tf4 setTextColor:[UIColor redColor]];
                tf4.text = @"5 to 10 password";
           
            }
            else{
                [tf4 setTextColor:[UIColor blueColor]];
                [tf4 setTextColor:[UIColor blueColor]];
                 }

             password = [NSString stringWithFormat:@"%@",tf4.text];
//[tf5 becomeFirstResponder];
            
        }else if(textField == tf5){
            if (![tf5.text isEqualToString:password]) {
                [ tf5 setTextColor:[UIColor redColor]];
                tf5.text = @"password not same";
//[tf5 resignFirstResponder];
            }
        }

//    }
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{

    UITextField* tf1 = (UITextField*)[self.view viewWithTag:1];
    UITextField* tf2 = (UITextField*)[self.view viewWithTag:2];
    UITextField* tf3 = (UITextField*)[self.view viewWithTag:3];
    UITextField* tf4 = (UITextField*)[self.view viewWithTag:4];
    UITextField* tf5 = (UITextField*)[self.view viewWithTag:5];
    
    if (textField == tf1) { // full name
        [tf1 setText:nil];
        
    }else if(textField == tf2){ //Email
         [tf2 setText:nil];
            }else if(textField == tf3){ //Telephone
        
         [tf3 setText:nil];
            }else if(textField == tf4){//password
        
        [tf4 setText:nil];
        
    }else if(textField == tf5){
        [tf5 setText:nil];
        
            }
    
    
    
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
}








@end
