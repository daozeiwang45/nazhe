//
//  NZProtocolViewController.m
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/14.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZProtocolViewController.h"

@interface NZProtocolViewController ()

@end

@implementation NZProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItemTitleViewWithTitle:@"用户协议"];
    [self leftButtonTitle:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:scrollView];
    
    UIFont *contentFont = [UIFont systemFontOfSize:13.f];
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, ScreenWidth, 15)];
    title1.text = @"【审慎阅读】";
    title1.textColor = [UIColor grayColor];
    title1.font = contentFont;
    title1.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:title1];
    
    NSString *content1 = @"       您在各操作流程中点击同意协议之前，应当认真阅读该协议。请您务必审慎阅读、充分理解各条款内容，特别是免除或者限制责任的条款、法律适用和争议解决条款。免除或者限制责任的条款将以粗体下划线标识，您应重点阅读。如您对协议有任何疑问，可向拿着平台客服咨询。";
    NSDictionary *attribute = @{NSFontAttributeName:contentFont};
    CGSize limitSize = CGSizeMake(ScreenWidth-80, MAXFLOAT);
    // 计算提问内容的尺寸
    CGSize contentSize1 = [content1 boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    UILabel *contentLab1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 60, contentSize1.width, contentSize1.height)];
    contentLab1.text = content1;
    contentLab1.textColor = [UIColor grayColor];
    contentLab1.font = contentFont;
    contentLab1.numberOfLines = 0;
    [scrollView addSubview:contentLab1];
    
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLab1.frame)+25, ScreenWidth, 15)];
    title2.text = @"【签约动作】";
    title2.textColor = [UIColor grayColor];
    title2.font = contentFont;
    title2.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:title2];
    
    NSString *content2 = @"       当您按照各操作页面提示填写信息、阅读并同意该协议且完成全部操作程序后，即表示您已充分阅读、理解并接受该协议的全部内容，并与拿着达成一致。阅读该协议的过程中，如果您不同意该协议或其中任何条款约定，您应立即停止操作程序。您在各操作流程中点击同意协议之前，应当认真阅读该协议。请您务必审慎阅读、充分理解各条款内容，特别是免除或者限制责任的条款、法律适用和争议解决条款。免除或者限制责任的条款将以粗体下划线标识，您应重点阅读。如您对协议有任何疑问，可向拿着平台客服咨询。您在各操作流程中点击同意协议之前，应当认真阅读该协议。请您务必审慎阅读、充分理解各条款内容，特别是免除或者限制责任的条款、法律适用和争议解决条款。免除或者限制责任的条款将以粗体下划线标识，您应重点阅读。如您对协议有任何疑问，可向拿着平台客服咨询。您在各操作流程中点击同意协议之前，应当认真阅读该协议。请您务必审慎阅读、充分理解各条款内容，特别是免除或者限制责任的条款、法律适用和争议解决条款。免除或者限制责任的条款将以粗体下划线标识，您应重点阅读。如您对协议有任何疑问，可向拿着平台客服咨询。";
    // 计算提问内容的尺寸
    CGSize contentSize2 = [content2 boundingRectWithSize:limitSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    UILabel *contentLab2 = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(title2.frame)+10, contentSize2.width, contentSize2.height)];
    contentLab2.text = content2;
    contentLab2.textColor = [UIColor grayColor];
    contentLab2.font = contentFont;
    contentLab2.numberOfLines = 0;
    [scrollView addSubview:contentLab2];
    
    scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(contentLab2.frame)+10);
}

@end
