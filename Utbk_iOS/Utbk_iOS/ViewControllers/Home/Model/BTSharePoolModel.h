//
//  BTSharePoolModel.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/26.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTSharePoolModel : NSObject
/**
 amount = 200;
 contributionValue = 20;
 groupsQty = 2;
 id = 1;
 saveTime = "2020-09-22 15:36:31";
 shareContributionValue = 0;
 todayContributionValue = 0;
 totalProduce = 35;
 type = 1;
 userId = 83;
 yesterdayProduce = 1;
 */
@property (nonatomic,assign) CGFloat amount;//贡献的总量
@property (nonatomic,copy) NSString *contributionValue;//贡献值
@property (nonatomic,assign) NSInteger groupsQty;//组数量
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,copy) NSString *saveTime;
@property (nonatomic,assign) CGFloat shareContributionValue;
@property (nonatomic,assign) CGFloat todayContributionValue;
@property (nonatomic,copy) NSString *totalProduce;//总产出
@property (nonatomic,assign) NSInteger type;//类型 1普通矿工 2矿主 3加权分红席位矿主
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,assign) CGFloat yesterdayProduce;//昨日产出
//下面两个后台加
@property (nonatomic,copy) NSString *coin;
@property (nonatomic,assign) CGFloat destroyValue;//销毁总量
@end

NS_ASSUME_NONNULL_END