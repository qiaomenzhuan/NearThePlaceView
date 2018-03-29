//
//  ClusterAnnotation.m
//  NearThePlaceView
//
//  Created by 杨磊 on 2018/3/29.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import "ClusterAnnotation.h"
@implementation ClusterAnnotation

#pragma mark - compare

- (NSUInteger)hash
{
    NSString *toHash = [NSString stringWithFormat:@"%.5F%.5F%ld", self.coordinate.latitude, self.coordinate.longitude, (long)self.count];
    return [toHash hash];
}

- (BOOL)isEqual:(id)object
{
    return [self hash] == [object hash];//根据对象的hash值判断是否相等
}

#pragma mark - Life Cycle

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate count:(NSInteger)count
{
    self = [super init];
    if (self)
    {
        _coordinate = coordinate;
        _count = count;
        _pois  = [NSMutableArray arrayWithCapacity:count];
    }
    return self;
}

@end
