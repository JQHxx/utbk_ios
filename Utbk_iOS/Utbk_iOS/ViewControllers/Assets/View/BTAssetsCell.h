//
//  BTAssetsCell.h
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTAssetsCell : UITableViewCell

@property (assign, nonatomic) NSInteger status;
@property (assign,nonatomic) NSInteger cellType;//0代表币币，1代表矿池，2代表法币
@property (copy, nonatomic) void(^cellBtnClickAction)(NSInteger index);//0代表收款，1代表转账，2代表划转
@property (copy, nonatomic) void(^assetsDetailAction)(void);

- (void)configureCellWithAssetsModel:(id)model;

@end

NS_ASSUME_NONNULL_END
