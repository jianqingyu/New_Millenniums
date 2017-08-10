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
#import "ShowLoginViewTool.h"
#import "NakedDriLibViewController.h"
@interface CusHauteCoutureView()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *hands;
@property (weak, nonatomic) IBOutlet UILabel *staueLab;
@property (weak, nonatomic) IBOutlet UIButton *proBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIButton *driBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
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
        self.line1H.constant = 0.5;
        self.line2H.constant = 0.5;
        self.infoView.backgroundColor = CUSTOM_COLOR_ALPHA(8, 11, 18, 0.9);
        self.myView.backgroundColor = CUSTOM_COLOR_ALPHA(8, 11, 18, 0.9);
        [self.image setLayerWithW:3 andColor:BordColor andBackW:0.0001];
        [self.proBtn setLayerWithW:3 andColor:[UIColor whiteColor] andBackW:0.5];
        [self.driBtn setLayerWithW:3 andColor:[UIColor whiteColor] andBackW:0.5];
        [self.conBtn setLayerWithW:3 andColor:BordColor andBackW:0.0001];
        [self.infoView setLayerWithW:3 andColor:BordColor andBackW:0.0001];
        [self.myView setLayerWithW:3 andColor:BordColor andBackW:0.0001];
//        右滑手势
        UISwipeGestureRecognizer * recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:recognizer];
//        添加左滑手势
        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self addGestureRecognizer:recognizer];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickConfirm:)
                                                    name:NotificationClickName object:nil];
    }
    return self;
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
        self.sureBtn.selected = YES;
        if (self.driBack) {
            self.driBack(0,YES);
        }
        NSLog(@"swipe left");
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        self.sureBtn.selected = NO;
        if (self.driBack) {
            self.driBack(0,NO);
        }
        NSLog(@"swipe right");
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
    }
}

- (void)setInfo:(NakedDriSeaListInfo *)info{
    if (info) {
        _info = info;
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
    }
}

- (IBAction)openPuct:(id)sender {
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
        list.isSel = YES;
        [cur.navigationController popToViewController:list animated:YES];
    }else{
        list = [ProductListVC new];
        list.isSel = YES;
        [cur.navigationController pushViewController:list animated:YES];
    }
}

- (IBAction)openDriClick:(id)sender {
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
    if (!self.imgInfo) {
        [MBProgressHUD showError:@"请挑选戒托"];
        return;
    }
    if (!self.info) {
        [MBProgressHUD showError:@"请挑选钻石"];
        return;
    }
    UIViewController *cur = [ShowLoginViewTool getCurrentVC];
    ConfirmOrderVC *firmVc = [ConfirmOrderVC new];
    firmVc.isSel = YES;
    [cur.navigationController pushViewController:firmVc animated:YES];
    if (self.driBack) {
        self.driBack(1,YES);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
