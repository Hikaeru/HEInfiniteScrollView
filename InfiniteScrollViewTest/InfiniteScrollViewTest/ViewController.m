//
//  ViewController.m
//  InfiniteScrollViewTest
//
//  Created by SYJ on 2014. 3. 13..
//  Copyright (c) 2014년 Hikaeru. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.dataArray = @[];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HEInfiniteScrollViewDataSource

- (NSUInteger)numberOfItemsInInfiniteScrollView:(HEInfiniteScrollView *)scrollView {
    
    return 6;
    
    return [_dataArray count];
}

- (UIView *)viewForInfiniteScrollView:(HEInfiniteScrollView *)scrollView {
    
    CustomView *customView = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil][0];
    
    return customView;
}

#pragma mark - HEInfiniteScrollViewDelegate

- (void)infiniteScrollView:(HEInfiniteScrollView *)scrollView didAppearedView:(UIView *)appearedView atIndex:(NSUInteger)index {
    
    CustomView *view = (CustomView *)appearedView;
    view.numberLabel.text = [NSString stringWithFormat:@"%u", index];
}

@end
