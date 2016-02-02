//
//  ImagePickerTableViewCell.h
//  GetMyCab-Zailiang
//
//  Created by Zailiang Yu on 2/2/16.
//  Copyright © 2016 Zailiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;

- (IBAction)btn_image:(id)sender;

@end
