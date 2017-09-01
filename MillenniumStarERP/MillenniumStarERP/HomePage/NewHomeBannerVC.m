//
//  NewHomeBannerVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/26.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewHomeBannerVC.h"
#import "CustomTopBtn.h"
#import "ProductListVC.h"
#import "EditUserInfoVC.h"
#import "CustomerInfo.h"
#import "HYBLoopScrollView.h"
#import "CusHauteCoutureView.h"
#import "NakedDriLibViewController.h"
@interface NewHomeBannerVC ()<UINavigationControllerDelegate>
@property (nonatomic,  weak)UIView *baView;
@property (nonatomic,  weak)UIWindow *keyWin;
@property (nonatomic,strong)NSArray *photos;
@property (nonatomic,strong)NSArray *bPhotos;
@property (nonatomic,  copy)NSString *openUrl;
@property (nonatomic,  weak)UIView *proDriView;
@property (nonatomic,  copy)NSDictionary *versionDic;
@property (nonatomic,  weak)HYBLoopScrollView *loopView;
@property (nonatomic,strong)CusHauteCoutureView *cusView;
@end

@implementation NewHomeBannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewHomeData];
    self.openUrl = @"https://itunes.apple.com/cn/app/千禧之星珠宝/id1227342902?mt=8";
//    self.openUrl = @"https://itunes.apple.com/cn/app/千禧之星珠宝2/id1244977034?mt=8";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatBottomBtn];
    [self loadNSNotification];
    [self loadAddressDataInfo];
}
//添加通知
- (void)loadNSNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:)
             name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)orientChange:(NSNotification *)notification{
    BOOL isDev = SDevWidth>SDevHeight;
    if (isDev) {
        [self setLoopScrollView:self.photos];
    }else{
        [self setLoopScrollView:self.bPhotos];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
//    [self resetWindow];
    [self loadNewVersion];
}
//加载默认地址
- (void)loadAddressDataInfo{
    NSString *url = [NSString stringWithFormat:@"%@InitDataForQxzx",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            StorageDataTool *data = [StorageDataTool shared];
            if ([YQObjectBool boolForObject:response.data[@"address"]]){
                data.addInfo = [AddressInfo objectWithKeyValues:response.data[@"address"]];
            }
            if ([YQObjectBool boolForObject:response.data[@"DefaultCustomer"]]){
                data.cusInfo = [CustomerInfo objectWithKeyValues:response.data[@"DefaultCustomer"]];
            }
        }
    } requestURL:url params:params];
}
//重置视图
- (void)resetWindow{
    if (self.keyWin) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.cusView removeFromSuperview];
            self.keyWin.windowLevel = 200;
            self.keyWin.hidden = YES;
            self.keyWin = nil;
            self.cusView = nil;
        }];
    }
}

#pragma mark -- 检查新版本
- (void)loadNewVersion{
    NSString *url = [NSString stringWithFormat:@"%@currentVersion",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"device"] = @"ios";
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            self.versionDic = response.data;
            [self loadAlertView];
        }
    } requestURL:url params:params];
}

- (void)loadAlertView{
    NSString *CurrentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if (![CurrentVersion isEqualToString:self.versionDic[@"version"]]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                        message:self.versionDic[@"message"] delegate:self
                           cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *str = [self.openUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:str]];
    application = nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)loadNewHomeData{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@IndexPageForQxzx",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"horizontal"]]) {
                self.photos = response.data[@"horizontal"];
            }
            if ([YQObjectBool boolForObject:response.data[@"vertical"]]) {
                self.bPhotos = response.data[@"vertical"];
            }
            BOOL isDev = SDevWidth>SDevHeight;
            if (isDev) {
                [self setLoopScrollView:self.photos];
            }else{
                [self setLoopScrollView:self.bPhotos];
            }
        }
    } requestURL:url params:params];
}

- (void)setLoopScrollView:(NSArray *)arr{
    if (self.loopView) {
        [self.loopView removeFromSuperview];
        self.loopView = nil;
    }
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:
                               CGRectMake(0, 0, SDevWidth, SDevHeight) imageUrls:arr];
    loop.timeInterval = 6.0;
    loop.didSelectItemBlock = ^(NSInteger atIndex,HYBLoadImageView  *sender){
        
    };
    loop.alignment = kPageControlAlignRight;
    [self.view addSubview:loop];
    [self.view sendSubviewToBack:loop];
    self.loopView = loop;
}

