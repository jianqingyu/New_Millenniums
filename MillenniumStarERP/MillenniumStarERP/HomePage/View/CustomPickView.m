//
//  CustomPickView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CustomPickView.h"

@interface CustomPickView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, weak)UILabel *titleLab;
@property (nonatomic, weak)UIPickerView *pickView;
@end
@implementation CustomPickView

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
        UIView *backV = [[UIView alloc]init];
        backV.backgroundColor = [UIColor whiteColor];
        [self addSubview:backV];
        [backV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.height.mas_equalTo(@256);
        }];
        
        UILabel *title = [[UILabel alloc]init];
        title.font = [UIFont systemFontOfSize:18];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"请选择类型";
        [backV addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backV).offset(0);
            make.centerX.mas_equalTo(backV.mas_centerX);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(@(SDevWidth*0.6));
        }];
        self.titleLab = title;
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backV addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backV).offset(10);
            make.top.equalTo(backV).offset(0);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(@80);
        }];
        
        UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
        [sure setTitle:@"确定" forState:UIControlStateNormal];
        [sure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sure addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        title.frame = CGRectMake(SDevWidth*0.8, 0, SDevWidth*0.2, 44);
        [backV addSubview:sure];
        [sure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backV).offset(-10);
            make.top.equalTo(backV).offset(0);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(@80);
        }];
        [self setPickerView:backV];
    }
    return self;
}

- (void)setPickerView:(UIView *)backV{
    UIPickerView *pickView = [[UIPickerView alloc]init];
    pickView.backgroundColor = DefaultColor;
    pickView.delegate = self;
    pickView.dataSource = self;
    [backV addSubview:pickView];
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backV).offset(0);
        make.bottom.equalTo(backV).offset(0);
        make.right.equalTo(backV).offset(0);
        make.height.mas_equalTo(@216);
    }];
    self.pickView = pickView;
}
//标题
- (void)setTitleStr:(NSString *)titleStr{
    if (titleStr) {
        _titleStr = titleStr;
        self.titleLab.text = [NSString stringWithFormat:@"请选择%@",_titleStr];
    }
}
//数据
- (void)setTypeList:(NSArray *)typeList{
    if (typeList.count>0) {
        _typeList = typeList;
        [self.pickView reloadComponent:0];
    }
}
//选中
- (void)setSelTitle:(NSString *)selTitle{
    if (selTitle) {
        _selTitle = selTitle;
        int idex = 0;
        for (int i=0; i<_typeList.count; i++) {
            NSDictionary *info = _typeList[i];
            if ([_selTitle isEqualToString:info[@"title"]]) {
                idex = i;
            }
        }
        [self.pickView selectRow:idex inComponent:0 animated:YES];
    }
}

// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
// 返回每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.typeList.count;
}
// 返回每行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *info = self.typeList[row];
    NSString *title = info[@"title"];
    if ([YQObjectBool boolForObject:info[@"price"]]) {
        title = [NSString stringWithFormat:@"%@  %@/g",title,info[@"price"]];
    }
    return title;
}

- (void)cancelBtnClick:(id)sender{
    DetailTypeInfo *info = [DetailTypeInfo new];
    info.title = @"";
    [self backWithInfo:info];
}

- (void)sureBtnClick:(id)sender{
    NSInteger row = [self.pickView selectedRowInComponent:0];
    NSDictionary *infoD = self.typeList[row];
    DetailTypeInfo *info = [DetailTypeInfo new];
    if (self.staue==1||self.staue==4) {
        info.id = [infoD[@"id"]intValue];
    }
    info.title = infoD[@"title"];
    [self backWithInfo:info];
}

- (void)backWithInfo:(DetailTypeInfo *)info{
    NSMutableDictionary *mud = @{}.mutableCopy;
    mud[self.section] = info;
    if (self.popBack) {
        self.popBack(self.staue,mud);
    }
}

@end
