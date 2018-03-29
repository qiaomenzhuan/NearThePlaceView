//
//  CustomInTurnAnnotationModel.h
//  NearThePlaceView
//
//  Created by 杨磊 on 2018/3/29.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class MapPointModel;
@class PlaceNearModel;

typedef NS_ENUM(NSUInteger, CustomAnnotationType){
    CustomAnnotationTypeDefault = 1,//依次穿越 打卡点 圆圈
    CustomAnnotationTypeStart,//起点
    CustomAnnotationTypeEnd,//终点
    CustomAnnotationTypeScore,//积分赛打卡点
    CustomAnnotationTypeStartNew,//带导航的起点
    CustomAnnotationTypeNewPlay//新玩法
};

@interface CustomInTurnAnnotationModel : MAPointAnnotation
@property (nonatomic, assign) CustomAnnotationType type;
@property (nonatomic, assign) BOOL isSelect;//是否打卡
@property (nonatomic, assign) BOOL isSel;//是否选中
@property (nonatomic, assign) BOOL isSelByUser;//和isSel一起使用 只有选中点标才动画
@property (nonatomic, assign) BOOL isMustClock;//是否为必打点
@property (nonatomic, assign) NSInteger isRadius;//0不动 1动画

@property (nonatomic,   copy) NSString *nameStr;//第几个点标
@property (nonatomic,   copy) NSString *titleStr;//点标的文字
@property (nonatomic,   copy) NSString *scoreStr;//点标的分数
@property (nonatomic,   copy) NSString *distanceStr;//距离
@property (nonatomic,   copy) NSString *radius;
@property (nonatomic,   copy) NSString *icon;//点上的图片

@property (nonatomic, strong) MapPointModel *pointModel;
@property (nonatomic, strong) PlaceNearModel *placenear;

@end
