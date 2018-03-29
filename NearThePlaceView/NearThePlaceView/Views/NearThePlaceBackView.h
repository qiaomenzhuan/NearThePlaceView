//
//  NearThePlaceBackView.h
//  NearThePlaceView
//
//  Created by 杨磊 on 2018/3/29.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomInTurnAnnotationModel;

typedef void (^clickPlace)(CustomInTurnAnnotationModel *model);
typedef void (^intBlock)(NSInteger index);

@interface NearThePlaceBackView : UIView
{
    BOOL testHits;
}
@property (copy, nonatomic) NSArray           *passthroughViews;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomWidth;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (nonatomic,  copy) intBlock clickBlock;//0返回 1我的定位
@property (nonatomic,  copy) clickPlace placeBlock;

@property (nonatomic, strong) CustomInTurnAnnotationModel *topModel;
@property (nonatomic, strong) CustomInTurnAnnotationModel *leftModel;
@property (nonatomic, strong) CustomInTurnAnnotationModel *botModel;
@property (nonatomic, strong) CustomInTurnAnnotationModel *rightModel;

/**
 设置悬浮场所
 
 @param mapView 地图
 @param dataSourceAnnotations 场所数组
 @param view 地图父view
 */
- (void)place_fx
:(MAMapView *)mapView DataSourceAnnotations
:(NSMutableArray *)dataSourceAnnotations ToView
:(UIView *)view;

- (void)hideView;
@end
