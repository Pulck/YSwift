//
//  PHIntegratedInputPage.m
//  PHUIKit
//
//  Created by liangc on 2019/11/7.
//

#import "PHIntegratedInputPage.h"
#import "PHIntegratedInputPageDefine.h"
#import "PHIntegratedTextFieldCell.h"
#import "PHIntegratedTextViewCell.h"
#import "Masonry/Masonry.h"
#import "PHUtils/PHUtils.h"

@interface PHIntegratedInputPage () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

@property (nonatomic, readonly) UIEdgeInsets safeAreaInsets;

@end

@implementation PHIntegratedInputPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setupSubviews];
    [self registerNotification];
    [self addGesture];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideKeyboard];
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
}

- (void)registerNotification {
    NSNotificationCenter *defaultCenter = NSNotificationCenter.defaultCenter;
    [defaultCenter addObserver:self selector:@selector(keyboardWillFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillFrameChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGFloat endY = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    CGFloat bottomInset = MAX(UIScreen.mainScreen.bounds.size.height - endY, 0);
    if (bottomInset > 0) {
        bottomInset -= self.safeAreaInsets.bottom;
    }
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(contentInset.top, contentInset.left, bottomInset, contentInset.right);
    
    self.tableView.scrollIndicatorInsets = insets;
    self.tableView.contentInset = insets;
    
}

- (void)addGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:tap];
}

- (void)hideKeyboard {
    [self.tableView endEditing:YES];
}

#pragma mark - getter

- (UIEdgeInsets)safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return self.view.safeAreaInsets;
    } else {
        UIEdgeInsets insets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
        return insets;
    }
}


#pragma mark - <UITableViewDelegate>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:phIntegratedTextViewCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:pHIntegratedTextFieldCellIdentifier forIndexPath:indexPath];
    }
    
    if ([cell isKindOfClass:PHIntegratedTextFieldCell.class]) {
        PHIntegratedTextFieldCell *inputCell = (PHIntegratedTextFieldCell *)cell;
        inputCell.bottomLineStyle = PHIntegrateSeparatorStyleGroup;
        inputCell.maxInputLength = 0;
    } else if ([cell isKindOfClass:PHIntegratedTextViewCell.class]) {
        PHIntegratedTextViewCell *mutiInputCell = (PHIntegratedTextViewCell *)cell;
    }
    
    return cell;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

#pragma mark - Lazy Init

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.allowsSelection = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_tableView registerClass:PHIntegratedTextFieldCell.class forCellReuseIdentifier:pHIntegratedTextFieldCellIdentifier];
        [_tableView registerClass:PHIntegratedTextViewCell.class forCellReuseIdentifier:phIntegratedTextViewCellIdentifier];
    }
    return _tableView;
}

#pragma mark - dealloc

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
