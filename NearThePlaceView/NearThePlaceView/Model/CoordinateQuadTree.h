//
//  CoordinateQuadTree.h
//  NearThePlaceView
//
//  Created by 杨磊 on 2018/3/29.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MAMapKit/MAMapKit.h>
#import "QuadTree.h"

@interface CoordinateQuadTree : NSObject

@property (nonatomic, assign) QuadTreeNode * root;
/// 这里对poi对象的内存管理被四叉树接管了，当clean的时候会释放，外部有引用poi的地方必须再clean前清理。
- (void)buildTreeWithPOIs:(NSArray *)pois;
- (void)clean;

//根据地图缩放等级 展开 聚合
- (NSArray *)clusteredAnnotationsWithinMapRect:(MAMapRect)rect withZoomScale:(double)zoomScale andZoomLevel:(double)zoomLevel;
//根据屏幕像素 展开 聚合
- (NSArray *)clusteredAnnotationsWithinMapRect:(MAMapRect)rect withDistance:(double)distance andZoomLevel:(double)zoomLevel;

@end
