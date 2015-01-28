//
//  TFMasterViewController.m
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import "TFMasterViewController.h"
#import "TFDetailViewController.h"
#import "VSTestCase.h"
#import "TFElapsedSpeedTestCase.h"
#import "TFTestResult.h"
#import "Utilities.m"

@interface TFMasterViewController ()

@property (nonatomic, strong) NSArray *tests;

- (void)loadTests;

@end

@implementation TFMasterViewController

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Tests";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self loadTests];
}

- (void)loadTests
{
    NSArray *testSubclasses = ClassGetSubclasses([VSTestCase class]);
    NSArray *concreteSubclasses = @[[TFElapsedSpeedTestCase class]];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
    {
        return ![concreteSubclasses containsObject:[evaluatedObject class]];
    }];
    
    NSArray *userTestClasses = [testSubclasses filteredArrayUsingPredicate: predicate];
    NSMutableArray *userTestObjects = [[NSMutableArray alloc] init];
    
    [userTestClasses enumerateObjectsUsingBlock:^(Class test, NSUInteger idx, BOOL *stop)
    {
        [userTestObjects addObject:[test test]];
    }];
    
    self.tests = [userTestObjects copy];
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.tests.count == 0) ? 1 : self.tests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if (self.tests.count > 0)
    {
        VSTestCase *object = self.tests[indexPath.row];
        cell.textLabel.text = object.title;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else
    {
        cell.textLabel.text = @"No Tests Avaliable.";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSTestCase *test = self.tests[indexPath.row];
    
    if (!test.result.resultReady)
    {
        [test runWithNIterations:ITERATIONS completion:^
        {
            self.detailViewController.testResult = test.result;
        }];
    }
}

@end
