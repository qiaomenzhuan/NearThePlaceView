//
//  NearThePlaceAnnView.h
//  SportChina
//
//  Created by 杨磊 on 2018/3/26.
//  Copyright © 2018年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class CustomInTurnAnnotationModel;

@interface NearThePlaceAnnView : MAAnnotationView

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) CustomInTurnAnnotationModel *ann;

@end
