//
//  ViewController.m
//  HaloObjCDemo
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

#import "HALMainViewController.h"
#import <HaloSDK/HaloSDK-Swift.h>

@interface HALMainViewController ()

- (void) submitAction:(id)sender;

@end

@implementation HALMainViewController

- (void)loadView {
    [super loadView];
    
    self.view = [HALMainView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view.button addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitAction:(id)sender {
    
}

@end
