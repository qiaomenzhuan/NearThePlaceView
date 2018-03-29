//
//  NearThePlaceBackView.m
//  NearThePlaceView
//
//  Created by 杨磊 on 2018/3/29.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import "NearThePlaceBackView.h"
#import "CustomInTurnAnnotationModel.h"
@implementation NearThePlaceBackView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.topLabel.layer.borderWidth = 3.f;
    self.topLabel.layer.borderColor = COLOR_BASE_GREEN.CGColor;
    
    self.leftLabel.layer.borderWidth = 3.f;
    self.leftLabel.layer.borderColor = COLOR_BASE_GREEN.CGColor;
    
    self.bottomLabel.layer.borderWidth = 3.f;
    self.bottomLabel.layer.borderColor = COLOR_BASE_GREEN.CGColor;
    
    self.rightLabel.layer.borderWidth = 3.f;
    self.rightLabel.layer.borderColor = COLOR_BASE_GREEN.CGColor;
}

- (IBAction)topclick:(id)sender
{
    if (self.placeBlock)
    {
        self.placeBlock(self.topModel);
    }
}

- (IBAction)leftClick:(id)sender
{
    if (self.placeBlock)
    {
        self.placeBlock(self.leftModel);
    }
}

- (IBAction)bottomClick:(id)sender
{
    if (self.placeBlock)
    {
        self.placeBlock(self.botModel);
    }
}

- (IBAction)rightClick:(id)sender
{
    if (self.placeBlock)
    {
        self.placeBlock(self.rightModel);
    }
}

- (IBAction)myLocation:(id)sender
{
    if (self.clickBlock)
    {
        self.clickBlock(1);
    }
}


#pragma mark - 悬浮场所核心
- (void)place_fx:(MAMapView *)mapView DataSourceAnnotations:(NSMutableArray *)dataSourceAnnotations ToView:(UIView *)view
{
    if (dataSourceAnnotations.count == 0) {
        return;
    }
    NSMutableArray *topArr   = [NSMutableArray array];
    NSMutableArray *leftArr  = [NSMutableArray array];
    NSMutableArray *botArr   = [NSMutableArray array];
    NSMutableArray *rightArr = [NSMutableArray array];
    
    for (CustomInTurnAnnotationModel *model in dataSourceAnnotations)
    {
        CGPoint p = [mapView convertCoordinate:model.coordinate toPointToView:view];
        float angle       = atan2(p.y - SCREEN_HEIGHT/2.f,p.x - SCREEN_WIDTH/2.f) * (180.0 / M_PI);//场所和屏幕中心形成的角度
        if (angle < 0.f) {
            angle += 360;
        }
        float angleScreen = atan2(-SCREEN_HEIGHT/2.f,-SCREEN_WIDTH/2.f) * (180.0 / M_PI) + 180;//屏幕中心和原点形成的角度
        if (angle >= 180 + angleScreen && angle < 360 - angleScreen)
        {//上
            [topArr addObject:model];
        }else if (angle < 180 + angleScreen && angle >= 180 - angleScreen)
        {//左
            [leftArr addObject:model];
        }else if (angle < 180 - angleScreen && angle >= angleScreen)
        {//下
            [botArr addObject:model];
        }else
        {//右
            [rightArr addObject:model];
        }
    }
    
    NSMutableArray *disTop = [NSMutableArray array];//顶部场所和屏幕中心距离
    for (int i = 0; i < topArr.count; i++)
    {
        CustomInTurnAnnotationModel *model = [topArr objectAtIndex:i];
        CLLocationCoordinate2D convertPoint = [mapView convertPoint:CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT/2.f) toCoordinateFromView:view];
        double dis = [self distancePoint1:model.coordinate Point2:convertPoint];
        NSString *diss = [NSString stringWithFormat:@"%.2f",dis];
        [disTop addObject:diss];
    }
    
    NSMutableArray *disLeft = [NSMutableArray array];//左部场所和屏幕中心距离
    for (int i = 0; i < leftArr.count; i++)
    {
        CustomInTurnAnnotationModel *model = [leftArr objectAtIndex:i];
        CLLocationCoordinate2D convertPoint = [mapView convertPoint:CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT/2.f) toCoordinateFromView:view];
        double dis = [self distancePoint1:model.coordinate Point2:convertPoint];
        NSString *diss = [NSString stringWithFormat:@"%.2f",dis];
        [disLeft addObject:diss];
    }
    
    NSMutableArray *disBot = [NSMutableArray array];//底部场所和屏幕中心距离
    for (int i = 0; i < botArr.count; i++)
    {
        CustomInTurnAnnotationModel *model = [botArr objectAtIndex:i];
        CLLocationCoordinate2D convertPoint = [mapView convertPoint:CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT/2.f) toCoordinateFromView:view];
        double dis = [self distancePoint1:model.coordinate Point2:convertPoint];
        NSString *diss = [NSString stringWithFormat:@"%.2f",dis];
        [disBot addObject:diss];
    }
    
    NSMutableArray *disRight = [NSMutableArray array];//右部场所和屏幕中心距离
    for (int i = 0; i < rightArr.count; i++)
    {
        CustomInTurnAnnotationModel *model = [rightArr objectAtIndex:i];
        CLLocationCoordinate2D convertPoint = [mapView convertPoint:CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT/2.f) toCoordinateFromView:view];
        double dis = [self distancePoint1:model.coordinate Point2:convertPoint];
        NSString *diss = [NSString stringWithFormat:@"%.2f",dis];
        [disRight addObject:diss];
    }
    
    self.topView.hidden    = true;
    self.leftView.hidden   = true;
    self.bottomView.hidden = true;
    self.rightView.hidden  = true;
    
    NSInteger topIndex = [self findNearModel:disTop];
    if (topIndex >= 0)
    {//上部
        CustomInTurnAnnotationModel *model = [topArr objectAtIndex:topIndex];//离屏幕中间最近
        self.topModel = model;
        [self movePlaceInfo:model ToView:view SubmapView:mapView];
    }
    
    NSInteger leftIndex = [self findNearModel:disLeft];
    if (leftIndex >= 0)
    {//左部
        CustomInTurnAnnotationModel *model = [leftArr objectAtIndex:leftIndex];//离屏幕中间最近
        self.leftModel = model;
        [self movePlaceInfo:model ToView:view SubmapView:mapView];
    }
    
    NSInteger botIndex = [self findNearModel:disBot];
    if (botIndex >= 0)
    {//下部
        CustomInTurnAnnotationModel *model = [botArr objectAtIndex:botIndex];//离屏幕中间最近
        self.botModel = model;
        [self movePlaceInfo:model ToView:view SubmapView:mapView];
    }
    
    NSInteger rightIndex = [self findNearModel:disRight];
    if (rightIndex >= 0)
    {//右部
        CustomInTurnAnnotationModel *model = [rightArr objectAtIndex:rightIndex];//离屏幕中间最近
        self.rightModel = model;
        [self movePlaceInfo:model ToView:view SubmapView:mapView];
    }
}

