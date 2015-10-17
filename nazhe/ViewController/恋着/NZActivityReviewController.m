//
//  NZActivityReviewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/10/12.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZActivityReviewController.h"
#import "ActivityReviewModel.h"
#import "NZCommentViewModel.h"
#import "NZActivityReviewCell.h"
#import "NZLoginViewController.h"

@interface NZActivityReviewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, NZActivityReviewDelegate> {
    UITableView *reviewTableView;
    
    ActivityReviewModel *activityReviewModel; // 评论列表数据
    NSMutableArray *commentVMArray; // 评论试图模型数组
    int pageNo; // 列表请求页码
    
    UITextField *textComment; // 评论输入框
    UIButton *btnComment; // 评论按钮
    
    UIAlertView *loginAlertview;
    UIAlertView *deleteAlertview;
    int deleteIndex;
    int deleteCommentID;
    BOOL isLoginAlertview;
}

@end

@implementation NZActivityReviewController

// 初始化数据
- (instancetype)init {
    self = [super init];
    if (self) {
        commentVMArray = [NSMutableArray array];
        pageNo = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationItemTitleViewWithTitle:@"评论"];
    [self leftButtonTitle:nil];
    
    // 此界面整个就是一个表示图
    reviewTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44)];
    reviewTableView.dataSource = self;
    reviewTableView.delegate = self;
    reviewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:reviewTableView];
    
    UIView *viewFoot = [[UIView alloc] init];
    viewFoot.frame = CGRectMake(0, ScreenHeight - 44, ScreenHeight, 44);
    viewFoot.backgroundColor = BKColor;
    
    textComment = [[UITextField alloc] init];
    textComment.frame = CGRectMake(6, 6, ScreenWidth - 70, 30);
    textComment.placeholder = @"发表评论";
    textComment.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textComment setSecureTextEntry:NO];
    textComment.font = [UIFont boldSystemFontOfSize:14];
    textComment.backgroundColor = [UIColor clearColor];
    textComment.borderStyle = UITextBorderStyleRoundedRect;
    
    btnComment = [[UIButton alloc] init];
    btnComment.frame = CGRectMake(textComment.frame.origin.y + textComment.frame.size.width + 5,
                                  6,
                                  50,
                                  30);
    btnComment.backgroundColor = coffeeColor;
    [btnComment.layer setMasksToBounds:YES];
    [btnComment.layer setCornerRadius:4];
    [btnComment.layer setBorderWidth:1.0];
    [btnComment.layer setBorderColor:[[UIColor clearColor] CGColor]];
    [btnComment setTitle:@"评论" forState:UIControlStateNormal];
    btnComment.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [btnComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnComment addTarget:self action:@selector(btnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(btnComment, "friendId", [NSNumber numberWithInt:-1], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [viewFoot addSubview:btnComment];
    
    [viewFoot addSubview:textComment];
    [self.view addSubview:viewFoot];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    reviewTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    reviewTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 马上进入刷新状态
    [reviewTableView.header beginRefreshing];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commentVMArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NZCommentViewModel *commentVM = commentVMArray[indexPath.row];
    
    if ([NZGlobal isNotBlankString:commentVM.review.friendName]) {
        
        NZActivityReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZActivityFriendReviewCellIdentify];
        if (cell == nil) {
            cell = [[NZActivityReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZActivityFriendReviewCellIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.commemtVM = commentVM;
        cell.index = (int)indexPath.row;
        cell.delegate = self;
        
        return cell;
        
    } else {
        NZActivityReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:NZActivityReviewCellIdentify];
        if (cell == nil) {
            cell = [[NZActivityReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NZActivityReviewCellIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.commemtVM = commentVM;
        cell.index = (int)indexPath.row;
        cell.delegate = self;
        
        return cell;
    }
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NZCommentViewModel *commentVM = commentVMArray[indexPath.row];
    CGFloat cellHeight = CGRectGetMaxY(commentVM.reportFrame)+ScreenWidth*15/375;
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    objc_setAssociatedObject(btnComment, "friendId", [NSNumber numberWithInt:-1], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    textComment.placeholder = @"发布评论";
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        alertView = nil;
    } else {
        alertView = nil;
        if (isLoginAlertview) {
            NZLoginViewController *loginVCTR = [[NZLoginViewController alloc] init];
            [self.navigationController pushViewController:loginVCTR animated:YES];
        } else {
            __weak typeof(self)wSelf = self ;
            
            NZWebHandler *handler = [[NZWebHandler alloc] init] ;
            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            
//            hud.labelText = @"请稍候..." ;
            
            NZUser *user = [NZUserManager sharedObject].user;
            
            NSDictionary *parameters = @{
                                         @"userId":user.userId,
                                         @"commentId":[NSNumber numberWithInt:deleteCommentID]
                                         } ;
            
            [handler postURLStr:webDeleteActivityReview postDic:parameters
                          block:^(NSDictionary *retInfo, NSError *error)
             {
//                 [MBProgressHUD hideAllHUDsForView:wSelf.view animated:YES] ;
                 
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
                     [wSelf.view makeToast:@"删除成功！"];
                     [commentVMArray removeObjectAtIndex:deleteIndex];
                     [reviewTableView reloadData];
                 }
                 else
                 {
                     [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
                 }
             }] ;
        }
    }
    
}

#pragma mark NZActivityReviewDelegate
- (void)replyWithIndex:(int)index {
    
    NZCommentViewModel *commentVM = commentVMArray[index];
    
    objc_setAssociatedObject(btnComment, "friendId", [NSNumber numberWithInt:commentVM.review.friendId], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    textComment.placeholder = [NSString stringWithFormat:@"@%@", commentVM.review.NickName];
}

- (void)deleteWithIndex:(int)index {
    NZCommentViewModel *commentVM = commentVMArray[index];
    
    NZUser *user = [NZUserManager sharedObject].user;
    
    if ([[NSString stringWithFormat:@"%d",commentVM.review.friendId] isEqualToString:user.userId]) {
        
        deleteIndex = index;
        deleteCommentID = commentVM.review.commentId;
        
        deleteAlertview = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除该评论" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        isLoginAlertview = NO;
        [deleteAlertview show];
    }
}

#pragma mark 下拉刷新
- (void)loadNewData {
    pageNo = 1;
    [self requestReviewListData];
}

#pragma mark 上拉加载
- (void)loadMoreData {
    pageNo += 1;
    [self requestReviewListData];
}

#pragma mark 请求评论列表数据
- (void)requestReviewListData {
    __weak typeof(self)wSelf = self ;
    
    NZWebHandler *handler = [[NZWebHandler alloc] init] ;
    
    NSDictionary *parameters = @{
                                 @"id":[NSNumber numberWithInt:self.activityID],
                                 @"pageNo":[NSNumber numberWithInt:pageNo]
                                 } ;
    
    [handler postURLStr:webActivityReviewList postDic:parameters
                  block:^(NSDictionary *retInfo, NSError *error)
     {
         // 结束刷新
         [reviewTableView.header endRefreshing];
         [reviewTableView.footer endRefreshing];
         
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
             activityReviewModel = [ActivityReviewModel objectWithKeyValues:retInfo[@"result"]];
             
             if (pageNo == 1) {
                 [commentVMArray removeAllObjects];
             }
             
             for (int i=0 ; i<activityReviewModel.list.count; i++) {
                 NZCommentViewModel *commentVM = [[NZCommentViewModel alloc] init];
                 commentVM.review = activityReviewModel.list[i];
                 [commentVMArray addObject:commentVM];
             }
             
             [reviewTableView reloadData];
             if (pageNo == 1) {
                 reviewTableView.contentOffset = CGPointMake(0, -64);
             }
             
             if (pageNo == activityReviewModel.page_count) {
//                 [reviewTableView.footer noticeNoMoreData];
                 reviewTableView.footer.hidden = YES;
             }

             
         }
         else
         {
             [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
         }
     }] ;
}

#pragma mark 评论
- (void)btnCommentClick:(UIButton *)button {
    
    if ([textComment.text isEqualToString:@""]) {
        [self.view makeToast:@"评论不能为空"];
    } else {
        NZFastOperate *fastOpt = [NZFastOperate sharedObject];
        if (fastOpt.isLogin) {
            
            __weak typeof(self)wSelf = self ;
            
            NZWebHandler *handler = [[NZWebHandler alloc] init] ;
            
            NZUser *user = [NZUserManager sharedObject].user;
            
            int friendId = [objc_getAssociatedObject(button, "friendId") intValue];
            
            NSDictionary *parameters;
            
            if (friendId == -1 || friendId == [user.userId intValue]) {
                parameters = @{
                               @"userId":user.userId,
                               @"id":[NSNumber numberWithInt:self.activityID],
                               @"content":textComment.text
                               } ;
            } else {
                parameters = @{
                               @"userId":user.userId,
                               @"id":[NSNumber numberWithInt:self.activityID],
                               @"friendId":[NSNumber numberWithInt:friendId],
                               @"content":textComment.text
                               } ;
            }
            
            [handler postURLStr:webActivityReview postDic:parameters
                          block:^(NSDictionary *retInfo, NSError *error)
             {
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
                     [wSelf.view makeToast:@"评论成功！"];
                     pageNo = 1;
                     [self requestReviewListData];
                     
                     textComment.text = @"";
                     [textComment resignFirstResponder];
                     
                 }
                 else
                 {
                     [wSelf.view makeToast:[retInfo objectForKey:@"msg"]] ;
                 }
             }] ;
            
        } else {
            loginAlertview = [[UIAlertView alloc] initWithTitle:@"您未登录" message:@"是否现在登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
            isLoginAlertview = YES;
            [loginAlertview show];
        }
    }
}



@end
