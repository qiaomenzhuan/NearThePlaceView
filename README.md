# NearThePlaceView
附近场所
![gif5新文件.gif](https://upload-images.jianshu.io/upload_images/6206716-7808e3e91598fc5a.gif?imageMogr2/auto-orient/strip)
当移动地图后屏幕内没有maker时，出现指引的悬浮按钮，效果还是很酷炫的。

实现原理就是计算出屏幕中心和maker形成的夹角a，然后根据屏幕宽高比形成的夹角b和a作比较，把maker分为上下左右四组，再分别选出四组里离当前屏幕中心最近的点，即最多在屏幕的上下左右各悬浮一个指引按钮

根据形成的夹角a将maker分为上下左右四组
```
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
```

计算出四组maker，离当前屏幕中心的距离
```
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
```

再分别从上面四个距离数组中找出最近的一个maker
```
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
```

分别设置上下左右四个悬浮按钮的大小和位置，有一个滑动范围
```
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
```

以上。
