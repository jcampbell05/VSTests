//
//  TFImageDownloadTestCase.m
//  VSTests
//
//  Created by James Campbell on 05/11/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import "TFImageBlurTestCase.h"

@interface TFImageBlurTestCase ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TFImageBlurTestCase

- (void)setUp:(VSTestContext *)context
{
    [super setUp];
    
    self.imageView = [[UIImageView alloc] init];
}

- (void)testAFNetworkingUIImageCatergory:(TFTestDoneBlock)done
{
}

@end
