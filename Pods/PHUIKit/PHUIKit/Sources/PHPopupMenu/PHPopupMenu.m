//
//  PHPopupMenu.m
//  PHUIKit
//
//  Created by 秦平平 on 2020/1/13.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHPopupMenu.h"
#import "PHPopupMenuPath.h"
#import <PHUtils/PHUtils.h>
#import "PHPopupMenuCell.h"

#define PH_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })

@interface PHPopupMenu ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView      * menuBackView;
@property (nonatomic, assign) CGRect                relyRect;
@property (nonatomic, assign) CGFloat       itemWidth;
@property (nonatomic, assign) CGPoint               point;
@property (nonatomic, assign) BOOL          isCornerChanged;
@property (nonatomic, strong) UIColor     * separatorColor;
@property (nonatomic, assign) BOOL          isChangeDirection;
@property (nonatomic, strong) NSIndexPath * tagIndex;
@end

@implementation PHPopupMenu

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaultSettings];
    }
    return self;
}

#pragma mark - publics

+ (PHPopupMenu *)showAtPoint:(CGPoint)point titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth otherSettings:(void (^) (PHPopupMenu * popupMenu))otherSetting
{
    PHPopupMenu *popupMenu = [[PHPopupMenu alloc] init];
    popupMenu.point = point;
    popupMenu.titles = titles;
    popupMenu.images = icons;
    popupMenu.itemWidth = itemWidth;
    PH_SAFE_BLOCK(otherSetting,popupMenu);
    [popupMenu show];
    return popupMenu;
}

+ (PHPopupMenu *)showRelyOnView:(UIView *)view titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth otherSettings:(void (^) (PHPopupMenu * popupMenu))otherSetting
{
    CGRect absoluteRect = [view convertRect:view.bounds toView:PH_KEY_WINDOW];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    PHPopupMenu *popupMenu = [[PHPopupMenu alloc] init];
    popupMenu.point = relyPoint;
    popupMenu.relyRect = absoluteRect;
    popupMenu.titles = titles;
    popupMenu.images = icons;
    popupMenu.itemWidth = itemWidth;
    PH_SAFE_BLOCK(otherSetting,popupMenu);
    [popupMenu show];
    return popupMenu;
}

- (void)dismiss
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(phPopupMenuBeganDismiss)]) {
        [self.delegate phPopupMenuBeganDismiss];
    }
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        self->_menuBackView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(phPopupMenuDidDismiss)]) {
            [self.delegate phPopupMenuDidDismiss];
        }
        self.delegate = nil;
        [self removeFromSuperview];
        [self->_menuBackView removeFromSuperview];
    }];
}

#pragma mark tableViewDelegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * tableViewCell = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(phPopupMenu:cellForRowAtIndex:)]) {
        tableViewCell = [self.delegate phPopupMenu:self cellForRowAtIndex:indexPath.row];
    }
    
    if (tableViewCell) {
        return tableViewCell;
    }
    
    static NSString * identifier = @"phPopupMenu";
    PHPopupMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PHPopupMenuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.hideImage = _images.count >= indexPath.row + 1 ? NO:YES;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.titleLabel.textColor = _textColor;
    cell.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
    if ([_titles[indexPath.row] isKindOfClass:[NSAttributedString class]]) {
        cell.titleLabel.attributedText = _titles[indexPath.row];
    }else if ([_titles[indexPath.row] isKindOfClass:[NSString class]]) {
        cell.titleLabel.text = _titles[indexPath.row];
    }else {
        cell.titleLabel.text = nil;
    }
    if (_images.count >= indexPath.row + 1) {
        if ([_images[indexPath.row] isKindOfClass:[NSString class]]) {
            cell.iconImageView.image = [UIImage imageNamed:_images[indexPath.row]];
        }else if ([_images[indexPath.row] isKindOfClass:[UIImage class]]){
            cell.iconImageView.image = _images[indexPath.row];
        }else {
            cell.hideImage = YES;
            cell.iconImageView.image = nil;
        }
    }
    if (_titles.count - 1 == indexPath.row) {
        cell.hideLine = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PHPopupMenuCell *celled = [tableView cellForRowAtIndexPath:self.tagIndex];
    if (celled.hideImage) {
        celled.titleLabel.textColor = [UIColor ph_colorWithHexString:@"#262626"];
    }
    PHPopupMenuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.hideImage) {
        self.tagIndex = indexPath;
        cell.titleLabel.textColor = [UIColor ph_colorWithHexString:@"#436BFF"];
    }
    if (_dismissOnSelected) [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(phPopupMenu:didSelectedAtIndex:)]) {
        [self.delegate phPopupMenu:self didSelectedAtIndex:indexPath.row];
    }
}
#pragma mark - privates
- (void)show
{
    [PH_KEY_WINDOW addSubview:_menuBackView];
    [PH_KEY_WINDOW addSubview:self];
    if (self.delegate && [self.delegate respondsToSelector:@selector(phPopupMenuBeganShow)]) {
        [self.delegate phPopupMenuBeganShow];
    }
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        self->_menuBackView.alpha = 1;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(phPopupMenuDidShow)]) {
            [self.delegate phPopupMenuDidShow];
        }
    }];
}

