//
//  HEInfiniteScrollView.h
//
//  Created by ひかえる on 2014. 3. 13..
//  Created in Republic of Korea.
//  Copyright (c) 2014년 Hikaeru. ( https://github.com/Hikaeru/HEInfiniteScrollView )
//

#import <UIKit/UIKit.h>

@protocol HEInfiniteScrollViewDataSource;
@protocol HEInfiniteScrollViewDelegate;

@interface HEInfiniteScrollView : UIView

- (void)setup;

@property (assign, nonatomic) IBOutlet id<HEInfiniteScrollViewDataSource> dataSource;
@property (assign, nonatomic) IBOutlet id<HEInfiniteScrollViewDelegate> delegate;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (assign, nonatomic) CGFloat pageControlBottomMargin;

@property (assign, nonatomic) NSInteger currentPage;

- (NSInteger)indexForView:(UIView *)view; //like a indexPathForCell: in UITableView.

@end


@protocol HEInfiniteScrollViewDataSource <NSObject>

- (NSUInteger)numberOfItemsInInfiniteScrollView:(HEInfiniteScrollView *)scrollView; //like a numberOfRowsAtIndexPath: in UITableView.
- (UIView *)viewForInfiniteScrollView:(HEInfiniteScrollView *)scrollView; // initial view in scrollView. do not set data at here. must not be nil.

@end

@protocol HEInfiniteScrollViewDelegate <NSObject>

- (void)infiniteScrollView:(HEInfiniteScrollView *)scrollView didAppearedView:(UIView *)appearedView atIndex:(NSUInteger)index; //set data at here.

@end