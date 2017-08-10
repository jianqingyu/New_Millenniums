//
//  ScreeningTopView.h
//  MillenniumStarERP
//
//  Created by yjq on 17/6/16.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ScreenTBack)(NSArray *arr);
@interface ScreeningTopView : UIView
@property (nonatomic,  copy) NSArray*goods;
@property (nonatomic,  copy) ScreenTBack back;
@end