- (void)setDefaultSettings
{
    _cornerRadius = 8.0;
    _rectCorner = UIRectCornerAllCorners;
    self.isShowShadow = NO;
    _dismissOnSelected = YES;
    _dismissOnTouchOutside = YES;
    _fontSize = 15;
    _textColor = [UIColor blackColor];
    _offset = 0.0;
    _relyRect = CGRectZero;
    _point = CGPointZero;
    _borderWidth = 0.0;
    _borderColor = [UIColor lightGrayColor];
    _arrowWidth = 14.0;
    _arrowHeight = 7.0;
    _backColor = [UIColor whiteColor];
    _type = PHPopupMenuTypeDefault;
    _arrowDirection = PHPopupMenuArrowDirectionTop;
    _priorityDirection = PHPopupMenuPriorityDirectionTop;
    _minSpace = 10.0;
    _maxVisibleCount = 5;
    _itemHeight = 48;
    _isCornerChanged = NO;
    _showMaskView = YES;
    _menuBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PH_SCREEN_WIDTH, PH_SCREEN_HEIGHT)];
    _menuBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    _menuBackView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchOutSide)];
    [_menuBackView addGestureRecognizer: tap];
    self.alpha = 0;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)touchOutSide
{
    if (_dismissOnTouchOutside) {
        [self dismiss];
    }
}

- (void)setIsShowShadow:(BOOL)isShowShadow
{
    _isShowShadow = isShowShadow;
    self.layer.shadowColor = [UIColor ph_colorWithHexString:@"#000000" alpha:0.08].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = isShowShadow ? 1 : 0;
    self.layer.shadowRadius = isShowShadow ? 8.0 : 0;
}

- (void)setShowMaskView:(BOOL)showMaskView
{
    _showMaskView = showMaskView;
    _menuBackView.backgroundColor = showMaskView ? [[UIColor blackColor] colorWithAlphaComponent:0.1] : [UIColor clearColor];
}

- (void)setType:(PHPopupMenuType)type
{
    _type = type;
    switch (type) {
        case PHPopupMenuTypeDark:
        {
            _textColor = [UIColor lightGrayColor];
            _backColor = [UIColor colorWithRed:0.25 green:0.27 blue:0.29 alpha:1];
            _separatorColor = [UIColor lightGrayColor];
        }
            break;
            
        default:
        {
            _textColor = [UIColor blackColor];
            _backColor = [UIColor whiteColor];
            _separatorColor = [UIColor lightGrayColor];
        }
            break;
    }
    [self updateUI];
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    [self.tableView reloadData];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self.tableView reloadData];
}

- (void)setPoint:(CGPoint)point
{
    _point = point;
    [self updateUI];
}

- (void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    [self updateUI];
}

