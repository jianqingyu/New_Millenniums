//
//  CustomLastCell.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/14.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "CustomLastCell.h"
@interface CustomLastCell()<UITextViewDelegate>

@end
@implementation CustomLastCell

+ (id)cellWithTableView:(UITableView *)tableView{
    static NSString *Id = @"customCell";
    CustomLastCell *addCell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (addCell==nil) {
        addCell = [[CustomLastCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [addCell.textView setLayerWithW:3.0 andColor:BordColor andBackW:0.5];
        addCell.textView.placehoder = @"填写备注";
    }
    return addCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CustomLastCell" owner:nil options:nil][0];
        self.textView.delegate = self;
    }
    return self;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.messBack) {
        self.messBack(textView.text);
    }
}

- (void)setMessage:(NSString *)message{
    if (message) {
        _message = message;
        self.textView.text = _message;
    }
}

@end
