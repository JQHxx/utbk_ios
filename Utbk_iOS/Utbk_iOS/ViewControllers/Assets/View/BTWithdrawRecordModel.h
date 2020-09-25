//
//  BTWithdrawRecordModel.h
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTWithdrawRecordModel : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *memberId;
@property (nonatomic,copy)NSString *totalAmount;
@property (nonatomic,copy)NSString *fee;
@property (nonatomic,copy)NSString *arrivedAmount;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,copy)NSString *dealTime;
@property (nonatomic,copy)NSString *admin;
@property (nonatomic,copy)NSString *transactionNumber;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *remark;
@property (nonatomic,assign)NSInteger status;
@end

NS_ASSUME_NONNULL_END