- (void)setItemHeight:(CGFloat)itemHeight
{
    _itemHeight = itemHeight;
    [self updateUI];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self updateUI];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self updateUI];
}

- (void)setArrowPosition:(CGFloat)arrowPosition
{
    _arrowPosition = arrowPosition;
    [self updateUI];
}

- (void)setArrowWidth:(CGFloat)arrowWidth
{
    _arrowWidth = arrowWidth;
    [self updateUI];
}

- (void)setArrowHeight:(CGFloat)arrowHeight
{
    _arrowHeight = arrowHeight;
    [self updateUI];
}

- (void)setArrowDirection:(PHPopupMenuArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self updateUI];
}

- (void)setMaxVisibleCount:(NSInteger)maxVisibleCount
{
    _maxVisibleCount = maxVisibleCount;
    [self updateUI];
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    [self updateUI];
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    [self updateUI];
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    [self updateUI];
}

- (void)setPriorityDirection:(PHPopupMenuPriorityDirection)priorityDirection
{
    _priorityDirection = priorityDirection;
    [self updateUI];
}

- (void)setRectCorner:(UIRectCorner)rectCorner
{
    _rectCorner = rectCorner;
    [self updateUI];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self updateUI];
}

- (void)setOffset:(CGFloat)offset
{
    _offset = offset;
    [self updateUI];
}

- (void)setMinSpace:(CGFloat)minSpace {
    _minSpace = minSpace;
    [self updateUI];
}

- (void)updateUI
{
    CGFloat height;
    if (_titles.count > _maxVisibleCount) {
        height = _itemHeight * _maxVisibleCount + _borderWidth * 2;
        self.tableView.bounces = YES;
    }else {
        height = _itemHeight * _titles.count + _borderWidth * 2;
        self.tableView.bounces = NO;
    }
    _isChangeDirection = NO;
    if (_priorityDirection == PHPopupMenuPriorityDirectionTop) {
        if (_point.y + height + _arrowHeight > PH_SCREEN_HEIGHT - _minSpace) {
            _arrowDirection = PHPopupMenuArrowDirectionBottom;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = PHPopupMenuArrowDirectionTop;
            _isChangeDirection = NO;
        }
    }else if (_priorityDirection == PHPopupMenuPriorityDirectionBottom) {
        if (_point.y - height - _arrowHeight < _minSpace) {
            _arrowDirection = PHPopupMenuArrowDirectionTop;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = PHPopupMenuArrowDirectionBottom;
            _isChangeDirection = NO;
        }
    }else if (_priorityDirection == PHPopupMenuPriorityDirectionLeft) {
        if (_point.x + _itemWidth + _arrowHeight > PH_SCREEN_WIDTH - _minSpace) {
            _arrowDirection = PHPopupMenuArrowDirectionRight;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = PHPopupMenuArrowDirectionLeft;
            _isChangeDirection = NO;
        }
    }else if (_priorityDirection == PHPopupMenuPriorityDirectionRight) {
        if (_point.x - _itemWidth - _arrowHeight < _minSpace) {
            _arrowDirection = PHPopupMenuArrowDirectionLeft;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = PHPopupMenuArrowDirectionRight;
            _isChangeDirection = NO;
        }
    }
    [self setArrowPosition];
    [self setRelyRect];
    if (_arrowDirection == PHPopupMenuArrowDirectionTop) {
        CGFloat y = _isChangeDirection ? _point.y  : _point.y;
        if (_arrowPosition > _itemWidth / 2) {
            self.frame = CGRectMake(PH_SCREEN_WIDTH - _minSpace - _itemWidth, y, _itemWidth, height + _arrowHeight);
        }else if (_arrowPosition < _itemWidth / 2) {
            self.frame = CGRectMake(_minSpace, y, _itemWidth, height + _arrowHeight);
        }else {
            self.frame = CGRectMake(_point.x - _itemWidth / 2, y, _itemWidth, height + _arrowHeight);
        }
    }else if (_arrowDirection == PHPopupMenuArrowDirectionBottom) {
        CGFloat y = _isChangeDirection ? _point.y - _arrowHeight - height : _point.y - _arrowHeight - height;
        if (_arrowPosition > _itemWidth / 2) {
            self.frame = CGRectMake(PH_SCREEN_WIDTH - _minSpace - _itemWidth, y, _itemWidth, height + _arrowHeight);
        }else if (_arrowPosition < _itemWidth / 2) {
            self.frame = CGRectMake(_minSpace, y, _itemWidth, height + _arrowHeight);
        }else {
            self.frame = CGRectMake(_point.x - _itemWidth / 2, y, _itemWidth, height + _arrowHeight);
        }
    }else if (_arrowDirection == PHPopupMenuArrowDirectionLeft) {
        CGFloat x = _isChangeDirection ? _point.x : _point.x;
        if (_arrowPosition < _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }else if (_arrowPosition > _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }else {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }
    }else if (_arrowDirection == PHPopupMenuArrowDirectionRight) {
        CGFloat x = _isChangeDirection ? _point.x - _itemWidth - _arrowHeight : _point.x - _itemWidth - _arrowHeight;
        if (_arrowPosition < _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }else if (_arrowPosition > _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }else {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }
    }else if (_arrowDirection == PHPopupMenuArrowDirectionNone) {
        
    }
    
    if (_isChangeDirection) {
        [self changeRectCorner];
    }
    [self setAnchorPoint];
    [self setOffset];
    [self.tableView reloadData];
    [self setNeedsDisplay];
}

