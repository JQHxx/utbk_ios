//
//  BTAssetsViewController.m
//  Utbk_iOS
//
//  Created by heyong on 2020/9/13.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTAssetsViewController.h"
#import "BTAssetsCell.h"
#import "BTAssetsRechargeVC.h"
#import "BTSweepAccountVC.h"
#import "BTAssetsWithdrawVC.h"
#import "BTAssetsTransiferVC.h"
#import "BTAssetsDetailVC.h"
#import "BTAssetsModel.h"
#import "MineNetManager.h"
#import "SPMultipleSwitch.h"

//测试用
#import "BTAssetsWithdrawVC.h"

@interface BTAssetsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *totalAccount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (assign, nonatomic) NSInteger activeStatus;//激活状态
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) SPMultipleSwitch *multipleSwitch;

@end

@implementation BTAssetsViewController
- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"资产";
    [self setupLayout];
    [self setupBind];
    [self.navigationItem setTitleView:self.multipleSwitch];
    // Do any additional setup after loading the view from its nib.
}
- (SPMultipleSwitch *)multipleSwitch{
    if (!_multipleSwitch) {
        SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[LocalizationKey(@"币币"),LocalizationKey(@"矿池")]];
        switch1.frame = CGRectMake(0, 0, 193, 40);
        [switch1 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside] ;
        
        switch1.selectedTitleColor = RGBOF(0xffffff);
        switch1.titleColor = RGBOF(0xA78659);
        switch1.trackerColor = RGBOF(0xDAC49D);
        switch1.backgroundColor = [UIColor clearColor];
        self.navigationItem.titleView = switch1;
        self.multipleSwitch = switch1;
        switch1.setNeedsCornerRadius = YES;
        switch1.layer.borderWidth = 0.5;
        switch1.layer.borderColor = RGBOF(0xD1A870).CGColor;
        switch1.layer.cornerRadius = 4.f;
        switch1.setForbidenScroll = YES;
        _multipleSwitch = switch1;
    }
    return _multipleSwitch;
}
- (void)switchAction:(SPMultipleSwitch *)multipleSwitch{
    switch (multipleSwitch.selectedSegmentIndex) {
         case 0:
            self.type = 0;
             break;
         case 1:
            self.type = 1;
             break;
         default:
             break;
     }
    [self.tableView reloadData];
}
- (void)setupLayout{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTAssetsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BTAssetsCell class])];
    self.tableView.tableFooterView = [UIView new];
    [self headRefreshWithScrollerView:self.tableView];
}
- (void)refreshHeaderAction{
    [self setupBind];
}
- (void)setupBind{
    //获取我的钱包
    [MineNetManager getMyWalletInfoForCompleteHandle:^(NSDictionary *responseResult, int code) {
        if (NetSuccess) {
            [self.datasource removeAllObjects];
            NSArray *dataArr = [BTAssetsModel mj_objectArrayWithKeyValuesArray:responseResult[@"data"]];
            NSDecimalNumber *ass1 = [[NSDecimalNumber alloc] initWithString:@"0"];
            NSDecimalNumber *ass2 = [[NSDecimalNumber alloc] initWithString:@"0"];
            [self.datasource addObjectsFromArray:dataArr];
            for (BTAssetsModel *walletModel in dataArr) {
                //计算总资产
                NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:8 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                NSDecimalNumber *balance = [[NSDecimalNumber alloc] initWithString:walletModel.balance];
                NSDecimalNumber *usdRate = [[NSDecimalNumber alloc] initWithString:walletModel.coin.usdRate];
                NSDecimalNumber *cnyRate = [[NSDecimalNumber alloc] initWithString:walletModel.coin.cnyRate];

                ass1 = [ass1 decimalNumberByAdding:[balance decimalNumberByMultiplyingBy:usdRate withBehavior:handle] withBehavior:handle];
                ass2 = [ass2 decimalNumberByAdding:[balance decimalNumberByMultiplyingBy:cnyRate withBehavior:handle] withBehavior:handle];
            }
            self.totalAccount.text = [ass1 stringValue];
            [self.tableView reloadData];
        }else{
            ErrorToast
        }
    }];
    [[XBRequest sharedInstance]postDataWithUrl:getMemberStatusAPI Parameter:@{@"memberId":[YLUserInfo shareUserInfo].ID} ResponseObject:^(NSDictionary *responseResult) {
        if (NetSuccess) {
            self.activeStatus = [responseResult[@"data"][@"status"] isKindOfClass:[NSNull class]] ? 0 : [responseResult[@"data"][@"status"] integerValue];
        }else{
            self.activeStatus = 0;
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTAssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BTAssetsCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellType = self.type;
    cell.status = self.activeStatus;
    BTAssetsModel *model = self.datasource[indexPath.row];
    [cell configureCellWithAssetsModel:model];
    WeakSelf(weakSelf)
    cell.cellBtnClickAction = ^(NSInteger index) {
        StrongSelf(strongSelf)
        switch (index) {
            case 0://收款/充币,USDT则为充币，其他币种为收款
            {
                if (self.type == 1) {//矿池划转
                    
                }else{
                    if (!model.coin.canRecharge) {
                        [self.view makeToast:[model.coin.name isEqualToString:@"USDT"] ? LocalizationKey(@"当前不可充币") : LocalizationKey(@"当前不可收币") duration:ToastHideDelay position:ToastPosition];return;
                    }
                    BTAssetsRechargeVC *recharge = [[BTAssetsRechargeVC alloc]init];
                    recharge.isRechage = [model.coin.name isEqualToString:@"USDT"];
                    recharge.model = model;
                    [strongSelf.navigationController pushViewController:recharge animated:YES];
                }
            }
                break;
            case 1://转账
            {
                if ([model.coin.name isEqualToString:@"USDT"]) {
                    if (!model.coin.canWithdraw) {
                        [self.view makeToast:LocalizationKey(@"当前不可提现") duration:ToastHideDelay position:ToastPosition];return;
                    }
                    BTAssetsWithdrawVC *withdraw = [[BTAssetsWithdrawVC alloc]init];
                    withdraw.unit = model.coin.unit;
                    [strongSelf.navigationController pushViewController:withdraw animated:YES];
                }else{
                    if (!model.coin.canTransfer) {
                        [self.view makeToast:LocalizationKey(@"当前不可转账") duration:ToastHideDelay position:ToastPosition];return;
                    }
                    BTAssetsTransiferVC *transfer = [[BTAssetsTransiferVC alloc]init];
                    [strongSelf.navigationController pushViewController:transfer animated:YES];
                }
            }
                break;
            case 2://划转
            {
                if ([model.coin.name isEqualToString:@"USDT"]) {
                    if (!model.coin.canTransfer) {
                        [self.view makeToast:LocalizationKey(@"当前不可转账") duration:ToastHideDelay position:ToastPosition];return;
                    }
                    BTAssetsTransiferVC *transfer = [[BTAssetsTransiferVC alloc]init];
                    [strongSelf.navigationController pushViewController:transfer animated:YES];
                }else{
                    if (!model.coin.canTransfer) {
                        [self.view makeToast:LocalizationKey(@"当前不可划转") duration:ToastHideDelay position:ToastPosition];return;
                    }
                    BTSweepAccountVC *sweep = [[BTSweepAccountVC alloc]init];
                    [strongSelf.navigationController pushViewController:sweep animated:YES];
                }
            }
                break;
            default:
                break;
        }
    };
    cell.assetsDetailAction = ^{
        StrongSelf(strongSelf)
        BTAssetsDetailVC *detail = [[BTAssetsDetailVC alloc]init];
        detail.assetsModel = model;
        [strongSelf.navigationController pushViewController:detail animated:YES];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 146.f;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
