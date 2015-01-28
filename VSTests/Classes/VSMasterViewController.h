//
//  VSMasterViewController.h
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSDetailViewController;
@class VSTestCase;

@interface VSMasterViewController : UITableViewController

@property (strong, nonatomic) VSDetailViewController *detailViewController;

@end
