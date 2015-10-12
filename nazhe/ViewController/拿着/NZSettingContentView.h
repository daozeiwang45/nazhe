//
//  NZSettingContentView.h
//  nazhe
//
//  Created by mocoo_ios1 on 15/9/2.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZSettingContentView : UIView

@property (strong, nonatomic) IBOutlet UIButton *personalBtn;

@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLab;
@property (strong, nonatomic) IBOutlet UILabel *phoneLab;
@property (strong, nonatomic) IBOutlet UILabel *recommendLab;

@property (strong, nonatomic) IBOutlet UILabel *levelLab;
@property (strong, nonatomic) IBOutlet UILabel *IDLab;
@property (strong, nonatomic) IBOutlet UILabel *areaLab;
@property (strong, nonatomic) IBOutlet UILabel *homtownLab;


@property (strong, nonatomic) IBOutlet UIButton *bankCardBtn;

@property (strong, nonatomic) IBOutlet UIButton *privacyBtn;
@property (strong, nonatomic) IBOutlet UILabel *privacyLab;

@property (strong, nonatomic) IBOutlet UIButton *passwordBtn;
@property (strong, nonatomic) IBOutlet UILabel *passwordLab;

@property (strong, nonatomic) IBOutlet UIButton *deliveryAddressBtn;
@property (strong, nonatomic) IBOutlet UILabel *deliveryAddLab;

@property (strong, nonatomic) IBOutlet UIButton *protocolBtn;

@property (strong, nonatomic) IBOutlet UIButton *cacheBtn;
@property (strong, nonatomic) IBOutlet UILabel *cacheLab;

@property (strong, nonatomic) IBOutlet UIButton *versionBtn;

@property (strong, nonatomic) IBOutlet UIButton *exitBtn;

@end
