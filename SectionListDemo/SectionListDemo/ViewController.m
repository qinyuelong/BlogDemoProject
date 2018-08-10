//
//  ViewController.m
//  SectionListDemo
//
//  Created by LinkE on 2018/8/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UILabel *popViewLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popViewCenterYConstraint;

@property (strong, nonatomic) NSArray<NSString *> * indicatorDataArray;

@property (strong, nonatomic) NSMutableDictionary<NSString*, NSArray*> *dataDic;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableSlideSection];
    [self setupTableViewData];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupTableViewData{
    _dataDic = [NSMutableDictionary dictionary];
    for (NSString *s in _indicatorDataArray) {
        NSMutableArray *dataStringArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            [dataStringArray addObject:[NSString stringWithFormat:@"%@ - item %d", s, i]];
        }
        [_dataDic setObject:dataStringArray forKey:s];
    }
}

-(void)createTableSlideSection{
    _indicatorDataArray = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z" componentsSeparatedByString:@" "];
    for (NSString *s in _indicatorDataArray) {
        UILabel *l = [UILabel new];
        l.text = s;
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = [UIColor colorWithRed:120/255.0 green:148/255.0 blue:249/255.0 alpha:1];
        l.font = [UIFont systemFontOfSize:12];
        [_stackView addArrangedSubview:l];
    }
}

- (IBAction)indicatorViewDidPanGesture:(UIPanGestureRecognizer *)sender {
    _popViewLabel.text = [self parseIndicatorText:[sender locationInView:sender.view].y];
    [self parseIndicatorPopLocation:sender];
}

- (IBAction)indicatorViewDidTapGesture:(UITapGestureRecognizer *)sender {
    _popViewLabel.text = [self parseIndicatorText:[sender locationInView:sender.view].y];
    [self parseIndicatorPopLocation:sender];
    
    _popView.hidden = NO;
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        weakSelf.popView.hidden = YES;
    });
}


-(NSString *)parseIndicatorText:(CGFloat) yOffset{
    CGFloat height = CGRectGetHeight(self.stackView.bounds);
    CGFloat cellHeight = height / _indicatorDataArray.count;
    
    int index = (int)(yOffset / cellHeight);
    if (index >= _indicatorDataArray.count) {
        return [_indicatorDataArray lastObject];
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    return _indicatorDataArray[index];
}


-(void)parseIndicatorPopLocation:(UIGestureRecognizer *)sender{
    CGPoint location = [sender locationInView:self.view];
    CGFloat halfHeigt = CGRectGetHeight(self.view.bounds) / 2.0;
    CGFloat space = location.y - halfHeigt;
    _popViewCenterYConstraint.constant = space;
    NSLog(@"%@", NSStringFromCGPoint(location));
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            _popView.hidden = NO;
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            _popView.hidden = YES;
            break;
        default:
            break;
    }
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataDic allKeys].count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *keys = [[_dataDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    cell.textLabel.text = [[_dataDic objectForKey:keys[indexPath.section]] objectAtIndex:indexPath.row];
    
    return cell;
}



#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [UILabel new];
    NSArray *keys = [[_dataDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    label.text = [keys objectAtIndex:section];
    label.backgroundColor = [UIColor lightGrayColor];
    return label;
}


@end
