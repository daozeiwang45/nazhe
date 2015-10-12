//
//  NZCustomerServiceViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/6.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZCustomerServiceViewController.h"
#import "NZDownArrowView.h"
#import "QRadioButton.h"
#import "NZReplyViewCell.h"
#import "NZReplyViewModel.h"
#import "ServiceHelpModel.h"

@interface NZCustomerServiceViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, QRadioButtonDelegate> {
    UIScrollView *serviceScrollView;
    CGFloat imgWidth;
    CGFloat bigSpace;
    CGFloat smallSpace;
    CGFloat endFloat;
    
    UIView *firstView;
    UIImageView *walletImage;
    UILabel *walletLabel;
    
    UIView *secondView;
    UIImageView *integralImage;
    UILabel *integralLabel;

    UIView *thirdView;
    UIImageView *privilegeImage;
    UILabel *privilegeLabel;
    
    UIView *fourthView;
    UIImageView *serviceImage;
    UILabel *serviceLabel;
    
    UIView *fifthView;
    UIImageView *orderImage;
    UILabel *orderLabel;
    
    NSMutableArray *answerLabHeight;
    BOOL expand;
    int selectIndex;
    NSIndexPath *selectIndexPath;
    
    int currentIndex; // 当前选中帮助类型
    enumtHelpType helpType; // 当前选中帮助类型
    NSMutableArray *walletArray; // 钱包数组
    NSMutableArray *integralArray; // 积分数组
    NSMutableArray *privilegeArray; // 特权数组
    NSMutableArray *customerServiceArray; // 售后数组
    NSMutableArray *orderArray; // 订单数组
    
    int currentMessageType; // 当前留言类型
    
}

@property (strong, nonatomic) IBOutlet NZDownArrowView *indicator;
@property (strong, nonatomic) IBOutlet UILabel *helpLab;
@property (strong, nonatomic) IBOutlet UILabel *messageLab;
@property (strong, nonatomic) IBOutlet UILabel *replyLab;

@property (strong, nonatomic) IBOutlet UIView *helpView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *frameView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *centerView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UITextField *messageTitleField; // 留言标题
@property (strong, nonatomic) IBOutlet UITextView *messageTextView; // 留言内容
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLab;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;

@property (strong, nonatomic) IBOutlet UITableView *replyTableView;

/********  回复的视图模型数组  **********/
@property (nonatomic, strong) NSMutableArray *replyFrames;

- (IBAction)helpAction:(UIButton *)sender;
- (IBAction)messageAction:(UIButton *)sender;
- (IBAction)replyAction:(UIButton *)sender;

// 留言视图的事件
- (IBAction)sendMessage:(UIButton *)sender; // 留言
- (IBAction)callService:(UIButton *)sender; // 拨打给客服

@end

@implementation NZCustomerServiceViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _replyFrames = [NSMutableArray array];
        
        walletArray = [NSMutableArray array]; // 钱包数组
        integralArray = [NSMutableArray array]; // 积分数组
        privilegeArray = [NSMutableArray array]; // 特权数组
        customerServiceArray = [NSMutableArray array]; // 售后数组
        orderArray = [NSMutableArray array]; // 订单数组
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationItemTitleViewWithTitle:@"客服"];
    [self leftButtonTitle:nil];
    
    [self initHelpView];
    [self initMessageView];
    [self initReplyTableView];
    [self requestServiceHelpData]; // 请求数据
    
    _messageView.hidden = YES;
    _replyTableView.hidden = YES;
}

