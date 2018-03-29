//
//  NearThePlaceAnnView.m
//  SportChina
//
//  Created by 杨磊 on 2018/3/26.
//  Copyright © 2018年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import "NearThePlaceAnnView.h"
#import "CustomInTurnAnnotationModel.h"
#define kWidth   70.f
#define ZOOM_LEVEL 0.8f

@interface NearThePlaceAnnView()

@property (nonatomic, strong) UILabel *titLabel;
@property (nonatomic, strong) UILabel *moreLabel;
@property (nonatomic, strong) UIImageView *backPic;
@property (nonatomic, strong) UIImageView *trianglePic;
@property (nonatomic, strong) CABasicAnimation *animation;

@end

@implementation NearThePlaceAnnView
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self setAnn:nil];
    }
    
    return self;
}

- (void)setAnn:(CustomInTurnAnnotationModel *)ann
{
    _ann = ann;
    if (ann)
    {//没有聚合
        self.moreLabel.hidden   = true;
        self.backPic.hidden     = true;
        
        self.moreLabel.frame    = CGRectZero;
        self.backPic.frame      = CGRectZero;
        
        self.trianglePic.hidden = false;
        self.titLabel.hidden    = false;
        
        self.transform = CGAffineTransformIdentity;
        [self bringSubviewToFront:self.titLabel];
        [self setupAnnotation:ann];
    }else
    {//聚合
        self.moreLabel.hidden   = false;
        self.backPic.hidden     = false;
        
        self.trianglePic.hidden = true;
        self.titLabel.hidden    = true;
        
        self.trianglePic.frame = CGRectZero;
        self.titLabel.frame    = CGRectZero;
        
        self.bounds            = CGRectMake(0.f, 0.f, kWidth, kWidth);
        self.moreLabel.frame   = CGRectMake(0, 0, kWidth, 37.f);
        self.backPic.frame     = CGRectMake(0.f, 0.f, kWidth, kWidth);
        
        self.centerOffset      = CGPointMake(0.f, - ZOOM_LEVEL*(kWidth/2.f - 5.f));
        self.transform         = CGAffineTransformMakeScale(ZOOM_LEVEL, ZOOM_LEVEL);
        
        self.moreLabel.text = [NSString stringWithFormat:@"%ld",self.count];
        [self bringSubviewToFront:self.moreLabel];
    }
}

- (void)setupAnnotation:(CustomInTurnAnnotationModel *)ann
{
    CGFloat titlew = 0;
    if (![self isNullOrNilWithObject:ann.nameStr])
    {
        titlew = [self getStringWidth:ann.nameStr andFont:15.f] + 22;
    }
    titlew = MAX(titlew, 50);
    titlew = MIN(titlew, SCREEN_WIDTH);
    self.bounds            = CGRectMake(0.f, 0.f, titlew, 44.f);
    self.titLabel.frame    = CGRectMake(0, 0, titlew, 38.f);
    self.trianglePic.frame = CGRectMake((titlew - 15.f)/2.f, 37.f, 15.f, 7.f);
    self.centerOffset      = CGPointMake(0.f, - 22.f);
    self.titLabel.text     = ann.nameStr;
}

- (UILabel *)titLabel
{//场所名称
    if (!_titLabel) {
        _titLabel                    = [UILabel new];
        _titLabel.backgroundColor    = [UIColor whiteColor];
        _titLabel.textColor          = COLOR_BASE_GREEN;
        _titLabel.textAlignment      = NSTextAlignmentCenter;
        _titLabel.font               = [UIFont boldSystemFontOfSize:15.f];
        _titLabel.layer.cornerRadius = 19.f;
        _titLabel.clipsToBounds      = YES;
        _titLabel.layer.borderWidth  = 3.f;
        _titLabel.layer.borderColor  = COLOR_BASE_GREEN.CGColor;
        [self addSubview:_titLabel];
    }
    return _titLabel;
}

- (UILabel *)moreLabel
{//显示多个重叠一起的个数
    if (!_moreLabel) {
        _moreLabel = [UILabel new];
        _moreLabel.textColor = [UIColor whiteColor];
        _moreLabel.textAlignment =NSTextAlignmentCenter;
        _moreLabel.font   = [UIFont boldSystemFontOfSize:30.f];
        [self addSubview:_moreLabel];
    }
    return _moreLabel;
}

- (UIImageView *)backPic
{//背景图
    if (!_backPic) {
        _backPic = [UIImageView new];
        UIImage *img = [UIImage imageNamed:@"icon_map_r_mark7"];
        _backPic.image = img;
        [self addSubview:_backPic];
    }
    return _backPic;
}

- (UIImageView *)trianglePic
{//三角形
    if (!_trianglePic) {
        _trianglePic = [UIImageView new];
        _trianglePic.image = [UIImage imageNamed:@"icon_jiantou"];//15*7
        [self addSubview:_trianglePic];
    }
    return _trianglePic;
}

#pragma mark - annimation

- (void)willMoveToSuperview:(UIView *)newSuperview
{//添加动画 因为项目频繁添加maker 带动画太乱 故去除动画
    [super willMoveToSuperview:newSuperview];
    if (_ann) {
        [self addBounceAnnimation];
    }
}

- (void)addBounceAnnimation
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.values = @[@(0.1), @(1.1), @(0.8), @(1.f)];
    
    bounceAnimation.duration = 0.6;
    
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounceAnimation.values.count];
    for (NSUInteger i = 0; i < bounceAnimation.values.count; i++)
    {
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    [bounceAnimation setTimingFunctions:timingFunctions.copy];
    
    bounceAnimation.removedOnCompletion = NO;
    bounceAnimation.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:bounceAnimation forKey:@"bounce"];
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
@end
