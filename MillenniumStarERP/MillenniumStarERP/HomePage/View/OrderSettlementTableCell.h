//
//  OrderSettlementTableCell.h
//  MillenniumStarERP
//
//  Created by yjq on 17/3/6.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListNewInfo.h"
@interface OrderSettlementTableCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)OrderListNewInfo *listInfo;
@end
