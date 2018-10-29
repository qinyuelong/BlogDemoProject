## iOS 计算文本高度


## 通过boundingRectWithSize计算文本高度

```
// 针对与普通文本计算NSString
@interface NSString (NSExtendedStringDrawing)
- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes context:(nullable NSStringDrawingContext *)context NS_AVAILABLE(10_11, 7_0);

// 针对对富文本计算NSAttributedString
@interface NSAttributedString (NSExtendedStringDrawing)
- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(nullable NSStringDrawingContext *)context NS_AVAILABLE(10_11, 6_0);
```

使用 计算文本高度时候有可能会遇到高度不对问题 参考 [boundingRectWithSize计算文字高度不准问题](https://www.jianshu.com/p/c615a76dace2) 可以有三种解决办法

## autolayout 布局后获取高度

