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
    NSString * errorMsg;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)btn_submit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_submitTapped;

@end

@implementation CtmRegisterViewController

static bool nameFLAG=NO;
static bool emailFLAG=NO;
static bool mobileFLAG=NO;
static bool pwdFLAG=NO;
static bool confirmpwdFLAG=NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    errorMsg = @"";
    
    arrItem = [NSArray arrayWithObjects:@"Full Name",@"Email",@"Mobile NO.",@"Password",@"Confirm Password", nil];
    arrItemValue = [[NSMutableArray alloc]initWithCapacity:14];
    
    
    //----  hide the unused tableView cell  ----//
   self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //hide the separator line
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIBarButtonItem * btn_back = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = btn_back;

    [self setTitle:@"Customer Register"];
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
    
    if (indexPath.row==3 || indexPath.row ==4) {
        [cell.textfield setSecureTextEntry:YES];
    }
    
    return cell;
}


#pragma mark- textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
       NSString * password;
  
    //.... Validation  ...//
       if (textField.tag == 1) { // textField == tf1 full name
            NSString *nameRegex = @"[A-Za-z\\s]{5,20}";
            NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
            BOOL nameValidate = [nameTest evaluateWithObject: textField.text ];
            if (!nameValidate){
                [textField setTextColor:[UIColor redColor]];
                textField.text = @"Name invalid";
                nameFLAG = NO;
                 errorMsg = [errorMsg stringByAppendingString:@"Name is invalid.\n"];
            }
            else{
                [textField setTextColor:[UIColor blueColor]];
                nameFLAG = YES;
        }
 //[tf2 becomeFirstResponder];

        }else if(textField.tag == 2){ //Email
            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            BOOL emailValidate = [emailTest evaluateWithObject:textField.text];
            if (!emailValidate){
                [textField setTextColor:[UIColor redColor]];
                textField.text = @"Please enter corrent Email";
                emailFLAG =NO;
                errorMsg = [errorMsg stringByAppendingString:@"Email is invalid.\n"];
            }
            else{
                [textField setTextColor:[UIColor blueColor]];
                emailFLAG=YES;
            }
 //[tf3 becomeFirstResponder];

        }else if(textField.tag == 3){ //Telephone
            
            NSString *phoneRegex = @"[0-9]{10}";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
            BOOL phoneValidate = [phoneTest evaluateWithObject:textField.text];
            if (!phoneValidate) {
               [ textField setTextColor:[UIColor redColor]];
                textField.text = @"TelNO. is 10 digits";
                mobileFLAG=NO;
            errorMsg = [errorMsg stringByAppendingString:@"TelNO. is 10 digits.\n"];
            }
            else{
                 [textField setTextColor:[UIColor blueColor]];
                mobileFLAG=YES;
            }
 //[tf4 becomeFirstResponder];

        }else if(textField.tag == 4){//password
            
            NSString *qualRegex = @"[A-Z0-9a-z._%+-@!]{5,10}";
            NSPredicate *qualTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",qualRegex];
            BOOL qualValidate = [qualTest evaluateWithObject:textField.text];
            if (!qualValidate) {
                [ textField setTextColor:[UIColor redColor]];
                textField.text = @"Enter 5 to 10 characters";
                pwdFLAG =NO;
                errorMsg = [errorMsg stringByAppendingString:@"Password should 5 to 10 characters.\n"];

            }
            else{
                [textField setTextColor:[UIColor blueColor]];
                pwdFLAG = YES;
                 }

             password = [NSString stringWithFormat:@"%@",textField.text];
//[tf5 becomeFirstResponder];
            
        }else if(textField.tag == 5){ // comfirm password
            if (![textField.text isEqualToString:password]) {
                [ textField setTextColor:[UIColor redColor]];
                textField.text = @"password not same";
                confirmpwdFLAG = NO;
                errorMsg = [errorMsg stringByAppendingString:@"Password not same.\n"];
//[tf5 resignFirstResponder];
            }else{
                [textField setTextColor:[UIColor blueColor]];
                confirmpwdFLAG = YES;
            }

        }

//    }
    
    
}

#pragma mark- tableview delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [textField setText:nil]; //reset the textfield

    //------ scroll the cells to top ---------//
    UITableViewCell *cell1 = (UITableViewCell*) [[textField superview] superview];
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    NSLog(@"-----Method called");
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES  ;
}

#pragma mark - submit

- (IBAction)btn_submit:(id)sender {
    
    //---store the info to the array---//
    for (int i=1; i<=arrItem.count; i++){
        UITextField *tf = (UITextField*)[self.view viewWithTag:i];
        [arrItemValue addObject:tf.text];
    }

    NSLog(@"%@",arrItemValue);
    
    //---excute the URLRequest---//
    
if (nameFLAG&&emailFLAG&&mobileFLAG&&pwdFLAG&&confirmpwdFLAG){
    [[[NSURLSession sharedSession]dataTaskWithRequest:[self getURLRequestForRegistration] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString* responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"response string from server:%@",responseString);
                if ([responseString isEqualToString:@"success"]) { //register success action
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Register successfully" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        //Pop to root viewcontroller
                        [self.navigationController popToRootViewControllerAnimated:YES];

                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];

                }else {  // register failure action
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
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];

    
}
    
    
    
    
}

//---- prepare the URL Request ------//
-(NSURLRequest*)getURLRequestForRegistration{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://rjtmobile.com/ansari/regtest.php?username=%@&password=%@&mobile=%@",arrItemValue [1],arrItemValue [3],arrItemValue [2]]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:180];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];//??????? setValue????
    return urlRequest   ;
}



-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
