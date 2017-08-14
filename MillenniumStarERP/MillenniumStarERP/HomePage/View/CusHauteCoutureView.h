//
//  CusHauteCoutureView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/8/8.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressInfo.h"
#import "CustomerInfo.h"
#import "ProductInfo.h"
#import "DetailTypeInfo.h"
#import "NakedDriSeaListInfo.h"
typedef void (^CusHauBack)(int staue,BOOL isYes);
@interface CusHauteCoutureView : UIView
@property (nonatomic,  copy)CusHauBack driBack;
@property (nonatomic,strong)AddressInfo *addInfo;
@property (nonatomic,strong)ProductInfo *imgInfo;
@property (nonatomic,strong)DetailTypeInfo *colorInfo;
@property (nonatomic,strong)NakedDriSeaListInfo *info;
@property (nonatomic,strong)CustomerInfo *cusInfo;
@end
