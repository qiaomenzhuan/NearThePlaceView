//
//  NearThePlacePopView.m
//  SportChina
//
//  Created by 杨磊 on 2018/3/26.
//  Copyright © 2018年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import "NearThePlacePopView.h"
#import "PlaceNearModel.h"
@implementation NearThePlacePopView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"导航"];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"icon_position_white"];
    attch.bounds = CGRectMake(-5.f, -4.f, 22.f, 22.f);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    self.daohangLabel.attributedText = attri;
}

- (void)setModel:(PlaceNearModel *)model
{
    _model = model;
    [self.headImgView setImage:[UIImage imageNamed:@"default"]];
    
    NSString *title = [NSString stringWithFormat:@"%@",model.title];
    CGFloat titleH = 0;
    if (![self isNullOrNilWithObject:title]) {
       titleH = [self getStringHeight:title andFont:18.f andWidth:SCREEN_WIDTH/2.f - 22.5f];
    }
    titleH = MIN(titleH, 45);
    titleH = MAX(titleH, 14);
    self.titLabHeight.constant = titleH;
    
    if (titleH <= 30)
    {
        self.titleBot.constant = 25;
    }else
    {
        self.titleBot.constant = 5;
    }
    
    self.titLabel.text = title;
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%@",model.distance];

    NSString *add = [NSString stringWithFormat:@"%@",model.address];
    CGFloat addH = 0;
    if (![self isNullOrNilWithObject:add]) {
        addH = [self getStringHeight:add andFont:14.f andWidth:SCREEN_WIDTH/2.f - 50.5f];
    }
    addH = MIN(addH, 35);
    addH = MAX(addH, 14);
    self.addHeight.constant = addH;
    
    if (addH < 30)
    {
        self.addYop.constant    = 26;
    }else
    {
        self.addYop.constant    = 16;
    }
    self.addressLabel.text  = add;
}

- (IBAction)close:(id)sender {
    if (self.closeBlock) {
        self.closeBlock(0);
    }
}

- (IBAction)daohang:(id)sender {
    if (self.closeBlock) {
        self.closeBlock(0);
    }
    NSLog(@"导航");
}
- (IBAction)detail:(id)sender {
    if (self.closeBlock)
    {
        self.closeBlock(1);
    }
}

//判断是否为空
- (BOOL)isNullOrNilWithObject:(id)object;
{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]||[object isEqualToString:@"(null)"]) {
            return YES;
        } else {
            return NO;
        }
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

//计算文本的宽度
- (float)getStringWidth:(NSString *)text andFont:(float)font{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width+1;
}


//计算文本的高度
- (float)getStringHeight:(NSString *)text andFont:(float)font andWidth:(float)width{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height+1;
}
@end
