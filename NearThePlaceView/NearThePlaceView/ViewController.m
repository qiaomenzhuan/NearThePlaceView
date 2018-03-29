//
//  ViewController.m
//  NearThePlaceView
//
//  Created by 杨磊 on 2018/3/29.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import "ViewController.h"
#import "TBActionSheet.h"

#import "PlaceNearModel.h"
#import "CustomInTurnAnnotationModel.h"
#import "CoordinateQuadTree.h"
#import "ClusterAnnotation.h"
#import "NearThePlaceAnnView.h"
#import "NearThePlacePopView.h"
#import "NearThePlaceBackView.h"
#define kMapCoreAnimationDuration 5.f

@interface ViewController ()<MAMapViewDelegate,TBActionSheetDelegate,CAAnimationDelegate>

@property (nonatomic,strong) MAMapView                  *mapView;//地图
@property (nonatomic,  copy) NSMutableArray             *dataArray;
@property (nonatomic,  copy) NSMutableArray             *dataSourceAnnotations;//处理过的坐标数组
@property (nonatomic,strong) CoordinateQuadTree         *coordinateQuadTree;//点聚合四叉树
@property (nonatomic,assign) BOOL                       shouldRegionChangeReCalculate;//判断点聚合准备状态
@property (nonatomic,strong) TBActionSheet              *actionSheet;
@property (nonatomic,strong) NearThePlacePopView        *popView;
@property (nonatomic,strong) NearThePlaceBackView       *nearThePlaceBackView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self subinit];
    [self place_near];
}

