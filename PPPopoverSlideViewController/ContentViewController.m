//
//  ContentViewController.m
//  PPPopoverSlideViewController
//
//  Created by StarNet on 7/10/15.
//  Copyright (c) 2015 StarNet. All rights reserved.
//

#import "ContentViewController.h"
#import "PPPopoverSlideViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    
    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn1 setImage:[UIImage imageNamed:@"navigationbar_menu_icon"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"navigationbar_menu_icon_h"] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(onShowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onShowButtonPressed:(id)sender {
    [self.popoverSlideViewController presentMenuViewController];
}

@end
