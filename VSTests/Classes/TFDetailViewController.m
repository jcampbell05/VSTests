//
//  TFDetailViewController.m
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import "TFDetailViewController.h"
#import <CorePlot/CorePlot-CocoaTouch.h>

@interface TFDetailViewController () <CPTPlotDataSource>

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTXYGraph *graph;

- (void)removeGraph;
- (void)configureGraph;
- (void)configurePlotSpace;
- (void)configureAxis;
- (void)configureLegend;

@end

@implementation TFDetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
}


- (void)setTestResult:(TFTestResult *)testResult
{
    _testResult = testResult;
    
    [self removeGraph];
    [self configureGraph];
    [self configurePlotSpace];
    [self configureAxis];
    [self configureLegend];
}

- (void)removeGraph
{
    if (self.hostView)
    {
        [self.hostView removeFromSuperview];
        self.hostView = nil;
    }
    
    if (self.graph)
    {
        self.graph = nil;
    }
}

- (void)configureGraph
{
    [self.view addSubview: self.hostView];
    self.hostView.hostedGraph = self.graph;
}

- (void)configurePlotSpace
{
    // 1 - Create Plot Space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) self.graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    
    // 2 - Create the plots
    [self.testResult.plots enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *data, BOOL *stop)
     {
         CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
         plot.dataSource = self;
         plot.identifier = key;
         [self.graph addPlot:plot toPlotSpace:plotSpace];
         
         // 3 - Create styles and symbols
         CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
         CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
         CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
         CPTColor * plotColor = [CPTColor colorWithComponentRed:red green:green blue:blue alpha:1.0];
         
         CPTMutableLineStyle *plotLineStyle = [plot.dataLineStyle mutableCopy];
         plotLineStyle.lineWidth = 2.5;
         plotLineStyle.lineColor = plotColor;
         plot.dataLineStyle = plotLineStyle;
         
         CPTMutableLineStyle *plotSymbolLineStyle = [CPTMutableLineStyle lineStyle];
         plotSymbolLineStyle.lineColor = plotColor;
         
         CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
         plotSymbol.fill = [CPTFill fillWithColor:plotColor];
         plotSymbol.lineStyle = plotSymbolLineStyle;
         plotSymbol.size = CGSizeMake(6.0f, 6.0f);
         plot.plotSymbol = plotSymbol;
     }];
    
    //4 - Set up plot space
    [plotSpace scaleToFitPlots: self.graph.allPlots];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;
}


- (CPTGraphHostingView *)hostView
{
    if (!_hostView)
    {
        _hostView = [[CPTGraphHostingView alloc] initWithFrame: self.view.bounds];
        _hostView.allowPinchScaling = YES;
        _hostView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _hostView;
}

- (CPTXYGraph *)graph
{
    if (!_graph)
    {
        _graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
        
        _graph.paddingLeft = 10.0f;
        _graph.paddingTop = 30.0f;
        _graph.paddingRight = 10.0f;
        _graph.paddingBottom = 10.0f;
        
        // 2 - Set up text style
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
        textStyle.color = [CPTColor grayColor];
        textStyle.fontName = @"Helvetica-Bold";
        textStyle.fontSize = 16.0f;
        
        // 3 - Configure title
        NSString *title = @"Test Results";
        _graph.title = title;
        _graph.titleTextStyle = textStyle;
        _graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
        _graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
        
        // 4 - Set theme
        [_graph applyTheme: [CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    }
    
    return _graph;
}

- (void)configureAxis
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    x.title = self.testResult.xAxisLabel;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.maximumFractionDigits = 10;
    
    y.labelFormatter = formatter;
    y.title = self.testResult.yAxisLabel;
    
    self.graph.axisSet.axes = [NSArray arrayWithObjects:x, y, nil];
}

- (void)configureLegend
{
    self.graph.legend = [CPTLegend legendWithGraph:self.graph];
    self.graph.legend.fill = [CPTFill fillWithColor:[CPTColor lightGrayColor]];
    self.graph.legend.cornerRadius = 5.0;
    self.graph.legend.swatchSize = CGSizeMake(25.0, 25.0);
    self.graph.legendAnchor = CPTRectAnchorTopRight;
    self.graph.legendDisplacement = CGPointMake(-20.0, -70.0);
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSArray *plots = self.testResult.plots[plot.identifier];
    return plots.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSArray *plots = self.testResult.plots[plot.identifier];
    NSValue *pointValue = plots[index];
    CGPoint point = [pointValue CGPointValue];
    
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            return @(point.x);
            break;
            
        case CPTScatterPlotFieldY:
            return @(point.y);
            break;
    }
    
    return [NSDecimalNumber zero];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    return nil;
}

#pragma mark - UIActionSheetDelegate methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
}

@end
