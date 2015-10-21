//
//  NZAddBankCardViewController.h
//  nazhe
//
//  Created by WSGG on 15/10/19.
//  Copyright (c) 2015年 YJJ. All rights reserved.
//

#import "NZViewController.h"

@interface NZAddBankCardViewController : NZViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;

@property (weak, nonatomic) IBOutlet UITextField *userBankBeachField;

@property (weak, nonatomic) IBOutlet UITextField *userBankNumField;

@property (weak, nonatomic) IBOutlet UITextField *userBankNumComfirField;
@property (weak, nonatomic) IBOutlet UIButton *bankCardType1;
@property (weak, nonatomic) IBOutlet UIButton *bankCardType2;
@property (weak, nonatomic) IBOutlet UIView *operateView;

@property (weak, nonatomic) IBOutlet UILabel *editLab;

@property (weak, nonatomic) IBOutlet UIImageView *editImgView;


//银行卡操作类型
@property (assign,nonatomic) enumtBankOperateType bankOperateType;
@property (strong,nonatomic) NSMutableArray *bankArry;//银行信息
@property (strong,nonatomic) NSDictionary *myBankCardDict;//银行卡里的信息
@property (assign,nonatomic) int bankCardId;//银行卡的ID
@property (assign,nonatomic) BOOL isEdit;//是否可以编辑
@property (strong,nonatomic) NSString *myBankStr;
@property (strong,nonatomic) NSString *myBankTypeStr;
@property (strong,nonatomic) UIView *pickViewBackView;
@property (strong,nonatomic) UIPickerView *bankPicker;

@end
