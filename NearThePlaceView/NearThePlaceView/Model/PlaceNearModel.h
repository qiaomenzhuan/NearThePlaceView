//
//  PlaceNearModel.h
//  NearThePlaceView
//
//  Created by 杨磊 on 2018/3/29.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PlaceNearModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,  copy) NSString       *title;
@property (nonatomic,  copy) NSString       *sub_title;
@property (nonatomic,  copy) NSString       *is_video;
@property (nonatomic,  copy) NSString       *show_flag;
@property (nonatomic,  copy) NSString       *cover;
@property (nonatomic,  copy) NSString       *desc;
@property (nonatomic,  copy) NSString       *city;
@property (nonatomic,  copy) NSString       *address;
@property (nonatomic,  copy) NSString       *longitude;
@property (nonatomic,  copy) NSString       *latitude;
@property (nonatomic,  copy) NSString       *distance;
@property (nonatomic,  copy) NSString       *schema;
@property (nonatomic,  copy) NSDictionary   *target;

@end
