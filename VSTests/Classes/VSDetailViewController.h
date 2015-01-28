//
//  VSDetailViewController.h
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "VSTestResult.h"

@interface VSDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) VSTestResult *testResult;

@end