#pragma mark 初始化帮助视图
- (void)initHelpView {
    expand = NO;
    selectIndex = -1;
    
    currentIndex = 2; // 关于特权
    helpType = enumtHelpType_Privilege; // 关于特权
    
    _leftConstraint.constant = ScreenWidth * 113 / 375;
    _rightConstraint.constant = ScreenWidth * 113 / 375;
    
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    _pageControl.userInteractionEnabled = NO;
    
    [self initScrollView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = UIDefaultBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initScrollView {
    imgWidth = ScreenWidth * 70.f/375.f;
    bigSpace = ScreenWidth * 40.f/375.f;
    smallSpace = ScreenWidth * 21.f/375.f;
    
    serviceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 15, ScreenWidth, 100.f+_frameView.frame.size.height * 18 / 157)];
    [_helpView addSubview:serviceScrollView];
//    [serviceScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_frameView.mas_top);
//        make.height.mas_equalTo(100.f+_frameView.frame.size.height * 18 / 157);;
//        make.left.equalTo(self.view.mas_left);
//        make.width.mas_equalTo(ScreenWidth);
//    }];
    serviceScrollView.contentSize = CGSizeMake((imgWidth + bigSpace + smallSpace) * 5 + (smallSpace + imgWidth + (bigSpace + smallSpace) / 2) * 2, 100.f);
    serviceScrollView.delegate = self;
    serviceScrollView.showsHorizontalScrollIndicator = NO;
    serviceScrollView.decelerationRate = 0.5f;
    serviceScrollView.contentOffset = CGPointMake(smallSpace + imgWidth + (bigSpace + smallSpace) / 2 + (bigSpace + smallSpace) / 2 + imgWidth + bigSpace, 0);
    
    /***************************第一个*********************************/
    firstView = [[UIView alloc] initWithFrame:CGRectMake(smallSpace + imgWidth + (bigSpace + smallSpace) / 2, 0, imgWidth + bigSpace + smallSpace, 100.f+_frameView.frame.size.height * 18 / 157)];
    firstView.tag = 1000;
    [serviceScrollView addSubview:firstView];
    
    walletImage = [[UIImageView alloc] init];
    walletImage.image = [UIImage imageNamed:@"帮助1-线"];
    walletImage.tag = 100;
    [firstView addSubview:walletImage];
    [walletImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstView.mas_top).with.offset(_frameView.frame.size.height * 18 / 157);
        make.height.mas_equalTo(71.f);;
        make.centerX.equalTo(firstView.mas_centerX);
        make.width.mas_equalTo(71.f);
    }];
    
    walletLabel = [[UILabel alloc] init];
    walletLabel.text = @"关于钱包";
    walletLabel.textColor = [UIColor grayColor];
    walletLabel.textAlignment = NSTextAlignmentCenter;
    walletLabel.font = [UIFont systemFontOfSize:15.f];
    [firstView addSubview:walletLabel];
    [walletLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(firstView.mas_bottom);
        make.height.mas_equalTo(15.f);;
        make.centerX.equalTo(firstView.mas_centerX);
        make.width.mas_equalTo(firstView.width);
    }];
    /***************************第二个*********************************/
    secondView = [[UIView alloc] initWithFrame:CGRectMake(smallSpace + imgWidth + (bigSpace + smallSpace) / 2 + (imgWidth + bigSpace + smallSpace), 0, imgWidth + bigSpace + smallSpace, 100.f+_frameView.frame.size.height * 18 / 157)];
    secondView.tag = 1001;
    [serviceScrollView addSubview:secondView];
    
    integralImage = [[UIImageView alloc] init];
    integralImage.image = [UIImage imageNamed:@"帮助2-线"];
    integralImage.tag = 101;
    [secondView addSubview:integralImage];
    [integralImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondView.mas_top).with.offset(_frameView.frame.size.height * 18 / 157);
        make.height.mas_equalTo(71.f);;
        make.centerX.equalTo(secondView.mas_centerX);
        make.width.mas_equalTo(71.f);
    }];
    
    integralLabel = [[UILabel alloc] init];
    integralLabel.text = @"关于积分";
    integralLabel.textColor = [UIColor grayColor];
    integralLabel.textAlignment = NSTextAlignmentCenter;
    integralLabel.font = [UIFont systemFontOfSize:15.f];
    [secondView addSubview:integralLabel];
    [integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(secondView.mas_bottom);
        make.height.mas_equalTo(15.f);;
        make.centerX.equalTo(secondView.mas_centerX);
        make.width.mas_equalTo(secondView.width);
    }];
    /***************************第三个*********************************/
    thirdView = [[UIView alloc] initWithFrame:CGRectMake(smallSpace + imgWidth + (bigSpace + smallSpace) / 2 + (imgWidth + bigSpace + smallSpace) * 2, 0, imgWidth + bigSpace + smallSpace, 100.f+_frameView.frame.size.height * 18 / 157)];
    thirdView.tag = 1002;
    [serviceScrollView addSubview:thirdView];
    
    privilegeImage = [[UIImageView alloc] init];
    privilegeImage.image = [UIImage imageNamed:@"帮助3-实"];
    privilegeImage.tag = 102;
    [thirdView addSubview:privilegeImage];
    [privilegeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdView.mas_top).with.offset(_frameView.frame.size.height * 4 / 157);
        make.height.mas_equalTo(99.f);;
        make.centerX.equalTo(thirdView.mas_centerX);
        make.width.mas_equalTo(99.f);
    }];
    
    privilegeLabel = [[UILabel alloc] init];
    privilegeLabel.text = @"关于特权";
    privilegeLabel.textColor = [UIColor grayColor];
    privilegeLabel.textAlignment = NSTextAlignmentCenter;
    privilegeLabel.font = [UIFont systemFontOfSize:15.f];
    [thirdView addSubview:privilegeLabel];
    [privilegeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(thirdView.mas_bottom);
        make.height.mas_equalTo(15.f);;
        make.centerX.equalTo(thirdView.mas_centerX);
        make.width.mas_equalTo(thirdView.width);
    }];
    /***************************第四个*********************************/
    fourthView = [[UIView alloc] initWithFrame:CGRectMake((smallSpace + imgWidth + (bigSpace + smallSpace) / 2) + (imgWidth + bigSpace + smallSpace) * 3, 0, imgWidth + bigSpace + smallSpace, 100.f+_frameView.frame.size.height * 18 / 157)];
    fourthView.tag = 1003;
    [serviceScrollView addSubview:fourthView];
    
    serviceImage = [[UIImageView alloc] init];
    serviceImage.image = [UIImage imageNamed:@"帮助4-线"];
    serviceImage.tag = 103;
    [fourthView addSubview:serviceImage];
    [serviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fourthView.mas_top).with.offset(_frameView.frame.size.height * 18 / 157);
        make.height.mas_equalTo(71.f);;
        make.centerX.equalTo(fourthView.mas_centerX);
        make.width.mas_equalTo(71.f);
    }];
    
    serviceLabel = [[UILabel alloc] init];
    serviceLabel.text = @"关于售后";
    serviceLabel.textColor = [UIColor grayColor];
    serviceLabel.textAlignment = NSTextAlignmentCenter;
    serviceLabel.font = [UIFont systemFontOfSize:15.f];
    [fourthView addSubview:serviceLabel];
    [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(fourthView.mas_bottom);
        make.height.mas_equalTo(15.f);;
        make.centerX.equalTo(fourthView.mas_centerX);
        make.width.mas_equalTo(fourthView.width);
    }];
    /***************************第五个*********************************/
    fifthView = [[UIView alloc] initWithFrame:CGRectMake((smallSpace + imgWidth + (bigSpace + smallSpace) / 2) + (imgWidth + bigSpace + smallSpace) * 4, 0, imgWidth + bigSpace + smallSpace, 100.f+_frameView.frame.size.height * 18 / 157)];
    fifthView.tag = 1004;
    [serviceScrollView addSubview:fifthView];
    
    orderImage = [[UIImageView alloc] init];
    orderImage.image = [UIImage imageNamed:@"帮助5-线"];
    orderImage.tag = 104;
    [fifthView addSubview:orderImage];
    [orderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fifthView.mas_top).with.offset(_frameView.frame.size.height * 18 / 157);
        make.height.mas_equalTo(71.f);;
        make.centerX.equalTo(fifthView.mas_centerX);
        make.width.mas_equalTo(71.f);
    }];
    
    orderLabel = [[UILabel alloc] init];
    orderLabel.text = @"关于订单";
    orderLabel.textColor = [UIColor grayColor];
    orderLabel.textAlignment = NSTextAlignmentCenter;
    orderLabel.font = [UIFont systemFontOfSize:15.f];
    [fifthView addSubview:orderLabel];
    [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(fifthView.mas_bottom);
        make.height.mas_equalTo(15.f);;
        make.centerX.equalTo(fifthView.mas_centerX);
        make.width.mas_equalTo(fifthView.width);
    }];
    
    NSLog(@"子view %ld",serviceScrollView.subviews.count);
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView]) {
        
        switch (helpType) {
            case enumtHelpType_Wallet:
                return walletArray.count;
                break;
                
            case enumtHelpType_Integral:
                return integralArray.count;
                break;
                
            case enumtHelpType_Privilege:
                return privilegeArray.count;
                break;
                
            case enumtHelpType_Order:
                return orderArray.count;
                break;
                
            case enumtHelpType_CustomerService:
                return customerServiceArray.count;
                break;
                
            default:
                return 0;
                break;
        }
        
    } else {
        return _replyFrames.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_tableView]) {
        
        ServiceHelpInfoModel *helpInfo;
        NSString *identify;
        NSString *expendIdentify;
        
        switch (helpType) {
            case enumtHelpType_Wallet:
                helpInfo = walletArray[indexPath.row];
                identify = NZHelpWalletCellIdentify;
                expendIdentify = NZHelpWalletExpendCellIdentify;
                break;
                
            case enumtHelpType_Integral:
                helpInfo = integralArray[indexPath.row];
                identify = NZHelpIntegralCellIdentify;
                expendIdentify = NZHelpIntegralExpendCellIdentify;
                break;
                
            case enumtHelpType_Privilege:
                helpInfo = privilegeArray[indexPath.row];
                identify = NZHelpPrivilegeCellIdentify;
                expendIdentify = NZHelpPrivilegeExpendCellIdentify;
                break;
                
            case enumtHelpType_Order:
                helpInfo = orderArray[indexPath.row];
                identify = NZHelpOrderCellIdentify;
                expendIdentify = NZHelpOrderExpendCellIdentify;
                break;
                
            case enumtHelpType_CustomerService:
                helpInfo = customerServiceArray[indexPath.row];
                identify = NZHelpCustomerServiceCellIdentify;
                expendIdentify = NZHelpCustomerServiceExpendCellIdentify;
                break;
                
            default:
                break;
        }
        
        if (indexPath.row == selectIndex) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:expendIdentify];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            UILabel *questionLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*25/375, 0, ScreenWidth - ScreenWidth*50/375, 39)];
            questionLab.textColor = [UIColor blackColor];
            questionLab.font = [UIFont systemFontOfSize:15.f];
            questionLab.text = helpInfo.title;
            [cell.contentView addSubview:questionLab];
            
            UIImageView *downArrow = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - ScreenWidth*25/375-16, 15.5, 16, 8)];
            downArrow.image = [UIImage imageNamed:@"钱包下键"];
            [cell.contentView addSubview:downArrow];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*25/375, 39, ScreenWidth - ScreenWidth*50/375, 1)];
            line.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:line];
            
            // 字符串
            NSString *str = helpInfo.content;
            // 初始化label
            UILabel *answerLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*25/375, 44, ScreenWidth - ScreenWidth*50/375, 56)];;
            // label获取字符串
            answerLab.text = str;
            answerLab.textColor = [UIColor grayColor];
            // label获取字体
            answerLab.font = [UIFont fontWithName:@"Arial" size:12];
            // 设置无限换行
            answerLab.numberOfLines = 0;
            
            answerLab.lineBreakMode = NSLineBreakByCharWrapping;
            
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Arial" size:12]};
            // 根据获取到的字符串以及字体计算label需要的size
            CGSize size = [str boundingRectWithSize:CGSizeMake(ScreenWidth - ScreenWidth*50/375, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            
            // 设置label的frame
            answerLab.frame = CGRectMake(ScreenWidth*25/375, 44, size.width, size.height);
            
            [cell.contentView addSubview:answerLab];
            
            return cell;
            
        } else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:expendIdentify];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            UILabel *questionLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*25/375, 0, ScreenWidth - ScreenWidth*50/375, 39)];
            questionLab.textColor = [UIColor blackColor];
            questionLab.font = [UIFont systemFontOfSize:15.f];
            questionLab.text = helpInfo.title;
            [cell.contentView addSubview:questionLab];
            
            UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - ScreenWidth*25/375-8, 11.5, 8, 16)];
            rightArrow.image = [UIImage imageNamed:@"右箭头"];
            [cell.contentView addSubview:rightArrow];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*25/375, 39, ScreenWidth - ScreenWidth*50/375, 1)];
            line.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:line];
            return cell;
        }
    } else { // 回复tableview 的cell
        NZReplyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZReplyViewCellIdentify];
        if (cell == nil) {
            cell = [[NZReplyViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZReplyViewCellIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.replyVM = _replyFrames[indexPath.row];
        return cell;
    }
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tableView]) {
        if (indexPath.row == selectIndex) {
            ServiceHelpInfoModel *helpInfo;
            switch (helpType) {
                case enumtHelpType_Wallet:
                    helpInfo = walletArray[indexPath.row];
                    break;
                    
                case enumtHelpType_Integral:
                    helpInfo = integralArray[indexPath.row];
                    break;
                    
                case enumtHelpType_Privilege:
                    helpInfo = privilegeArray[indexPath.row];
                    break;
                    
                case enumtHelpType_Order:
                    helpInfo = orderArray[indexPath.row];
                    break;
                    
                case enumtHelpType_CustomerService:
                    helpInfo = customerServiceArray[indexPath.row];
                    break;
                    
                default:
                    break;
            }
            // 字符串
            NSString *str = helpInfo.content;
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Arial" size:12]};
            // 根据获取到的字符串以及字体计算label需要的size
            CGSize size = [str boundingRectWithSize:CGSizeMake(ScreenWidth - ScreenWidth*50/375, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            //        CGFloat labelHeight = [answerLabHeight[indexPath.row] floatValue];;
            return 44 + size.height + 10;
        } else {
            return 44.f;
        }
    } else { // 回复tableView
        NZReplyViewModel *replyVM = _replyFrames[indexPath.row];
        return CGRectGetMaxY(replyVM.replyContentFrame) + 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_tableView]) {
        if (expand) {
            if (selectIndex == (int)indexPath.row) {
                selectIndex = -1;
                selectIndexPath = nil;
                expand = NO;
//                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [_tableView reloadData];
                return;
            } else {
                selectIndex = (int)indexPath.row;
//                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, selectIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                [_tableView reloadData];
                selectIndexPath = indexPath;
                
                return;
            }
        } else {
            selectIndex = (int)indexPath.row;
//            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, selectIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [_tableView reloadData];
            selectIndexPath = indexPath;
            expand = YES;
        }
    }
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentOffset = scrollView.contentOffset.x;
    // 手指向左滑
    if(endFloat < currentOffset)
    {
        if (currentIndex == 5) {
            return;
        } else {
            CGFloat rightFrameSet = currentOffset + (imgWidth+bigSpace+smallSpace)*2-ScreenWidth*10/375;
            UIView *view = (UIView *)[serviceScrollView viewWithTag:(1000 + currentIndex)];
           
            if (view.centerX < rightFrameSet) {
                
                for (int i = 0; i < 5; i++) {
                    UIImageView *imageV = (UIImageView *)[serviceScrollView viewWithTag:(100 + i)];
                    if (currentIndex == i) {
                        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"帮助%d-实", i + 1]];
                    } else {
                        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"帮助%d-线", i + 1]];
                    }
                    
                }
                _pageControl.currentPage = currentIndex;
                currentIndex += 1;
            }
        }
    }
    
    // 手指向右滑
    if(endFloat > currentOffset)
    {
        if (currentIndex == 1) {
            return;
        } else {
            CGFloat leftFrameSet = currentOffset + imgWidth+smallSpace*2+ScreenWidth*10/375;
            UIView *view = (UIView *)[serviceScrollView viewWithTag:(1000 + currentIndex-2)];
            
            if (view.centerX > leftFrameSet) {
                
                for (int i = 0; i < 5; i++) {
                    UIImageView *imageV = (UIImageView *)[serviceScrollView viewWithTag:(100 + i)];
                    if (currentIndex-2 == i) {
                        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"帮助%d-实", i + 1]];
                    } else {
                        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"帮助%d-线", i + 1]];
                    }
                    
                }
                _pageControl.currentPage = currentIndex-2;
                currentIndex -= 1;
            }
        }
    }
    endFloat = currentOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self fixContentOffset:currentIndex-1];
    selectIndex = -1;
    selectIndexPath = nil;
    expand = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self fixContentOffset:currentIndex-1];
        selectIndex = -1;
        selectIndexPath = nil;
        expand = NO;
    }
}

