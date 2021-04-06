//
//  AViewController.m
//  AAlertViewController
//
//  Created by 王纯志 on 04/06/2021.
//  Copyright (c) 2021 王纯志. All rights reserved.
//

#import "AViewController.h"
#import "AAlertViewController.h"

@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self showAlertWithTitle:@"标题" message:@"内容" messageAttributes:@{NSForegroundColorAttributeName:UIColor.redColor} image:nil appearanceProcess:^(AAlertViewController * _Nonnull alertMaker) {
        alertMaker.addDefaultTitle(@"确定", UIColor.blackColor);
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, AAlertViewController * _Nonnull alertSelf) {
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
