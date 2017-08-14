//
//  CusHauteCoutureView.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/8.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CusHauteCoutureView.h"
#import "ProductListVC.h"
#import "StrWithIntTool.h"
#import "ConfirmOrderVC.h"
#import "ProductionOrderVC.h"
#import "ShowLoginViewTool.h"
#import "PayViewController.h"
#import "ChangeUserInfoVC.h"
#import "NakedDriLibViewController.h"
@interface CusHauteCoutureView()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *hands;
@property (weak, nonatomic) IBOutlet UILabel *staueLab;
@property (weak, nonatomic) IBOutlet UIButton *proBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIButton *driBtn;
@property (weak, nonatomic) IBOutlet UIButton *messBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *cusLab;
@property (weak, nonatomic) IBOutlet UIButton *conBtn;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2H;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@end
@implementation CusHauteCoutureView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"CusHauteCoutureView" owner:nil options:nil][0];
        [self createBase];
    }
    return self;
}

- (void)createBase{
    self.line1H.constant = 0.5;
    self.line2H.constant = 0.5;
    self.infoView.backgroundColor = CUSTOM_COLOR_ALPHA(8, 11, 18, 0.7);
    self.myView.backgroundColor = CUSTOM_COLOR_ALPHA(8, 11, 18, 0.7);
    [self.image setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    [self.proBtn setLayerWithW:3 andColor:[UIColor whiteColor] andBackW:0.5];
    [self.driBtn setLayerWithW:3 andColor:[UIColor whiteColor] andBackW:0.5];
    [self.messBtn setLayerWithW:3 andColor:[UIColor whiteColor] andBackW:0.5];
    [self.conBtn setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    [self.infoView setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    [self.myView setLayerWithW:3 andColor:BordColor andBackW:0.0001];
    //        右滑手势
    UISwipeGestureRecognizer * recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self addGestureRecognizer:recognizer];
    //        左滑手势
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self addGestureRecognizer:recognizer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickConfirm:)
                                                name:NotificationClickName object:nil];
    StorageDataTool *data = [StorageDataTool shared];
    if (data.BaseInfo) {
        self.imgInfo = data.BaseInfo;
    }
    if (data.BaseSeaInfo) {
        self.info = data.BaseSeaInfo;
    }
    if (data.colorInfo) {
        self.colorInfo = data.colorInfo;
    }
    if (data.cusInfo) {
        self.cusInfo = data.cusInfo;
    }
    if (data.addInfo) {
        self.addInfo = data.addInfo;
    }
}

- (void)clickConfirm:(NSNotification *)notification{
    [self openConfirmOrder];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self viewDidDismiss];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self viewDidShow];
    }
}

- (void)setImgInfo:(ProductInfo *)imgInfo{
    if (imgInfo) {
        _imgInfo = imgInfo;
        [self.image sd_setImageWithURL:[NSURL URLWithString:_imgInfo.pic] placeholderImage:DefaultImage];
        self.hands.text = _imgInfo.title;
        float price = _imgInfo.price;
        if (_info) {
            price = price+[_info.Price floatValue];
        }
        self.priceLab.text = [NSString stringWithFormat:@"合计:%0.0f元",price];
        if (_info) {
            if (_cusInfo) {
                [MBProgressHUD showSuccess:@"已选择完毕,请点确认定制"];
            }else{
                [MBProgressHUD showSuccess:@"请继续选择信息"];
            }
        }else{
            [MBProgressHUD showSuccess:@"请继续挑选裸钻"];
        }
    }
}

- (void)setInfo:(NakedDriSeaListInfo *)info{
    if (info) {
        _info = info;
        [self viewDidShow];
        NSArray *infoArr = @[@"钻石",_info.Weight,_info.Shape,_info.Color,_info.Purity,@"1粒",_info.CertCode];
        NSArray *titleArr = @[@"类型",@"规格",@"形状",@"颜色",@"净度",@"数量",@"证书编号"];
        NSMutableArray *mutA = [NSMutableArray new];
        for (int i=0; i<titleArr.count; i++) {
                NSString *strT = infoArr[i];
                if (strT.length>0) {
                    NSString *str = [NSString stringWithFormat:@"%@:%@",titleArr[i],strT];
                    [mutA addObject:str];
            }
        }
        self.infoLab.text = [StrWithIntTool strWithArr:mutA With:@","];
        float price = [_info.Price floatValue];
        if (_imgInfo) {
            price = price+_imgInfo.price;
        }
        self.priceLab.text = [NSString stringWithFormat:@"合计:%0.0f元",price];
        if (_imgInfo) {
            if (_cusInfo) {
                [MBProgressHUD showSuccess:@"已选择完毕,请点确认定制"];
            }else{
                [MBProgressHUD showSuccess:@"请继续选择信息"];
            }
        }else{
            [MBProgressHUD showSuccess:@"请继续挑选戒托"];
        }
    }
}

- (void)viewDidShow{
    if (!self.sureBtn.selected) {
        return;
    }
    self.sureBtn.selected = NO;
    if (self.driBack) {
        self.driBack(0,NO);
    }
}

- (void)viewDidDismiss{
    if (self.sureBtn.selected) {
        return;
    }
    self.sureBtn.selected = YES;
    if (self.driBack) {
        self.driBack(0,YES);
    }
}

- (void)setAddInfo:(AddressInfo *)addInfo{
    if (addInfo) {
        _addInfo = addInfo;
        self.addressLab.text = [NSString stringWithFormat:@"地址:%@ %@ %@",_addInfo.name,_addInfo.phone,_addInfo.addr];
    }
}

