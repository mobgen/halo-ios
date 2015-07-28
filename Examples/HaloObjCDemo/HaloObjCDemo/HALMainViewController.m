//
//  ViewController.m
//  HaloObjCDemo
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

#import "HALMainViewController.h"
#import <Halo/Halo-Swift.h>

@interface HALMainViewController ()

- (void) submitAction:(id)sender;

@end

@implementation HALMainViewController

@dynamic view;

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
    [HaloManager.sharedInstance authenticateWithClientId:self.view.clientId.text clientSecret:self.view.clientPass.text completionHandler:^(HaloToken * _Nullable haloToken, NSError * _Nullable error) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        if (haloToken) {
            alert.title = @"Wahey!";
            alert.message = [NSString stringWithFormat:@"Successfully authenticated!\nAccess token: %@", haloToken.token];
        } else {
            alert.title = @"Awww.. :(";
            alert.message = @"Sorry man, wrong credentials!";
        }
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

@end