#pragma mark - 查找离屏幕某个方向最近的点
- (NSInteger)findNearModel:(NSMutableArray *)array
{
    if (array.count > 0)
    {
        double dis0 = [array[0] floatValue];
        NSInteger index = 0;
        for (int i = 1; i < array.count; i++)
        {
            NSString *diss = [array objectAtIndex:i];
            double dis = [diss floatValue];
            if (dis0 > dis) {
                dis0 = dis;
                index = i;
            }
        }
        return index;
    }
    return -1;
}

#pragma mark - 设置悬浮按钮

- (void)movePlaceInfo:(CustomInTurnAnnotationModel *)model  ToView:(UIView *)view SubmapView:(MAMapView *)mapView
{
    CGPoint p = [mapView convertCoordinate:model.coordinate toPointToView:view];
    float angle       = atan2(p.y - SCREEN_HEIGHT/2.f,p.x - SCREEN_WIDTH/2.f) * (180.0 / M_PI);//场所和屏幕中心形成的角度
    if (angle < 0.f) {
        angle += 360;
    }
    float angleScreen = atan2(-SCREEN_HEIGHT/2.f,-SCREEN_WIDTH/2.f) * (180.0 / M_PI) + 180;//屏幕中心和原点形成的角度
    if (angle >= 180 + angleScreen && angle < 360 - angleScreen)
    {//上
        CGFloat scalet = (angle - 180 - angleScreen)/(180 - 2*angleScreen);// 0<=scalet<1
        CGFloat topL   = SCREEN_WIDTH * scalet;
        CGFloat titlew = 0;
        if (![self isNullOrNilWithObject:model.nameStr])
        {
            titlew = [self getStringWidth:model.nameStr andFont:15.f] + 22;
        }
        titlew = MAX(titlew, 50);
        titlew = MIN(titlew, SCREEN_WIDTH - 42);
        CGFloat w = titlew;//场所文字的宽度
        topL -= w/2.f;
        topL = MAX(topL, 10);
        topL = MIN(topL, SCREEN_WIDTH - 10 - w);
        self.topLabel.text = model.nameStr;
        [UIView animateWithDuration:0.1 animations:^{
            self.topViewLeft.constant = topL;
            [self layoutIfNeeded];
        }];
        self.topViewWidth.constant = w;
        self.topView.hidden = false;
    }else if (angle < 180 + angleScreen && angle >= 180 - angleScreen)
    {//左
        CGFloat scalel  = 1 - (angle - 180 + angleScreen)/(2*angleScreen);// 0<scalet<=1
        CGFloat leftT   = SCREEN_HEIGHT * scalel;
        CGFloat titlew = 0;
        if (![self isNullOrNilWithObject:model.nameStr])
        {
            titlew = [self getStringWidth:model.nameStr andFont:15.f] + 42;
        }
        titlew = MAX(titlew, 50);
        titlew = MIN(titlew, SCREEN_WIDTH - 30);
        CGFloat w = titlew + 20;//场所文字的宽度
        leftT -= 19.f;
        leftT = MAX(leftT, 68);
        leftT = MIN(leftT, SCREEN_HEIGHT - 78 - 48);
        self.leftLabel.text = model.nameStr;
        [UIView animateWithDuration:0.1 animations:^{
            self.leftViewTop.constant = leftT;
            [self layoutIfNeeded];
        }];
        self.leftViewWidth.constant = w;
        self.leftView.hidden = false;
    }else if (angle < 180 - angleScreen && angle >= angleScreen)
    {//下
        CGFloat scaleb  = 1 - (angle - angleScreen)/(180 - 2*angleScreen);// 0<scalet<=1
        CGFloat botL   = SCREEN_WIDTH * scaleb;
        CGFloat titlew = 0;
        if (![self isNullOrNilWithObject:model.nameStr])
        {
            titlew = [self getStringWidth:model.nameStr andFont:15.f] + 22;
        }
        titlew = MAX(titlew, 50);
        titlew = MIN(titlew, SCREEN_WIDTH - 42);
        CGFloat w = titlew;//场所文字的宽度
        botL -= w/2.f;
        botL = MAX(botL, 10);
        botL = MIN(botL, SCREEN_WIDTH - 10 - w);
        self.bottomLabel.text = model.nameStr;
        [UIView animateWithDuration:0.1 animations:^{
            self.bottomLeft.constant = botL;
            [self layoutIfNeeded];
        }];
        self.bottomWidth.constant = w;
        self.bottomView.hidden = false;
    }else
    {//右
        CGFloat q = angle + angleScreen;
        if (angle >= 360 - angleScreen && angle < 360)
        {
            q = angle - 360 + angleScreen;
        }
        CGFloat scaler  = q/(2*angleScreen);// 0<=scalet<1
        CGFloat rightT  = SCREEN_HEIGHT * scaler;
        CGFloat titlew = 0;
        if (![self isNullOrNilWithObject:model.nameStr])
        {
            titlew = [self getStringWidth:model.nameStr andFont:15.f] + 42;
        }
        titlew = MAX(titlew, 50);
        titlew = MIN(titlew, SCREEN_WIDTH - 30);
        CGFloat w = titlew + 20;//场所文字的宽度
        rightT -= 19.f;
        rightT = MAX(rightT, 68);
        rightT = MIN(rightT, SCREEN_HEIGHT - 48 - 78);
        self.rightLabel.text = model.nameStr;
        [UIView animateWithDuration:0.1 animations:^{
            self.rightViewTop.constant = rightT;
            [self layoutIfNeeded];
        }];
        self.rightViewWidth.constant = w;
        self.rightView.hidden = false;
    }
}

