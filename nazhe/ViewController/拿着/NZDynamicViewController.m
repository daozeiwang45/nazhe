//
//  NZDynamicViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/23.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZDynamicViewController.h"
#import "NZMessageViewCell.h"
#import "NZMessageExpendViewCell.h"
#import "DynamicMessageModel.h"

@interface NZDynamicViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    DynamicMessageModel *dynamicMessageModel;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation NZDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.dynamicType == enumtDynamicType_Account) {
        [self createNavigationItemTitleViewWithTitle:@"账户动态"];
    } else if (self.dynamicType == enumtDynamicType_Integral) {
        [self createNavigationItemTitleViewWithTitle:@"积分动态"];
    } else if (self.dynamicType == enumtDynamicType_Trading) {
        [self createNavigationItemTitleViewWithTitle:@"交易提醒"];
    } else if (self.dynamicType == enumtDynamicType_Notice) {
        [self createNavigationItemTitleViewWithTitle:@"系统通知"];
    } else if (self.dynamicType == enumtDynamicType_Activity) {
        [self createNavigationItemTitleViewWithTitle:@"尊享活动"];
    }
    [self leftButtonTitle:nil];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self requestDynamicMessageData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dynamicMessageModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dynamicType == enumtDynamicType_Account) {
        
        NZMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZMessageViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NZMessageViewCell" owner:self options:nil] lastObject] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        DynamicMessageInfoModel *dynamicInfo = dynamicMessageModel.list[indexPath.row];
        
        cell.dynamicTypeLab.text = @"账户动态";
        cell.timeLab.text = dynamicInfo.time;
        cell.iconView.image = [UIImage imageNamed:@"账户"];
        
        NSString *totalStr = [NSString stringWithFormat:@"￥%.2f",dynamicInfo.currentAccount];
        UIFont *totalFont = [UIFont systemFontOfSize:35.f];
        NSDictionary *attribute = @{NSFontAttributeName:totalFont};
        CGSize limitSize = CGSizeMake(MAXFLOAT, 30);
        // 计算尺寸
        CGSize contentSize = [totalStr boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

        UILabel *totalNumLab = [[UILabel alloc] initWithFrame:CGRectMake(65, 65, contentSize.width, 30)];
        totalNumLab.text = totalStr;
        totalNumLab.font = totalFont;
        totalNumLab.textColor = [UIColor blackColor];
        [cell.contentView addSubview:totalNumLab];
        
        UILabel *dynamicNumLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalNumLab.frame)+5, totalNumLab.origin.y, ScreenWidth-CGRectGetMaxX(totalNumLab.frame)+5, 15)];
        if (dynamicInfo.state == 0) {
            dynamicNumLab.text = [NSString stringWithFormat:@"+￥%.2f",dynamicInfo.money];
        } else {
            dynamicNumLab.text = [NSString stringWithFormat:@"-￥%.2f",dynamicInfo.money];
        }
        dynamicNumLab.textColor = darkRedColor;
        dynamicNumLab.font = [UIFont systemFontOfSize:11.f];
        [cell.contentView addSubview:dynamicNumLab];
        
        UILabel *messageLab = [[UILabel alloc] initWithFrame:CGRectMake(dynamicNumLab.origin.x, CGRectGetMaxY(dynamicNumLab.frame), dynamicNumLab.frame.size.width, 15)];
        messageLab.text = dynamicInfo.info;
        messageLab.textColor = [UIColor blackColor];
        messageLab.font = [UIFont systemFontOfSize:11.f];
        [cell.contentView addSubview:messageLab];
        return cell;
    } else if (_dynamicType == enumtDynamicType_Integral) {
        
        NZMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZMessageViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NZMessageViewCell" owner:self options:nil] lastObject] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        DynamicMessageInfoModel *dynamicInfo = dynamicMessageModel.list[indexPath.row];
        
        cell.dynamicTypeLab.text = @"积分动态";
        cell.timeLab.text = dynamicInfo.time;
        cell.iconView.image = [UIImage imageNamed:@"积分"];
        
        NSString *totalStr = [NSString stringWithFormat:@"%d",dynamicInfo.currentScore];
        UIFont *totalFont = [UIFont systemFontOfSize:35.f];
        NSDictionary *attribute = @{NSFontAttributeName:totalFont};
        CGSize limitSize = CGSizeMake(MAXFLOAT, 30);
        // 计算尺寸
        CGSize contentSize = [totalStr boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        UILabel *totalNumLab = [[UILabel alloc] initWithFrame:CGRectMake(65, 65, contentSize.width, 30)];
        totalNumLab.text = totalStr;
        totalNumLab.font = totalFont;
        totalNumLab.textColor = [UIColor blackColor];
        [cell.contentView addSubview:totalNumLab];
        
        UILabel *dynamicNumLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalNumLab.frame)+5, totalNumLab.origin.y, ScreenWidth-CGRectGetMaxX(totalNumLab.frame)+5, 15)];
        if (dynamicInfo.state == 0) {
            dynamicNumLab.text = [NSString stringWithFormat:@"+%d",dynamicInfo.score];
        } else {
            dynamicNumLab.text = [NSString stringWithFormat:@"-%d",dynamicInfo.score];
        }
        dynamicNumLab.textColor = darkRedColor;
        dynamicNumLab.font = [UIFont systemFontOfSize:11.f];
        [cell.contentView addSubview:dynamicNumLab];
        
        UILabel *messageLab = [[UILabel alloc] initWithFrame:CGRectMake(dynamicNumLab.origin.x, CGRectGetMaxY(dynamicNumLab.frame), dynamicNumLab.frame.size.width, 15)];
        messageLab.text = dynamicInfo.info;
        messageLab.textColor = [UIColor blackColor];
        messageLab.font = [UIFont systemFontOfSize:11.f];
        [cell.contentView addSubview:messageLab];
        return cell;
    } else if (_dynamicType == enumtDynamicType_Trading) {
        
        NZMessageExpendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZMessageExpendViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NZMessageExpendViewCell" owner:self options:nil] lastObject] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        DynamicMessageInfoModel *dynamicInfo = dynamicMessageModel.list[indexPath.row];
        
        cell.tipLab.text = @"交易提醒";
        cell.timeLab.text = dynamicInfo.time;
        cell.titleLab.text = @"付款成功！";
        cell.themeLab.text = [NSString stringWithFormat:@"您的订单 %@ 已付款成功，将在48小时内发货，受到快递后请当面打开包装核验。",dynamicInfo.orderId];
        cell.contenLab.text = @"如有任何疑问，请及时联系客服。";
        cell.detailLab.text = @"订单详情";
        NSURL *imgURL = [NSURL URLWithString:[NZGlobal GetImgBaseURL:dynamicInfo.bgImg]];
        [cell.backImgView sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"orderCommodityIcon"]];
        
        return cell;
        
    } else if (_dynamicType == enumtDynamicType_Activity) {
        
        NZMessageExpendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZMessageExpendViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NZMessageExpendViewCell" owner:self options:nil] lastObject] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        DynamicMessageInfoModel *dynamicInfo = dynamicMessageModel.list[indexPath.row];
        return cell;
    } else {
        
        NZMessageExpendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZMessageExpendViewCellIdentify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NZMessageExpendViewCell" owner:self options:nil] lastObject] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        DynamicMessageInfoModel *dynamicInfo = dynamicMessageModel.list[indexPath.row];
        
        cell.tipLab.text = @"系统通知";
        cell.timeLab.text = dynamicInfo.time;
        cell.titleLab.text = dynamicInfo.title;
        cell.themeLab.text = dynamicInfo.theme;
        cell.contenLab.text = dynamicInfo.content;
        cell.detailLab.text = @"阅读详情";
        NSURL *imgURL = [NSURL URLWithString:[NZGlobal GetImgBaseURL:dynamicInfo.bgImg]];
        [cell.backImgView sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"orderCommodityIcon"]];
        
        return cell;
    }
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dynamicType == enumtDynamicType_Integral || _dynamicType == enumtDynamicType_Account) {
        return 140.f;
    } else {
        return 265.5f;
    }
}

#pragma mark 请求动态消息数据
- (void)requestDynamicMessageData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    int type;
    if (_dynamicType == enumtDynamicType_Account) {
        type = 0;
    } else if (_dynamicType == enumtDynamicType_Integral) {
        type = 1;
    } else if (_dynamicType == enumtDynamicType_Trading) {
        type = 2;
    } else if (_dynamicType == enumtDynamicType_Activity) {
        type = 3;
    } else if (_dynamicType == enumtDynamicType_Notice) {
        type = 4;
    }
    
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"type":[NSNumber numberWithInt:type]
                                 } ;
    
    [handler postURLStr:webMessageDetailList postDic:parameters
                  block:^(NSDictionary *retInfo, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:wSelf.view animated:YES] ;
         
         if( error )
         {
             [wSelf.view makeToast:@"网络错误"];
             return ;
         }
         if( retInfo == nil )
         {
             [wSelf.view makeToast:@"网络错误"];
             return ;
         }
         
         BOOL state = [[retInfo objectForKey:@"state"] boolValue] ;
         
         if( state )
         {
             dynamicMessageModel = [DynamicMessageModel objectWithKeyValues:retInfo[@"result"]];
             
             [_tableView reloadData];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

@end
