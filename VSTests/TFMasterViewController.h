//
//  TFMasterViewController.h
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFDetailViewController;
@class VSTestCase;

@interface TFMasterViewController : UITableViewController

@property (strong, nonatomic) TFDetailViewController *detailViewController;

@end