- (void)setRelyRect
{
    if (CGRectEqualToRect(_relyRect, CGRectZero)) {
        return;
    }
    if (_arrowDirection == PHPopupMenuArrowDirectionTop) {
        _point.y = _relyRect.size.height + _relyRect.origin.y;
    }else if (_arrowDirection == PHPopupMenuArrowDirectionBottom) {
        _point.y = _relyRect.origin.y;
    }else if (_arrowDirection == PHPopupMenuArrowDirectionLeft) {
        _point = CGPointMake(_relyRect.origin.x + _relyRect.size.width, _relyRect.origin.y + _relyRect.size.height / 2);
    }else {
        _point = CGPointMake(_relyRect.origin.x, _relyRect.origin.y + _relyRect.size.height / 2);
    }
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_arrowDirection == PHPopupMenuArrowDirectionTop                                                          ) {
        self.tableView.frame = CGRectMake(_borderWidth, _borderWidth + _arrowHeight, frame.size.width - _borderWidth * 2, frame.size.height - _arrowHeight);
    }else if (_arrowDirection == PHPopupMenuArrowDirectionBottom) {
        self.tableView.frame = CGRectMake(_borderWidth, _borderWidth, frame.size.width - _borderWidth * 2, frame.size.height - _arrowHeight);
    }else if (_arrowDirection == PHPopupMenuArrowDirectionLeft) {
        self.tableView.frame = CGRectMake(_borderWidth + _arrowHeight, _borderWidth , frame.size.width - _borderWidth * 2 - _arrowHeight, frame.size.height);
    }else if (_arrowDirection == PHPopupMenuArrowDirectionRight) {
        self.tableView.frame = CGRectMake(_borderWidth , _borderWidth , frame.size.width - _borderWidth * 2 - _arrowHeight, frame.size.height);
    }
}