- (void)fixContentOffset:(int)index {
    switch (index) {
        case 0: // 关于钱包
            [serviceScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            helpType = enumtHelpType_Wallet;
            [_tableView reloadData];
            break;
            
        case 1: // 关于积分
            [serviceScrollView setContentOffset:CGPointMake(imgWidth+bigSpace+smallSpace, 0) animated:YES];
            helpType = enumtHelpType_Integral;
            [_tableView reloadData];
            break;
            
        case 2: // 关于特权
            [serviceScrollView setContentOffset:CGPointMake((imgWidth+bigSpace+smallSpace)*2, 0) animated:YES];
            helpType = enumtHelpType_Privilege;
            [_tableView reloadData];
            break;
            
        case 3:
            [serviceScrollView setContentOffset:CGPointMake((imgWidth+bigSpace+smallSpace)*3, 0) animated:YES];
            helpType = enumtHelpType_CustomerService;
            [_tableView reloadData];
            break;
            
        case 4:
            [serviceScrollView setContentOffset:CGPointMake((imgWidth+bigSpace+smallSpace)*4, 0) animated:YES];
            helpType = enumtHelpType_Order;
            [_tableView reloadData];
            break;
            
        default:
            break;
    }
}

#pragma mark 初始化留言视图
- (void)initMessageView {
    currentMessageType = 0; // 疑问
    
    _bottomView.layer.cornerRadius = 4.f;
    _bottomView.layer.masksToBounds = YES;
    
    _centerView.layer.cornerRadius = 4.f;
    _centerView.layer.masksToBounds = YES;
    
    _topView.layer.cornerRadius = 4.f;
    _topView.layer.masksToBounds = YES;
    _topView.layer.borderWidth = 0.5f;
    _topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _messageTitleField.delegate = self;
    _messageTextView.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeholderClick:)];
    tapGesture.numberOfTapsRequired = 1;
    [_placeHolderLab addGestureRecognizer:tapGesture];
    
    /**************************    单选框    *****************************/
    QRadioButton *radio1 = [[QRadioButton alloc]initWithDelegate:self groupId:@"message"];
    radio1.delegate = self;
    [_topView addSubview:radio1];
    [radio1 setTitle:@"疑问" forState:UIControlStateNormal];
    [radio1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
    [radio1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_messageTextView.mas_bottom).with.offset(5);
        make.bottom.equalTo(_submitBtn.mas_top).with.offset(-5);
        make.left.equalTo(_topView.mas_left).with.offset(20);
        make.width.mas_equalTo((ScreenWidth - 100) / 4);
    }];
    [radio1 setChecked:YES];
    
    QRadioButton *radio2 = [[QRadioButton alloc]initWithDelegate:self groupId:@"message"];
    radio2.delegate = self;
    [_topView addSubview:radio2];
    [radio2 setTitle:@"意见" forState:UIControlStateNormal];
    [radio2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
    [radio2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_messageTextView.mas_bottom).with.offset(5);
        make.bottom.equalTo(_submitBtn.mas_top).with.offset(-5);
        make.left.equalTo(radio1.mas_right);
        make.width.mas_equalTo((ScreenWidth - 100) / 4);
    }];
    
    QRadioButton *radio3 = [[QRadioButton alloc]initWithDelegate:self groupId:@"message"];
    radio3.delegate = self;
    [_topView addSubview:radio3];
    [radio3 setTitle:@"建议" forState:UIControlStateNormal];
    [radio3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [radio3.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
    [radio3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_messageTextView.mas_bottom).with.offset(5);
        make.bottom.equalTo(_submitBtn.mas_top).with.offset(-5);
        make.left.equalTo(radio2.mas_right);
        make.width.mas_equalTo((ScreenWidth - 100) / 4);
    }];
    
    QRadioButton *radio4 = [[QRadioButton alloc]initWithDelegate:self groupId:@"message"];
    radio4.delegate = self;
    [_topView addSubview:radio4];
    [radio4 setTitle:@"投诉" forState:UIControlStateNormal];
    [radio4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [radio4.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
    [radio4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_messageTextView.mas_bottom).with.offset(5);
        make.bottom.equalTo(_submitBtn.mas_top).with.offset(-5);
        make.left.equalTo(radio3.mas_right);
        make.width.mas_equalTo((ScreenWidth - 100) / 4);
    }];
}
// placeholder label单击相应
- (void)placeholderClick:(UITapGestureRecognizer *)sender {
    [_messageTextView resignFirstResponder];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    
    [_messageTextView becomeFirstResponder];
    
    
    return NO;
}