#pragma mark - init
- (void)subinit
{
    self.view.backgroundColor           = [UIColor groupTableViewBackgroundColor];
    self.mapView.showsUserLocation      = true;
    self.coordinateQuadTree             = [[CoordinateQuadTree alloc] init];
    self.shouldRegionChangeReCalculate  = false;
    self.mapView.hidden                 = true;
    [self cusBack];
}
#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[ClusterAnnotation class]])
    {//多个标注点
        /* dequeue重用annotationView. */
        static NSString *const AnnotatioViewReuseID = @"AnnotatioViewReuseID";
        
        NearThePlaceAnnView *annotationView = (NearThePlaceAnnView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotatioViewReuseID];
        
        if (!annotationView)
        {
            annotationView = [[NearThePlaceAnnView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:AnnotatioViewReuseID];
        }
        ClusterAnnotation *cluster = (ClusterAnnotation *)annotation;
        /* 设置annotationView的属性. */
        annotationView.annotation = annotation;
        /* 不弹出原生annotation */
        annotationView.canShowCallout = false;
        annotationView.zIndex = 10;
        annotationView.count = cluster.count;
        if (cluster.pois.count == 1)
        {
            AMapPOI *aPoi = (AMapPOI *)cluster.pois[0];
            CustomInTurnAnnotationModel *ann = (CustomInTurnAnnotationModel *)aPoi.subPOIs[0];
            annotationView.ann = ann;
        }else
        {
            annotationView.ann = nil;
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if ([view isKindOfClass:[NearThePlaceAnnView class]])
    {//设置自定义点为地图中心
        ClusterAnnotation *cluster = (ClusterAnnotation *)view.annotation;
        if (cluster.count != 1)
        {
            AMapPOI *aPoi = (AMapPOI *)cluster.pois[0];
            CustomInTurnAnnotationModel *pointAnnotation = (CustomInTurnAnnotationModel *)aPoi.subPOIs[0];
            self.mapView.zoomLevel = 19;
            [self.mapView setCenterCoordinate:pointAnnotation.coordinate animated:true];
            [self.mapView deselectAnnotation:self.mapView.selectedAnnotations.firstObject animated:true];
            return;
        }
        
        AMapPOI *aPoi = (AMapPOI *)cluster.pois[0];
        CustomInTurnAnnotationModel *pointAnnotation = (CustomInTurnAnnotationModel *)aPoi.subPOIs[0];
        self.popView.model = pointAnnotation.placenear;
        [self.mapView setCenterCoordinate:pointAnnotation.coordinate animated:true];
        self.actionSheet.customView = self.popView;
        [self.actionSheet show];
        
        [self.mapView deselectAnnotation:self.mapView.selectedAnnotations.firstObject animated:true];
    }
}

- (void)mapViewRegionChanged:(MAMapView *)mapView
{
    [self addAnnotationsToMapView];
}
#pragma mark - 附近场所数据
- (void)place_near
{
    NSArray *dataArr = @[
    @{
        @"address": @"方法会对剪发的",
        @"cover":@"http://f.qncdn.orunapp.com/image/2018/0323/20180323030449308_820",
        @"distance":@"15.67km",
        @"latitude":@"39.893315",
        @"longitude" : @"116.510200",
        @"schema" : @"ORUN://PLACE_INFO/NTQ0",
        @"title" : @"独领风骚代理方看来是"
    },
    @{
        @"address": @"的记得加",
        @"cover":@"http://f.qncdn.orunapp.com/image/2018/0323/20180323030449308_820",
        @"distance":@"15.67km",
        @"latitude":@"39.893402",
        @"longitude" : @"116.510986",
        @"schema" : @"ORUN://PLACE_INFO/NTQ0",
        @"title" : @"电视电话"
    },
    @{
        @"address": @"的还是大航海时代合适的话啥都好说",
        @"cover":@"http://f.qncdn.orunapp.com/image/2018/0323/20180323030449308_820",
        @"distance":@"15.67km",
        @"latitude":@"39.193315",
        @"longitude" : @"116.910200",
        @"schema" : @"ORUN://PLACE_INFO/NTQ0",
        @"title" : @"理方看来是"
    },
    @{
        @"address": @"djj的啥都好说",
        @"cover":@"http://f.qncdn.orunapp.com/image/2018/0323/20180323030449308_820",
        @"distance":@"15.67km",
        @"latitude":@"38.893315",
        @"longitude" : @"115.510200",
        @"schema" : @"ORUN://PLACE_INFO/NTQ0",
        @"title" : @"我都搜到三大城市的"
    },
    @{
        @"address": @"的是否合适的发挥华东师范合适的",
        @"cover":@"http://f.qncdn.orunapp.com/image/2018/0323/20180323030449308_820",
        @"distance":@"15.67km",
        @"latitude":@"39.593315",
        @"longitude" : @"117.510200",
        @"schema" : @"ORUN://PLACE_INFO/NTQ0",
        @"title" : @"电视剧附近"
    },
    @{
        @"address": @"方法会对剪发的",
        @"cover":@"http://f.qncdn.orunapp.com/image/2018/0323/20180323030449308_820",
        @"distance":@"15.67km",
        @"latitude":@"39.293315",
        @"longitude" : @"116.910200",
        @"schema" : @"ORUN://PLACE_INFO/NTQ0",
        @"title" : @"的来是"
    },
    @{
        @"address": @"方法会对剪发的",
        @"cover":@"http://f.qncdn.orunapp.com/image/2018/0323/20180323030449308_820",
        @"distance":@"15.67km",
        @"latitude":@"39.393315",
        @"longitude" : @"116.710200",
        @"schema" : @"ORUN://PLACE_INFO/NTQ0",
        @"title" : @"日日冬冬"
    },
    @{
        @"address": @"方法会对剪发的",
        @"cover":@"http://f.qncdn.orunapp.com/image/2018/0323/20180323030449308_820",
        @"distance":@"15.67km",
        @"latitude":@"39.193315",
        @"longitude" : @"116.110200",
        @"schema" : @"ORUN://PLACE_INFO/NTQ0",
        @"title" : @"都是我我"
    },
    @{
        @"address": @"方法会对剪发的",
        @"cover":@"http://f.qncdn.orunapp.com/image/2018/0323/20180323030449308_820",
        @"distance":@"15.67km",
        @"latitude":@"39.993315",
        @"longitude" : @"116.710200",
        @"schema" : @"ORUN://PLACE_INFO/NTQ0",
        @"title" : @"发顺丰"
    },
    @{
        @"address": @"方法会对剪发的",
        @"cover":@"http://f.qncdn.orunapp.com/image/2018/0323/20180323030449308_820",
        @"distance":@"15.67km",
        @"latitude":@"38.593315",
        @"longitude" : @"115.710200",
        @"schema" : @"ORUN://PLACE_INFO/NTQ0",
        @"title" : @"发挥好"
    },
    @{
        @"address": @"方法会对剪发的",
        @"cover":@"http://f.qncdn.orunapp.com/image/2018/0323/20180323030449308_820",
        @"distance":@"15.67km",
        @"latitude":@"39.493315",
        @"longitude" : @"116.910200",
        @"schema" : @"ORUN://PLACE_INFO/NTQ0",
        @"title" : @"诶味儿诶味儿"
    }
    ];
    NSArray * dataPointsModel = [MTLJSONAdapter modelsOfClass:[PlaceNearModel class] fromJSONArray:dataArr error:nil];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:dataPointsModel];
    [self addPointAndLine];
}

#pragma mark - 描点
- (void)addPointAndLine
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < self.dataArray.count; i++)
        {
            double coordX = 0;
            double coordY = 0;
            PlaceNearModel *model = [self.dataArray objectAtIndex:i];
            coordX = [self isNullOrNilWithObject:model.latitude] ? 0 : [model.latitude doubleValue];
            coordY = [self isNullOrNilWithObject:model.longitude] ? 0 : [model.longitude doubleValue];
            if (coordY != 0) {
                CustomInTurnAnnotationModel *pointAnnotation = [[CustomInTurnAnnotationModel alloc] init];
                pointAnnotation.coordinate = CLLocationCoordinate2DMake(coordX, coordY);
                pointAnnotation.nameStr    = [NSString stringWithFormat:@"%@",model.title];
                pointAnnotation.placenear  = model;
                [self.dataSourceAnnotations addObject:pointAnnotation];
            }
        }
        [self reloadMaker];
    });
}