- (void)creatBottomBtn{
    CGFloat width = MIN(SDevWidth,SDevHeight)*0.7;
    UIView *bottomV = [UIView new];
    [self.view addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(width, 80));
    }];
    CGFloat mar = (width-4*60)/3;
    NSArray *arr = @[@"p_11-1",@"p_03-1",@"p_06-1",@"p_08-1"];
    NSArray *arrS = @[@"快速定制",@"产品",@"裸钻库",@"个人中心"];
    for (int i=0; i<arr.count; i++) {
        CustomTopBtn *right = [CustomTopBtn creatCustomView];
        right.bBtn.tag = i;
        [right.sBtn setBackgroundImage:[UIImage imageNamed:arr[i]] forState:
                                   UIControlStateNormal];
        right.titleLab.text = arrS[i];
        [right.bBtn addTarget:self action:@selector(openClick:)
                                  forControlEvents:UIControlEventTouchUpInside];
        right.frame = CGRectMake(i*(60+mar), 0, 60, 80);
        [bottomV addSubview:right];
    }
    [self creatCustomDriView];
}

- (void)creatCustomDriView{
    UIView *backView = [UIView new];
    backView.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
    backView.hidden = YES;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.baView = backView;
    
    CGFloat btnWid = MIN(200, SDevWidth*0.667);
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 5;
    [btn1 setBackgroundImage:[UIImage imageNamed:@"jt_05"] forState:
     UIControlStateNormal];
    [btn1 addTarget:self action:@selector(customClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baView addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.baView.mas_centerX);
        make.bottom.equalTo(self.baView).with.offset(-100);
        make.size.mas_equalTo(CGSizeMake(btnWid, btnWid*0.61));
    }];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 6;
    [btn2 setBackgroundImage:[UIImage imageNamed:@"jt_03"] forState:
     UIControlStateNormal];
    [btn2 addTarget:self action:@selector(customClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baView addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.baView.mas_centerX);
        make.bottom.equalTo(btn1.mas_top).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(btnWid, btnWid*0.61));
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.baView.hidden==NO) {
        self.baView.hidden = YES;
    }
}

- (void)customClick:(UIView *)btn{
    if ([[AccountTool account].isNorm intValue]==1) {
        [MBProgressHUD showSuccess:@"高级定制不能定制钻石"];
        return;
    }
    if(btn.tag==5){
        ProductListVC *list = [ProductListVC new];
        list.isCus = YES;
        [self.navigationController pushViewController:list animated:YES];
    }else if(btn.tag==6){
        NakedDriLibViewController *list = [NakedDriLibViewController new];
        list.isCus = YES;
        [self.navigationController pushViewController:list animated:YES];
    }
    [self openWindowCusHuateView];
}

- (void)openClick:(UIView *)btn{
    if (btn.tag==0) {
        if ([[AccountTool account].isNorm intValue]==1) {
            [MBProgressHUD showSuccess:@"高级定制不能定制"];
            return;
        }
        if ([[AccountTool account].isNoShow intValue]==1||
            [[AccountTool account].isNoDriShow intValue]==1) {
            [MBProgressHUD showSuccess:@"不显示价格不能定制"];
            return;
        }
        if (self.cusView) {
            [self resetWindow];
        }else{
            [self openWindowCusHuateView];
        }
    }else if(btn.tag==1){
        [self resetWindow];
        ProductListVC *list = [ProductListVC new];
        [self.navigationController pushViewController:list animated:YES];
    }else if(btn.tag==2){
        [self resetWindow];
        NakedDriLibViewController *list = [NakedDriLibViewController new];
        [self.navigationController pushViewController:list animated:YES];
    }else{
        [self resetWindow];
        EditUserInfoVC *list = [EditUserInfoVC new];
        [self.navigationController pushViewController:list animated:YES];
    }
}

- (void)openWindowCusHuateView{
    CGFloat wid = MIN(SDevWidth, SDevHeight);
    CGFloat height = 320;
    if (wid>320) {
        height = 340;
    }
    if (!IsPhone) {
        height = 400;
    }
    if (self.cusView) {
        return;
    }
    CusHauteCoutureView *aView = [[CusHauteCoutureView alloc] initWithFrame:CGRectZero];
    aView.driBack = ^(int staue,BOOL isYes){
        if (staue==0) {
            if (isYes) {
                [UIView animateWithDuration:0.5 animations:^{
                    [self.cusView mas_updateConstraints:^(MASConstraintMaker *make) {
                          make.width.mas_equalTo(@22);
                    }];
                    [self.cusView layoutIfNeeded];//强制绘制
                }];
            }else{
                [UIView animateWithDuration:0.5 animations:^{
                    [self.cusView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(height-30);
                    }];
                    [self.cusView layoutIfNeeded];//强制绘制
                }];
            }
        }else{
            [self resetWindow];
        }
    };
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.frame = CGRectMake(0, 0, SDevWidth, SDevHeight);
    window.backgroundColor = [UIColor clearColor];
    // 添加到窗口
    [window addSubview:aView];
    [UIView animateWithDuration:0.5 animations:^{
        [aView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(window).offset(0);
            make.centerY.mas_equalTo(window.mas_centerY);
            make.width.mas_equalTo(height-30);
            make.height.mas_equalTo(height);
        }];
        [aView layoutIfNeeded];//强制绘制
    }];
    self.cusView = aView;
    self.keyWin = window;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
