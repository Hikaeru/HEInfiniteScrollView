//
//  ViewController.h
//  InfiniteScrollViewTest
//
//  Created by SYJ on 2014. 3. 13..
//  Copyright (c) 2014년 Hikaeru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HEInfiniteScrollView.h"

@interface ViewController : UIViewController<HEInfiniteScrollViewDataSource, HEInfiniteScrollViewDelegate>

@property (weak, nonatomic) IBOutlet HEInfiniteScrollView *infiniteScrollView;

@end
