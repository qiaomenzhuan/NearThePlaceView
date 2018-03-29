//
//  ClusterAnnotation.h
//  NearThePlaceView
//
//  Created by 杨磊 on 2018/3/29.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

@interface ClusterAnnotation : NSObject<MAAnnotation>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate; //poi的平均位置
@property (assign, nonatomic) NSInteger count;
@property (nonatomic, strong) NSMutableArray *pois;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate count:(NSInteger)count;

@end
