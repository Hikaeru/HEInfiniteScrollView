//
//  HEInfiniteScrollView.m
//
//  Created by ひかえる, on 2014. 3. 13..
//  Created in Republic of Korea.
//  Copyright (c) 2014년 Hikaeru. All rights reserved.
//

#define InfiniteScrollViewPageControlDefaultBottomMargin 0.0f
#define InfiniteScrollViewPageControlDefaultHeight 40.0f

#define InfiniteScrollViewDefaultPageCount 3

#import "HEInfiniteScrollView.h"

@interface HEInfiniteScrollView()<UIScrollViewDelegate>

@property (assign, nonatomic) CGPoint currentOffset;

@property (assign, nonatomic) NSUInteger totalCount;

@property (strong, nonatomic) NSMutableArray *views;


@end

@implementation HEInfiniteScrollView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:
                        CGRectMake(0, 0, self.bounds.size.width, InfiniteScrollViewPageControlDefaultHeight)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_pageControl];
    
    self.pageControlBottomMargin = InfiniteScrollViewPageControlDefaultBottomMargin;
    
    self.totalCount = [_dataSource numberOfItemsInInfiniteScrollView:self];
    if (_totalCount > 0) {
        
        _pageControl.numberOfPages = _totalCount;
        
        [self makeDefaults];
    }
}

- (void)makeDefaults {
    
    [[_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.views = [NSMutableArray array];
    
    NSUInteger defaultPageCount = 0;
    
    if (_totalCount == 1) {
        
        _scrollView.alwaysBounceHorizontal = NO;
        
        defaultPageCount = 1;
        
        UIView *view = [_dataSource viewForInfiniteScrollView:self];
        
        NSAssert(view, @"The view must not be nil in HEInfiniteScrollView delegate methods.");
        
        [_delegate infiniteScrollView:self didAppearedView:view atIndex:0];
        
        view.center = CGPointMake(_scrollView.frame.size.width/2, CGRectGetMidY(_scrollView.frame));
        [_scrollView addSubview:view];
        [_views addObject:view];
        
        self.currentOffset = CGPointZero;
        
    } else {
        
        _scrollView.alwaysBounceHorizontal = YES;
        
        defaultPageCount = InfiniteScrollViewDefaultPageCount;
        
        for (NSInteger i = 0; i < defaultPageCount; i++) {
            
            UIView *view = [_dataSource viewForInfiniteScrollView:self];
            
            NSAssert(view, @"The view must not be nil in HEInfiniteScrollView delegate methods.");
            
            NSUInteger viewIndex = (i == 0) ? _totalCount-1 : i-1;

            [_delegate infiniteScrollView:self didAppearedView:view atIndex:viewIndex];
            
            view.center = CGPointMake(_scrollView.frame.size.width/2 + _scrollView.frame.size.width*i,
                                      _scrollView.frame.size.height/2);
            [_scrollView addSubview:view];
            [_views addObject:view];
        }
        
        self.currentOffset = CGPointMake(_scrollView.frame.size.width, 0);
    }
    
    _pageControl.numberOfPages = _totalCount;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * defaultPageCount, _scrollView.frame.size.height);
    
    self.currentPage = 0;
    
    _scrollView.contentOffset = _currentOffset;
}

- (void)resetScrollView {
    
    if (_totalCount > 1) {
        
        for (NSInteger i = 0; i < [_views count]; i++) {
            
            UIView *view = _views[i];
            CGPoint viewCenter = view.center;
            viewCenter.x = _scrollView.frame.size.width/2 + _scrollView.frame.size.width*i;
            view.center = viewCenter;
        }
        
        _scrollView.contentSize =
        CGSizeMake(_scrollView.frame.size.width * [_views count], _scrollView.frame.size.height);
        
        self.currentOffset = CGPointMake(_scrollView.frame.size.width, 0);
        
        _scrollView.contentOffset = _currentOffset;
    }
}

#pragma mark - Setter

- (void)setPageControlBottomMargin:(CGFloat)pageControlBottomMargin {
    
    _pageControlBottomMargin = pageControlBottomMargin;
    
    _pageControl.center = CGPointMake(self.bounds.size.width/2,
                                      self.bounds.size.height-(_pageControlBottomMargin+InfiniteScrollViewPageControlDefaultHeight/2));
}

- (void)setCurrentPage:(NSInteger)currentPage {
    
    _currentPage = currentPage;
    _pageControl.currentPage = _currentPage;
}

#pragma mark - Public

- (NSInteger)indexForView:(UIView *)view {
    
    for (UIView *haveView in _views) {
        
        if (haveView == view) {
            
            return [_views indexOfObject:haveView];
        }
    }
    
    return -1;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((scrollView.dragging || scrollView.decelerating) && _totalCount > 1) {
        
        CGFloat currentOffsetX = scrollView.contentOffset.x;
        
        if (currentOffsetX > _currentOffset.x + _scrollView.frame.size.width/2) {
            
            if (_currentPage < _totalCount-1) {
                self.currentPage++;
            } else {
                self.currentPage = 0;
            }
            
            self.currentOffset = CGPointMake(_currentOffset.x + self.bounds.size.width, 0);
            [self addLastPage];
            
            return;
        }
        
        if (currentOffsetX < _currentOffset.x - _scrollView.frame.size.width/2) {
            
            if (_currentPage != 0) {
                self.currentPage--;
            } else {
                self.currentPage = _totalCount-1;
            }
            
            [self insertFirstPage];
            
            self.currentOffset = CGPointMake(_currentOffset.x - _scrollView.frame.size.width, 0);
            
            return;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        
        [self resetScrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self resetScrollView];
}

#pragma mark - Page Control

- (void)addLastPage {
    
    _scrollView.contentSize =
    CGSizeMake(_scrollView.contentSize.width + _scrollView.frame.size.width, _scrollView.frame.size.height);
    
    UIImageView *firstView = [_views firstObject];
    CGPoint firstViewCenter = firstView.center;
    firstViewCenter.x = _scrollView.frame.size.width/2 + _currentOffset.x + _scrollView.frame.size.width;
    
    firstView.center = firstViewCenter;
    
    [_views removeObject:firstView];
    [_views addObject:firstView];
    
    NSUInteger viewIndex = (_currentPage+1 < _totalCount) ? _currentPage+1 : 0;
    
    [_delegate infiniteScrollView:self didAppearedView:firstView atIndex:viewIndex];
}

- (void)insertFirstPage {
    
    _scrollView.contentSize =
    CGSizeMake(_scrollView.contentSize.width + _scrollView.frame.size.width, _scrollView.frame.size.height);
    
    for (UIView *view in _views) {
        
        CGRect viewFrame = view.frame;
        viewFrame.origin.x = viewFrame.origin.x + _scrollView.frame.size.width;
        view.frame = viewFrame;
    }
    
    _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x+_scrollView.frame.size.width, 0);
    self.currentOffset = CGPointMake(_currentOffset.x + self.bounds.size.width, 0);
    
    UIImageView *lastView = [_views lastObject];
    CGRect lastViewFrame = lastView.frame;
    UIImageView *firstView = [_views firstObject];
    lastViewFrame.origin.x = firstView.frame.origin.x - _scrollView.frame.size.width;
    lastView.frame = lastViewFrame;
    
    [_views removeObject:lastView];
    [_views insertObject:lastView atIndex:0];
    
    NSUInteger viewIndex = (_currentPage-1 < 0) ? _totalCount-1 : _currentPage-1;
    
    [_delegate infiniteScrollView:self didAppearedView:lastView atIndex:viewIndex];
}

@end
