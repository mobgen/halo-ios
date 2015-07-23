//
//  ViewController.m
//  HaloObjCDemo
//
//  Created by Borja Santos-Díez on 17/06/15.
//  Copyright (c) 2015 MOBGEN Technology. All rights reserved.
//

#import "HALMainViewController.h"
#import "HALMainView.h"

@interface HALMainViewController ()

@end

@implementation HALMainViewController

- (void)loadView {
    [super loadView];
    
    self.view = [HALMainView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
