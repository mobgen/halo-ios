//
//  SampleView.m
//  HaloObjCDemo
//
//  Created by Borja Santos-Díez on 23/07/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

#import "HALMainView.h"

@interface HALMainView ()

@property (nonatomic, strong) UIImageView   *logo;

@end

@implementation HALMainView

- (nonnull instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIFont *font = [UIFont fontWithName:@"Lab-Medium" size:20];
        
        self.backgroundColor = [UIColor whiteColor];
        
        _clientId = [[UITextField alloc] initWithFrame:CGRectZero];
        _clientId.borderStyle = UITextBorderStyleLine;
        _clientId.placeholder = @"Client ID";
        _clientId.font = font;
        
        _clientPass = [[UITextField alloc] initWithFrame:CGRectZero];
        _clientPass.borderStyle = UITextBorderStyleLine;
        _clientPass.placeholder = @"Client password";
        _clientPass.font = font;
        
        _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
        _button.backgroundColor = [UIColor colorWithRed:1 green:0.5725490196 blue:0.1411764705 alpha:1];
        _button.layer.cornerRadius = 10;
        [_button setTitle:@"Submit" forState:UIControlStateNormal];
        _button.titleLabel.font = font;
        
        [self addSubview:_clientId];
        [self addSubview:_clientPass];
        [self addSubview:_logo];
        [self addSubview:_button];
    }
    
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = CGRectGetWidth(self.frame);
    
    _logo.frame = CGRectMake(w/2 - 30, 50, 60, 60);
    
    _clientId.frame = CGRectMake(40, CGRectGetMaxY(_logo.frame) + 20, w - 80, 30);
    _clientPass.frame = CGRectMake(40, CGRectGetMaxY(_clientId.frame) + 10, w - 80, 30);
    
    _button.frame = CGRectMake(40, CGRectGetMaxY(_clientPass.frame) + 20, w - 80, 40);
    
}

@end