#pragma mark - 点聚合
- (void)addAnnotationsToMapView
{
    @synchronized(self)
    {
        if (self.coordinateQuadTree.root == nil || !self.shouldRegionChangeReCalculate)
        {
            NSLog(@"tree is not ready.");
            return;
        }
        MAMapRect visibleRect = self.mapView.visibleMapRect;
        /* 根据zoomLevel计算指定屏幕距离(以50像素为例)对应的实际距离 进行annotation聚合. */
        CGFloat zooml = self.mapView.zoomLevel;
        double distance = 50.f * [self.mapView metersPerPointForZoomLevel:zooml];
        NSArray *annotations = [self.coordinateQuadTree clusteredAnnotationsWithinMapRect:visibleRect withDistance:distance andZoomLevel:zooml];
        [self updateMapViewAnnotationsWithAnnotations:annotations];
    }
}

/* 更新annotation. */
- (void)updateMapViewAnnotationsWithAnnotations:(NSArray *)annotations
{
    /* 用户滑动时，保留仍然可用的标注，去除屏幕外标注，添加新增区域的标注 */
    NSMutableSet *before = [NSMutableSet setWithArray:self.mapView.annotations];
    
    [before removeObject:[self.mapView userLocation]];
    NSSet *after = [NSSet setWithArray:annotations];
    /* 保留仍然位于屏幕内的annotation. */
    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
    [toKeep intersectSet:after];
    
    /* 需要添加的annotation. */
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:toKeep];
    
    /* 删除位于屏幕外的annotation. */
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];
    
    /* 更新. */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mapView.hidden = NO;
        [self.mapView addAnnotations:[toAdd allObjects]];
        [self.mapView removeAnnotations:[toRemove allObjects]];
        if (self.mapView.annotations.count == 0)
        {
            [self.nearThePlaceBackView place_fx:self.mapView
                          DataSourceAnnotations:self.dataSourceAnnotations
                                         ToView:self.view];
        }else
        {
            [self.nearThePlaceBackView hideView];
        }
    });
}

#pragma mark - 更新maker
- (void)reloadMaker
{
    if (self.dataSourceAnnotations.count == 0)
    {
        return;
    }
    NSMutableArray *poiArr = [NSMutableArray array];
    for (CustomInTurnAnnotationModel *model in self.dataSourceAnnotations)
    {
        AMapPOI *poi = [[AMapPOI alloc]init];
        AMapGeoPoint *loca = [[AMapGeoPoint alloc] init];
        loca.longitude = model.coordinate.longitude;
        loca.latitude = model.coordinate.latitude;
        poi.location = loca;
        poi.subPOIs = @[model];
        [poiArr addObject:poi];
    }
    @synchronized(self)
    {
        self.shouldRegionChangeReCalculate = false;
        
        // 清理
        
        NSMutableArray *annosToRemove = [NSMutableArray arrayWithArray:self.mapView.annotations];
        [annosToRemove removeObject:self.mapView.userLocation];
        [self.mapView removeAnnotations:annosToRemove];
        
        __weak typeof(self) weakSelf = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /* 建立四叉树. */
            [weakSelf.coordinateQuadTree buildTreeWithPOIs:poiArr];
            weakSelf.shouldRegionChangeReCalculate = true;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf addAnnotationsToMapView];
                [weakSelf executeCoreAnimation];
            });
        });
    }
}


