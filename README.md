HEInfiniteScrollView
====================

HEInfiniteScrollView is a simple infinite scrolling control.


## How To Use(Korean)

- StoryBoard, xib 또는 Code로 HEInfiniteScrollView instance를 생성합니다. HEInfiniteScrollView는 UIView를 상속합니다.
- \<HEInfiniteScrollViewDataSource>dataSource와 \<HEInfiniteScrollViewDelegate>delegate를 연결합니다.
- UITableView와 유사하게, HEInfiniteScrollViewDataSource와 HEInfiniteScrollViewDelegate의 required method를 구현해야 합니다. 이곳에서 실제로 scrollView 위에 보여질 뷰 및 데이터를 설정할 수 있습니다.



### HEInfiniteScrollViewDataSource Method Sample

- (NSUInteger)numberOfItemsInInfiniteScrollView:(HEInfiniteScrollView *)scrollView

`
  return [_dataArray count]; // based on _dataArray
`
or
`
  return 5; // constant count
`

- (UIView *)viewForInfiniteScrollView:(HEInfiniteScrollView *)scrollView

```
  CustomView *customView = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil][0];
  return customView;
```

### HEInfiniteScrollViewDelegate Method Sample

- (void)infiniteScrollView:(HEInfiniteScrollView *)scrollView didAppearedView:(UIView *)appearedView atIndex:(NSUInteger)index

```    
  CustomView *view = (CustomView *)appearedView;
  view.numberLabel.text = [NSString stringWithFormat:@"%u", index];
```
