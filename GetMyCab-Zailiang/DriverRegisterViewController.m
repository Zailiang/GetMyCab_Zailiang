//
//  DriverRegisterViewController.m
//  GetMyCab-Zailiang
//
//  Created by Zailiang Yu on 2/1/16.
//  Copyright © 2016 Zailiang Yu. All rights reserved.
//

#import "DriverRegisterViewController.h"
#import "textfieldTableViewCell2.h"
#import "DatePickerTableViewCell.h"
#import "ActionSheetTableViewCell.h"
#import "ImagePickerTableViewCell.h"
#import "MapKitTableViewCell.h"

@interface DriverRegisterViewController (){
    
    NSArray * arrItem;
    NSString *selectedDate;
    NSData * imgData;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btn_submit:(id)sender;


- (IBAction)btn_imgPicker:(id)sender;


@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)datePickerTapped:(id)sender;

@end

@implementation DriverRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrItem = [NSArray arrayWithObjects:@"Full Name",@"Email",@"Mobile No.",@"Password",@"Confirm Password",@"Vehicle No.",@"License No.",@"Emergency No.",@"DOB",@"Edu-Quali",@"Blood Type",@"Photo",@"City", nil];
    
    [self.datePicker setEnabled:NO];
    [self.datePicker setHidden:YES];
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
    
    if (indexPath.row<8) {
        textfieldTableViewCell2 * cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        [cell.label setText:arrItem[indexPath.row]];
        [cell.textfield setTag:indexPath.row];
        return cell;
    }else if (indexPath.row==8){
        DatePickerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        [cell.label setText:arrItem[indexPath.row]];
        [cell.textfield setTag:indexPath.row];
        return cell;
    }else if (indexPath.row==9 || indexPath.row==10 ){
        ActionSheetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        [cell.label setText:arrItem[indexPath.row]];
        [cell.textfield setTag:indexPath.row];
        return cell;
    }else if(indexPath.row == 11){
        ImagePickerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        [cell.label setText:arrItem[indexPath.row]];
        //////////////////////////////////////////
        return cell;
    }else {
        MapKitTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        [cell.label setText:arrItem[indexPath.row]];
        //////////[cell.textfield setTag:indexPath.row];
        return cell;
        
    }
    
}

#pragma mark textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 8) {
        NSLog(@"DatePicker Begin");
        [self.datePicker setEnabled:YES];
        [self.datePicker setHidden:NO];
        
    }else if (textField.tag == 9){
       // [self presentViewController:alertEQ animated:YES completion:nil];
        [self presentAlertEQ];
        
    }else if (textField.tag == 10){
        [self presentAlertBloodType];
    }
    
    else if (textField.tag == 12){
       // City , Mapkit
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 8) {
        NSLog(@"DatePicker End");
        [_datePicker setEnabled:NO];
        [_datePicker setHidden:YES];
        textField.text=selectedDate;
    }else if (textField.tag == 9 ||textField.tag == 10){
        NSLog(@"ActionSheet End");
    }
    
    else if (textField.tag == 12){
        //city......
    }
   
}

#pragma mark AlertSheet method
-(void)presentAlertEQ{
    UIAlertController *alertEQ;
    alertEQ=[UIAlertController alertControllerWithTitle:@"Make your choice" message:@"Pick your Education Qualification" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction * actionhigh=[UIAlertAction actionWithTitle:@"High school" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:9];
        textfield.text=@"High school";
    }];
    UIAlertAction * actionbachelor=[UIAlertAction actionWithTitle:@"Bachelor" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:9];
        textfield.text=@"Bachelor";
    }];
    UIAlertAction * actionmaster=[UIAlertAction actionWithTitle:@"Master" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:9];
        textfield.text=@"Master";
    }];
    UIAlertAction * actionDoctor=[UIAlertAction actionWithTitle:@"PHD" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:9];
        textfield.text=@"PHD";
    }];
        UIAlertAction * actionOther=[UIAlertAction actionWithTitle:@"Other" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:9];
        textfield.text=@"Other";
    }];
    
    [alertEQ addAction:actionhigh];
    [alertEQ addAction:actionbachelor];
    [alertEQ addAction:actionmaster];
    [alertEQ addAction:actionDoctor];
    [alertEQ addAction:actionOther];
    
    [self presentViewController:alertEQ animated:YES completion:nil];
}


-(void)presentAlertBloodType{
     UIAlertController *alertBT;
    alertBT=[UIAlertController alertControllerWithTitle:@"Make your choice" message:@"Pick your Blood Group" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * actionA=[UIAlertAction actionWithTitle:@"A" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:10];
        textfield.text=@"A";
    }];
    UIAlertAction * actionB=[UIAlertAction actionWithTitle:@"B" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:10];
        textfield.text=@"B";
    }];
    UIAlertAction * actionAB=[UIAlertAction actionWithTitle:@"AB" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:10];
        textfield.text=@"AB";
    }];
    UIAlertAction * actionO=[UIAlertAction actionWithTitle:@"O" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:10];
        textfield.text=@"O";
    }];
    UIAlertAction * actionRH=[UIAlertAction actionWithTitle:@"RH" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield=(UITextField*)[self.view viewWithTag:10];
        textfield.text=@"RH";
    }];
    [alertBT addAction:actionA];
    [alertBT addAction:actionB];
    [alertBT addAction:actionAB];
    [alertBT addAction:actionO];
    [alertBT addAction:actionRH];

    [self presentViewController:alertBT animated:YES completion:nil];
}


#pragma mark button Actions
- (IBAction)btn_submit:(id)sender {
}

- (IBAction)btn_imgPicker:(id)sender {
    
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
    ImagePickerTableViewCell * cell ;////////////
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    [cell.imgview setImage:img];
    //UILabel *label=[self.view viewWithTag:12];
    //[label setTextColor:[UIColor blackColor]];
    [picker dismissViewControllerAnimated:YES completion:nil];
    imgData=UIImagePNGRepresentation(img);
}


- (IBAction)datePickerTapped:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    selectedDate = formatedDate;

}
@end
