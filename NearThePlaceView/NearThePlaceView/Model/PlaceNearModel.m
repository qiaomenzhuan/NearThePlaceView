//
//  PlaceNearModel.m
//  NearThePlaceView
//
//  Created by 杨磊 on 2018/3/29.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import "PlaceNearModel.h"

@implementation PlaceNearModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"title":@"title",
             @"sub_title":@"sub_title",
             @"is_video":@"is_video",
             @"show_flag":@"show_flag",
             @"cover":@"cover",
             @"desc":@"desc",
             @"city":@"city",
             @"address":@"address",
             @"longitude":@"longitude",
             @"latitude":@"latitude",
             @"distance":@"distance",
             @"target":@"target",
             @"schema":@"schema"
             };
}

+ (NSValueTransformer *)is_videoJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",string];
    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",number];
    }];
}

+ (NSValueTransformer *)show_flagJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",string];
    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",number];
    }];
}

+ (NSValueTransformer *)addressJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",string];
    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",number];
    }];
}

+ (NSValueTransformer *)latitudelongitudeJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",string];
    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",number];
    }];
}

+ (NSValueTransformer *)distanceJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",string];
    } reverseBlock:^id(NSNumber *number, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",number];
    }];
}
@end