- (void)setCusInfo:(CustomerInfo *)cusInfo{
    if (cusInfo) {
        _cusInfo = cusInfo;
        self.cusLab.text = [NSString stringWithFormat:@"客户:%@",_cusInfo.customerName];
    }
}

- (void)setColorInfo:(DetailTypeInfo *)colorInfo{
    if (colorInfo) {
        _colorInfo = colorInfo;
        [self viewDidShow];
        self.staueLab.text = [NSString stringWithFormat:@"质量等级:精品 成色:%@",_colorInfo.title];
    }
}

- (IBAction)openPuct:(id)sender {
    [self viewDidDismiss];
    UIViewController *cur = [ShowLoginViewTool getCurrentVC];
    if ([cur isKindOfClass:[ProductListVC class]]) {
        return;
    }
    ProductListVC *list;
    for (UIViewController *vc in cur.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ProductListVC class]]) {
            list = (ProductListVC *)vc;
        }
    }
    if (list) {
        list.isCus = YES;
        [cur.navigationController popToViewController:list animated:YES];
    }else{
        list = [ProductListVC new];
        list.isCus = YES;
        [cur.navigationController pushViewController:list animated:YES];
    }
}

- (IBAction)openDriClick:(id)sender {
    [self viewDidDismiss];
    UIViewController *cur = [ShowLoginViewTool getCurrentVC];
    if ([cur isKindOfClass:[NakedDriLibViewController class]]) {
        return;
    }
    NakedDriLibViewController *driVc;
    for (UIViewController *vc in cur.navigationController.viewControllers) {
        if ([vc isKindOfClass:[NakedDriLibViewController class]]) {
            driVc = (NakedDriLibViewController *)vc;
        }
    }
    BOOL isPro = self.imgInfo?YES:NO;
    if (driVc) {
        driVc.isCus = YES;
        driVc.isPro = isPro;
        [cur.navigationController popToViewController:driVc animated:YES];
    }else{
        driVc = [NakedDriLibViewController new];
        driVc.isCus = YES;
        driVc.isPro = isPro;
        [cur.navigationController pushViewController:driVc animated:YES];
    }
}

- (IBAction)chooseMessage:(id)sender {
    [self viewDidDismiss];
    UIViewController *cur = [ShowLoginViewTool getCurrentVC];
    if ([cur isKindOfClass:[ChangeUserInfoVC class]]) {
        return;
    }
    ChangeUserInfoVC *list = list = [ChangeUserInfoVC new];
    list.back = ^(NSDictionary *dic){
        self.addInfo = dic[@"add"];
        self.cusInfo = dic[@"cus"];
        [self viewDidShow];
    };
    [cur.navigationController pushViewController:list animated:YES];
}

- (IBAction)showClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.driBack) {
        self.driBack(0,sender.selected);
    }
}

- (IBAction)confirmClick:(id)sender {
    [self openConfirmOrder];
}

- (void)openConfirmOrder{
    StorageDataTool *data = [StorageDataTool shared];
    if (!data.BaseInfo) {
        [MBProgressHUD showError:@"请挑选戒托"];
        return;
    }
    if (!data.colorInfo) {
        [MBProgressHUD showError:@"请选择成色"];
        return;
    }
    if (!data.BaseSeaInfo) {
        [MBProgressHUD showError:@"请挑选钻石"];
        return;
    }
    if (!data.cusInfo) {
        [MBProgressHUD showError:@"请选择客户"];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@OrderCurrentSubmitQuickNowDo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"productId"] = @(data.BaseInfo.id);
    params[@"number"] = @1;
    params[@"modelQualityId"] = @1;
    if (data.word.length>0) {
        params[@"word"] = data.word;
    }
    params[@"customerID"] = @(data.cusInfo.customerID);
    params[@"modelPurityId"] = @(data.colorInfo.id);
    if (data.handSize.length>0) {
        params[@"handSize"] = data.handSize;
    }
    params[@"jewelStoneId"] = data.BaseSeaInfo.id;
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            [MBProgressHUD showSuccess:@"提交成功"];
            if ([YQObjectBool boolForObject:response.data]&&
                [YQObjectBool boolForObject:response.data[@"waitOrderCount"]]) {
                App;
                app.shopNum = [response.data[@"waitOrderCount"]intValue];
            }
            [self gotoNextViewConter:response.data];
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:url params:params];
}

//是否需要付款 是否下单ERP
- (void)gotoNextViewConter:(id)dic{
    UIViewController *cur = [ShowLoginViewTool getCurrentVC];
    if ([dic[@"isNeetPay"]intValue]==1) {
        PayViewController *payVc = [PayViewController new];
        payVc.orderId = dic[@"orderNum"];
        [cur.navigationController pushViewController:payVc animated:YES];
    }else{
        if ([dic[@"isErpOrder"]intValue]==0) {
            ConfirmOrderVC *oDetailVc = [ConfirmOrderVC new];
            oDetailVc.editId = [dic[@"id"] intValue];
            [cur.navigationController pushViewController:oDetailVc animated:YES];
        }else{
            ProductionOrderVC *proVc = [ProductionOrderVC new];
            proVc.orderNum = dic[@"orderNum"];
            [cur.navigationController pushViewController:proVc animated:YES];
        }
    }
    StorageDataTool *data = [StorageDataTool shared];
    data.colorInfo = nil;
    data.handSize = nil;
    data.word = nil;
    data.BaseInfo = nil;
    data.BaseSeaInfo = nil;
    if (self.driBack) {
        self.driBack(1,YES);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