#pragma mark - 隐藏
- (void)hideView
{
    self.topView.hidden    = true;
    self.leftView.hidden   = true;
    self.bottomView.hidden = true;
    self.rightView.hidden  = true;
}
#pragma mark - 穿透view
-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if(testHits)
    {
        return nil;
    }
    if(!self.passthroughViews || (self.passthroughViews && self.passthroughViews.count == 0))
    {
        return self;
    } else {
        UIView *hitView = [super hitTest:point withEvent:event];
        if (hitView == self) {
            testHits = YES;
            CGPoint superPoint = [self.superview convertPoint:point fromView:self];
            UIView *superHitView = [self.superview hitTest:superPoint withEvent:event];
            testHits = NO;
            if ([self isPassthroughView:superHitView])
            {
                hitView = superHitView;
            }
        }
        return hitView;
    }
}

- (BOOL)isPassthroughView:(UIView *)view
{
    if (view == nil)
    {
        return NO;
    }
    if ([self.passthroughViews containsObject:view])
    {
        return YES;
    }
    return [self isPassthroughView:view.superview];
}

- (double)distancePoint1:(CLLocationCoordinate2D)point1 Point2:(CLLocationCoordinate2D)point2
{
    //1.将两个经纬度点转成投影点
    MAMapPoint pointL1 = MAMapPointForCoordinate(point1);
    MAMapPoint pointL2 = MAMapPointForCoordinate(point2);
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(pointL1,pointL2);//两个坐标的距离多少米
    return distance;
}

//计算文本的宽度
- (float)getStringWidth:(NSString *)text andFont:(float)font{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width+1;
}


//计算文本的高度
- (float)getStringHeight:(NSString *)text andFont:(float)font andWidth:(float)width{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height+1;
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
@end