#pragma mark - 头部
- (void)cusBack
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"NearThePlaceBackView" owner:nil options:nil];
    self.nearThePlaceBackView = views[0];
    self.nearThePlaceBackView.passthroughViews = @[self.mapView,self.view];
    [self.view addSubview:self.nearThePlaceBackView];
    [self.nearThePlaceBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    @WeakObj(self);
    self.nearThePlaceBackView.clickBlock = ^(NSInteger index) {
        if (index == 0)
        {
            [selfWeak.navigationController popViewControllerAnimated:true];
        }else if (index == 1)
        {
            [selfWeak myLocation];
        }
    };
    self.nearThePlaceBackView.placeBlock = ^(CustomInTurnAnnotationModel *model) {
        [selfWeak bottomPop:model];
    };
}

#pragma mark - 我的定位
- (void)myLocation
{
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location)
    {
        self.mapView.zoomLevel = 19;             //缩放级别（默认3-19)
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:true];
    }
    
    [self addAnnotationsToMapView];
}

#pragma mark - 底部弹出
- (void)bottomPop:(CustomInTurnAnnotationModel *)model
{
    self.mapView.zoomLevel = 19;
    [self.mapView setCenterCoordinate:model.coordinate animated:true];
    self.popView.model = model.placenear;
    self.actionSheet.customView = self.popView;
    [self.actionSheet show];
}

#pragma mark - lazy
- (TBActionSheet *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [[TBActionSheet alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        _actionSheet.sheetWidth = SCREEN_WIDTH;
        _actionSheet.rectCornerRadius = 10.f;
        _actionSheet.offsetY = 5;
    }
    return _actionSheet;
}

- (NearThePlacePopView *)popView
{
    if (!_popView) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"NearThePlacePopView" owner:nil options:nil];
        _popView = views[0];
        @WeakObj(self);
        _popView.closeBlock = ^(NSInteger index) {
            if (index == 1)
            {
                NSLog(@"跳转");
            }
            [selfWeak.actionSheet close];
        };
        
        
        _popView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 278);
    }
    return _popView;
}

-(MAMapView *)mapView
{
    if (!_mapView) {
        _mapView                          = [MAMapView new];
        _mapView.autoresizingMask         = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.rotateCameraEnabled      = false;
        _mapView.rotateEnabled            = false;
        _mapView.showsIndoorMap           = false;
        _mapView.showsScale               = false;
        _mapView.showsCompass             = false;
        _mapView.delegate                 = self;
        _mapView.userTrackingMode         = MAUserTrackingModeFollow;
        [self.view addSubview:_mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _mapView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)dataSourceAnnotations
{
    if (!_dataSourceAnnotations) {
        _dataSourceAnnotations = [NSMutableArray array];
    }
    return _dataSourceAnnotations;
}

#pragma mark - CoreAnimation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:true];
    self.mapView.zoomLevel = 19.f;
}

#pragma mark - CoreAnimation

/* 生成 地图缩放级别的 CAKeyframeAnimation. */
- (CAAnimation *)zoomLevelAnimation
{
    CAKeyframeAnimation *zoomLevelAnimation = [CAKeyframeAnimation animationWithKeyPath:kMAMapLayerZoomLevelKey];
    
    zoomLevelAnimation.delegate = self;
    zoomLevelAnimation.duration = kMapCoreAnimationDuration;
    zoomLevelAnimation.values   = @[@(5)  , @(12)  , @(15)  , @(19)];
    zoomLevelAnimation.keyTimes = @[@(0.f), @(0.4f), @(0.6f), @(1.f)];
    zoomLevelAnimation.timingFunctions = [NSArray arrayWithObjects:
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                          nil];
    return zoomLevelAnimation;
}

/* 执行动画. */
- (void)executeCoreAnimation
{
    /* 添加 缩放级别 动画. */
    [self.mapView.layer addAnimation:[self zoomLevelAnimation]      forKey:kMAMapLayerZoomLevelKey];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
