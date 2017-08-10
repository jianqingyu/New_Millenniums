//
//  CustomDriWordCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/8/8.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDriWordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *wordFie;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
+ (id)cellWithTableView:(UITableView *)tableView;
@end