#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    _messageTextView.text =  textView.text;
    if (_messageTextView.text.length == 0) {
        _placeHolderLab.hidden = NO;
    }else{
        _placeHolderLab.hidden = YES;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark QRadioButtonDelegate
-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if ([radio.titleLabel.text isEqualToString:@"疑问"]) {
        currentMessageType = 0;
    }
    if ([radio.titleLabel.text isEqualToString:@"意见"]) {
        currentMessageType = 1;
    }
    if ([radio.titleLabel.text isEqualToString:@"建议"]) {
        currentMessageType = 2;
    }
    if ([radio.titleLabel.text isEqualToString:@"投诉"]) {
        currentMessageType = 3;
    }
}

#pragma mark 初始化回复表示图
- (void)initReplyTableView {
    _replyTableView.dataSource = self;
    _replyTableView.delegate = self;
    _replyTableView.backgroundColor = UIDefaultBackgroundColor;
    _replyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark 一开始进入客服刷新帮助的特权页面
- (void)requestServiceHelpData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    [handler postURLStr:webServiceHelp postDic:nil
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
             
             // 封装数据模型
             ServiceHelpModel *helpModel = [ServiceHelpModel objectWithKeyValues:retInfo];
             
             for (int i=0; i<helpModel.list.count; i++) {
                 ServiceHelpInfoModel *help = helpModel.list[i];
                 
                 switch (help.type) {
                     case 0:
                         [walletArray addObject:help];
                         break;
                         
                     case 1:
                         [orderArray addObject:help];
                         break;
                         
                     case 2:
                         [integralArray addObject:help];
                         break;
                         
                     case 3:
                         [privilegeArray addObject:help];
                         break;
                         
                     case 4:
                         [customerServiceArray addObject:help];
                         break;
                         
                     default:
                         break;
                 }
             }
             
             [_tableView reloadData];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

#pragma mark 顶部选择按钮 点击事件
- (IBAction)helpAction:(UIButton *)sender {
    
    _indicator.centerX = ScreenWidth / 6;
    
    _helpLab.textColor = [UIColor blackColor];
    _messageLab.textColor = [UIColor grayColor];
    _replyLab.textColor = [UIColor grayColor];
    
    _helpView.hidden = NO;
    _messageView.hidden = YES;
    _replyTableView.hidden = YES;
    
}

- (IBAction)messageAction:(UIButton *)sender {
    
    _indicator.centerX = ScreenWidth / 6 * 3;
    
    _helpLab.textColor = [UIColor grayColor];
    _messageLab.textColor = [UIColor blackColor];
    _replyLab.textColor = [UIColor grayColor];
    
    _helpView.hidden = YES;
    _messageView.hidden = NO;
    _replyTableView.hidden = YES;
}

- (IBAction)replyAction:(UIButton *)sender {
    
    _indicator.centerX = ScreenWidth / 6 * 5;
    
    _helpLab.textColor = [UIColor grayColor];
    _messageLab.textColor = [UIColor grayColor];
    _replyLab.textColor = [UIColor blackColor];
    
    _helpView.hidden = YES;
    _messageView.hidden = YES;
    _replyTableView.hidden = NO;
    
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.labelText = @"请稍候..." ;
    
    NZUser *user = [NZUserManager sharedObject].user ;
    
    NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
    
    NSDictionary *parameters = @{
                                 @"userId":userId
                                 } ;
    
    [handler postURLStr:webServiceReply postDic:parameters
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
             
             // 封装数据模型
            ServiceReplyModel *replyModel = [ServiceReplyModel objectWithKeyValues:retInfo[@"result"]];
             
             [_replyFrames removeAllObjects];
             
             for (int i=0; i<replyModel.list.count; i++) {
                 ServiceReplyInfoModel *reply = replyModel.list[i];
                 
                 NZReplyViewModel *replyVM = [[NZReplyViewModel alloc] init];
                 replyVM.reply = reply;
                 
                 [_replyFrames addObject:replyVM];
             }
             
             [_replyTableView reloadData];
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
    
    
}

- (IBAction)sendMessage:(UIButton *)sender {

    if (_messageTitleField.text.length != 0) {
        if (_messageTextView.text.length != 0) {
            
            __weak typeof(self)wSelf = self ;
            
            NZWebHandler *handler = [[NZWebHandler alloc] init] ;
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.labelText = @"请稍候..." ;
            
            NZUser *user = [NZUserManager sharedObject].user ;
            
            NSString *userId = [NSString stringWithFormat:@"%@",user.userId] ;
            
            NSDictionary *parameters = @{
                                         @"userId":userId,
                                         @"theme":_messageTitleField.text,
                                         @"content":_messageTextView.text,
                                         @"type":[NSNumber numberWithInt:currentMessageType]
                                         } ;
            
            [handler postURLStr:webServiceMessage postDic:parameters
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
                     [wSelf.view makeToast:@"发送成功"];
                 }
                 else
                 {
                     [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
                 }
             }] ;
            
        } else {
            [self.view makeToast:@"请输入内容"];
        }
    } else {
        [self.view makeToast:@"请输入主题"];
    }
    
}

- (IBAction)callService:(UIButton *)sender {
}

@end
