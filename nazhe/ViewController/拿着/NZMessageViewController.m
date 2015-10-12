//
//  NZMessageViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/5.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZMessageViewController.h"
#import "MessageNumberModel.h"
#import "NZDynamicViewController.h"

@interface NZMessageViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    enumtMessageType messageType;
    MessageNumberModel *messageModel;
    
    CGFloat leftFloat;
    CGFloat rightFloat;
    
    NSArray *iconArray;
    NSArray *nameArray;
}

@property (strong, nonatomic) IBOutlet UIView *indicateBackView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *indicateArrowLeftConstraint;
@property (strong, nonatomic) IBOutlet UILabel *systemMessageLab;
@property (strong, nonatomic) IBOutlet UILabel *messageCollectionLab;

- (IBAction)systemMessageClick:(UIButton *)sender;
- (IBAction)messageCollectionClick:(UIButton *)sender;

@end

@implementation NZMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    messageType = enumtMessageType_SystemMessage; // 系统消息
    
    iconArray = @[@"账户",@"积分",@"交易",@"尊享",@"系统"];
    nameArray = @[@"账户动态",@"积分动态",@"交易提醒",@"尊享活动",@"系统通知"];
    
    [self createNavigationItemTitleViewWithTitle:@"信息"];
    [self leftButtonTitle:nil];
    
    _indicateBackView.backgroundColor = toolBarColor;
    
    leftFloat = (ScreenWidth - 1) / 4 - 5;
    rightFloat = (ScreenWidth - 1) / 4 * 3 + 1 - 5;
    _indicateArrowLeftConstraint.constant = leftFloat;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self requestDataWithMessageType:messageType];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (messageType == enumtMessageType_SystemMessage) {
        return 5;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    
    if (messageType == enumtMessageType_SystemMessage) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZSystemMessageTypeCellIdentify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZSystemMessageTypeCellIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*20/375, ScreenWidth*15/375, ScreenWidth*45/375, ScreenWidth*45/375)];
        [cell.contentView addSubview:icon];
        
        UILabel *messageTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+ScreenWidth*25/375, ScreenWidth*25/375, 80, ScreenWidth*25/375)];
        messageTypeLab.font = [UIFont systemFontOfSize:15.f];
        [cell.contentView addSubview:messageTypeLab];
        
        UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*40/375-60, ScreenWidth*25/375, 60, ScreenWidth*25/375)];
        numberLab.textColor = [UIColor grayColor];
        numberLab.font = [UIFont systemFontOfSize:13.f];
        numberLab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:numberLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth*75/375, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
        
        icon.image = [UIImage imageNamed:iconArray[indexPath.row]];
        messageTypeLab.text = nameArray[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                numberLab.text = [NSString stringWithFormat:@"%d条未读",messageModel.countDynamic];
                break;
            case 1:
                numberLab.text = [NSString stringWithFormat:@"%d条未读",messageModel.countScorer];
                break;
            case 2:
                numberLab.text = [NSString stringWithFormat:@"%d条未读",messageModel.countTrading];
                break;
            case 3:
                numberLab.text = [NSString stringWithFormat:@"%d条未读",messageModel.countActivity];
                break;
            case 4:
                numberLab.text = [NSString stringWithFormat:@"%d条未读",messageModel.countNotice];
                break;
            default:
                break;
        }
        
        return cell;
        
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZMessageCollectionTypeCellIdentify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZMessageCollectionTypeCellIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*20/375, ScreenWidth*15/375, ScreenWidth*45/375, ScreenWidth*45/375)];
        [cell.contentView addSubview:icon];
        
        UILabel *messageTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+ScreenWidth*25/375, ScreenWidth*25/375, 80, ScreenWidth*25/375)];
        messageTypeLab.font = [UIFont systemFontOfSize:15.f];
        [cell.contentView addSubview:messageTypeLab];
        
        UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*40/375-60, ScreenWidth*25/375, 60, ScreenWidth*25/375)];
        numberLab.textColor = [UIColor grayColor];
        numberLab.font = [UIFont systemFontOfSize:13.f];
        numberLab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:numberLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth*75/375, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
        
        if (indexPath.row == 1) {
            icon.image = [UIImage imageNamed:@"尊享"];
            messageTypeLab.text = @"尊享活动";
            numberLab.text = [NSString stringWithFormat:@"%d条收藏",messageModel.countActivity];
        } else {
            icon.image = [UIImage imageNamed:@"聊天"];
            messageTypeLab.text = @"好友聊天";
            numberLab.text = [NSString stringWithFormat:@"%d条收藏",messageModel.countChat];
        }
        
        return cell;
    }
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth*75/375+0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (messageType == enumtMessageType_SystemMessage) {
        NZDynamicViewController *dynamicVCTR = [[NZDynamicViewController alloc] init];
        if (indexPath.row == 0) {
            dynamicVCTR.dynamicType = enumtDynamicType_Account;
        } else if (indexPath.row == 1) {
            dynamicVCTR.dynamicType = enumtDynamicType_Integral;
        } else if (indexPath.row == 2) {
            dynamicVCTR.dynamicType = enumtDynamicType_Trading;
        } else if (indexPath.row == 3) {
            return;
        } else if (indexPath.row == 4) {
            dynamicVCTR.dynamicType = enumtDynamicType_Notice;
        }
        [self.navigationController pushViewController:dynamicVCTR animated:YES];
    }
    
}

#pragma mark 请求未读数据
- (void)requestDataWithMessageType:(enumtMessageType)type {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId,
                                 @"type":[NSNumber numberWithInt:type]
                                 } ;
    
    [handler postURLStr:webNoReadMessage postDic:parameters
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
             messageModel = [MessageNumberModel objectWithKeyValues:retInfo[@"detail" ]];
             
             [_tableView reloadData];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

- (IBAction)systemMessageClick:(UIButton *)sender {
    messageType = enumtMessageType_SystemMessage;
    
    _indicateArrowLeftConstraint.constant = leftFloat;
    
    _systemMessageLab.textColor = [UIColor blackColor];
    _messageCollectionLab.textColor = [UIColor grayColor];
    
    [self requestDataWithMessageType:messageType];
}

- (IBAction)messageCollectionClick:(UIButton *)sender {
    
    messageType = enumtMessageType_MessageCollection;
    
    _indicateArrowLeftConstraint.constant = rightFloat;
    
    _systemMessageLab.textColor = [UIColor grayColor];
    _messageCollectionLab.textColor = [UIColor blackColor];
    
    [self requestDataWithMessageType:messageType];
}
@end
