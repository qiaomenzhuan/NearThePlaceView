//
//  NearThePlacePopView.h
//  SportChina
//
//  Created by 杨磊 on 2018/3/26.
//  Copyright © 2018年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlaceNearModel;

typedef void (^intBlock)(NSInteger index);

@interface NearThePlacePopView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *titLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBot;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titLabHeight;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addHeight;
@property (weak, nonatomic) IBOutlet UILabel *daohangLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addBot;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addYop;

@property (nonatomic, strong) PlaceNearModel *model;
@property (nonatomic,   copy) intBlock closeBlock;//1详情
@end
