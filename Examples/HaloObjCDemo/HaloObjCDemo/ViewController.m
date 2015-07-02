//
//  ViewController.m
//  MoMOSObjCDemo
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

#import "ViewController.h"
#import <HALOCore/HALOCore-Swift.h>
#import <HALONetworking/HALONetworking-Swift.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    HaloManager *mgr = [HaloManager sharedInstance];
    
    [mgr launch];
    
    HaloNetworking *net = (HaloNetworking *)[mgr getModule:HaloModuleTypeNetworking];
    
    [net haloModules:^(NSDictionary * __nonnull) {
        <#code#>
    } onFailure:^(NSError * __nonnull) {
        <#code#>
    }]
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