- (void)changeRectCorner
{
    if (_isCornerChanged || _rectCorner == UIRectCornerAllCorners) {
        return;
    }
    BOOL haveTopLeftCorner = NO, haveTopRightCorner = NO, haveBottomLeftCorner = NO, haveBottomRightCorner = NO;
    if (_rectCorner & UIRectCornerTopLeft) {
        haveTopLeftCorner = YES;
    }
    if (_rectCorner & UIRectCornerTopRight) {
        haveTopRightCorner = YES;
    }
    if (_rectCorner & UIRectCornerBottomLeft) {
        haveBottomLeftCorner = YES;
    }
    if (_rectCorner & UIRectCornerBottomRight) {
        haveBottomRightCorner = YES;
    }
    
    if (_arrowDirection == PHPopupMenuArrowDirectionTop || _arrowDirection == PHPopupMenuArrowDirectionBottom) {
        
        if (haveTopLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomLeft);
        }
        if (haveTopRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomRight);
        }
        if (haveBottomLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopLeft);
        }
        if (haveBottomRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopRight);
        }
        
    }else if (_arrowDirection == PHPopupMenuArrowDirectionLeft || _arrowDirection == PHPopupMenuArrowDirectionRight) {
        if (haveTopLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopRight);
        }
        if (haveTopRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopLeft);
        }
        if (haveBottomLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomRight);
        }
        if (haveBottomRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomLeft);
        }
    }
    
    _isCornerChanged = YES;
}

- (void)setOffset
{
    if (_itemWidth == 0) return;
    
    CGRect originRect = self.frame;
    
    if (_arrowDirection == PHPopupMenuArrowDirectionTop) {
        originRect.origin.y += _offset;
    }else if (_arrowDirection == PHPopupMenuArrowDirectionBottom) {
        originRect.origin.y -= _offset;
    }else if (_arrowDirection == PHPopupMenuArrowDirectionLeft) {
        originRect.origin.x += _offset;
    }else if (_arrowDirection == PHPopupMenuArrowDirectionRight) {
        originRect.origin.x -= _offset;
    }
    self.frame = originRect;
}

- (void)setAnchorPoint
{
    if (_itemWidth == 0) return;
    
    CGPoint point = CGPointMake(0.5, 0.5);
    if (_arrowDirection == PHPopupMenuArrowDirectionTop) {
        point = CGPointMake(_arrowPosition / _itemWidth, 0);
    }else if (_arrowDirection == PHPopupMenuArrowDirectionBottom) {
        point = CGPointMake(_arrowPosition / _itemWidth, 1);
    }else if (_arrowDirection == PHPopupMenuArrowDirectionLeft) {
        point = CGPointMake(0, (_itemHeight - _arrowPosition) / _itemHeight);
    }else if (_arrowDirection == PHPopupMenuArrowDirectionRight) {
        point = CGPointMake(1, (_itemHeight - _arrowPosition) / _itemHeight);
    }
    CGRect originRect = self.frame;
    self.layer.anchorPoint = point;
    self.frame = originRect;
}

- (void)setArrowPosition
{
    if (_priorityDirection == PHPopupMenuPriorityDirectionNone) {
        return;
    }
    if (_arrowDirection == PHPopupMenuArrowDirectionTop || _arrowDirection == PHPopupMenuArrowDirectionBottom) {
        if (_point.x + _itemWidth / 2 > PH_SCREEN_WIDTH - _minSpace) {
            _arrowPosition = _itemWidth - (PH_SCREEN_WIDTH - _minSpace - _point.x);
        }else if (_point.x < _itemWidth / 2 + _minSpace) {
            _arrowPosition = _point.x - _minSpace;
        }else {
            _arrowPosition = _itemWidth / 2;
        }
        
    }else if (_arrowDirection == PHPopupMenuArrowDirectionLeft || _arrowDirection == PHPopupMenuArrowDirectionRight) {
        //        if (_point.y + _itemHeight / 2 > YBScreenHeight - _minSpace) {
        //            _arrowPosition = _itemHeight - (YBScreenHeight - _minSpace - _point.y);
        //        }else if (_point.y < _itemHeight / 2 + _minSpace) {
        //            _arrowPosition = _point.y - _minSpace;
        //        }else {
        //            _arrowPosition = _itemHeight / 2;
        //        }
    }
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [PHPopupMenuPath ph_bezierPathWithRect:rect rectCorner:_rectCorner cornerRadius:_cornerRadius borderWidth:_borderWidth borderColor:_borderColor backgroundColor:_backColor arrowWidth:_arrowWidth arrowHeight:_arrowHeight arrowPosition:_arrowPosition arrowDirection:_arrowDirection];
    [bezierPath fill];
    [bezierPath stroke];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
