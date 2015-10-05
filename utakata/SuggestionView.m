//
//  SuggestionView.m
//  utakata
//
//  Created by 横山祥平 on 2015/08/29.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "SuggestionView.h"

#define ConciergeNumberOfPages 6
#define PagerHeight 40


@interface SuggestionView()<UIScrollViewDelegate, UIScrollViewDelegate>
@property (nonatomic) UIButton *refreshButton;
@property (nonatomic) UIImageView *concierge;
@property (nonatomic) UIImageView *conciergeLock;
@property (nonatomic) UIImageView *conciergePop;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) UIImageView *mixHeaderView;
@property (nonatomic) UIImageView *popHeaderView;
@property (nonatomic) UIImageView *rockHeaderView;
@property (nonatomic) UIImageView *regHeaderView;
@property (nonatomic) UIImageView *jazzHeaderView;
@property (nonatomic) UIImageView *classHeaderView;
@property (nonatomic) UIImageView *mixView;
@property (nonatomic) UIImageView *popView;
@property (nonatomic) UIImageView *rockView;
@property (nonatomic) UIImageView *regView;
@property (nonatomic) UIImageView *jazzView;
@property (nonatomic) UIImageView *classView;
@end

@implementation SuggestionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
//        self.backgroundColor = [UIColor lightGrayColor];
    }
    
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width * ConciergeNumberOfPages, self.bounds.size.height);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    _concierge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"concierge"]];
    [self addSubview:_concierge];
    [self sendSubviewToBack:_concierge];
    _conciergeLock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"concierge_lock"]];
    [_scrollView addSubview:_conciergeLock];
    _conciergePop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"concierge_glasses"]];
    [_scrollView addSubview:_conciergePop];
    
    _mixView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mix"]];
    [_scrollView addSubview:_mixView];
    _popView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop"]];
    [_scrollView addSubview:_popView];
    _rockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rock"]];
    [_scrollView addSubview:_rockView];
    _regView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reg"]];
    [_scrollView addSubview:_regView];
    _jazzView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jazz"]];
    [_scrollView addSubview:_jazzView];
    _classView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"class"]];
    [_scrollView addSubview:_classView];
    
    _mixHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mix_header"]];
    [_scrollView addSubview:_mixHeaderView];
    _popHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_header"]];
    [_scrollView addSubview:_popHeaderView];
    _rockHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rock_header"]];
    [_scrollView addSubview:_rockHeaderView];
    _regHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reg_header"]];
    [_scrollView addSubview:_regHeaderView];
    _jazzHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jazz_header"]];
    [_scrollView addSubview:_jazzHeaderView];
    _classHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"class_header"]];
    [_scrollView addSubview:_classHeaderView];
    
    
    
    _pager = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pager.numberOfPages = ConciergeNumberOfPages;
    _pager.currentPage = 0;
    _pager.hidesForSinglePage = NO;
    _pager.pageIndicatorTintColor = [UIColor blackColor];
    _pager.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:69/255.0 blue:0/255.0 alpha:1.0];
    _pager.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [_pager addTarget:self
                   action:@selector(changePage:)
         forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pager];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect scrollFrame = _scrollView.frame;
    scrollFrame.size.width = self.bounds.size.width;
    scrollFrame.size.height = self.bounds.size.height;
    _scrollView.frame = scrollFrame;
    
    CGRect pagerFrame = _pager.frame;
    pagerFrame.origin.x = (self.bounds.size.width - 40.0f) / 2;
    pagerFrame.origin.y = (PagerHeight -  CGRectGetHeight(_pager.frame)) / 2 + (CGRectGetHeight(self.bounds) - PagerHeight) - 15.0f;
    pagerFrame.size.width = 40.0f;
    pagerFrame.size.height = 40.0f;
    _pager.frame = pagerFrame;
    
    //SuggesutionTableViewCellと合わせる
    float imageHeight = CGRectGetHeight(self.bounds) - PagerHeight -30.0f;
    float imageMarginX = 5.0f;
    float imageMarginY = 10.0f;
    
    _concierge.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width / 3, imageHeight);
    
    _conciergeLock.frame = CGRectMake(self.bounds.size.width, 0.0f, self.bounds.size.width / 3, imageHeight);
    _conciergePop.frame = CGRectMake(self.bounds.size.width * 2, 0.0f, self.bounds.size.width / 3, imageHeight);
    
//    CGRect conciergeFrame = _concierge.frame;
//    conciergeFrame.origin.x = imageMarginX;
//    conciergeFrame.origin.y = imageMarginY;
//    conciergeFrame.size.width = imageHeight;
//    conciergeFrame.size.height = imageHeight;
//    _concierge.frame = conciergeFrame;
//    
//    CGRect lockFrame = _conciergeLock.frame;
//    lockFrame.origin.x = self.bounds.size.width + imageMarginX;
//    lockFrame.origin.y = imageMarginY;
//    lockFrame.size.width = imageHeight;
//    lockFrame.size.height = imageHeight;
//    _conciergeLock.frame = lockFrame;
//    
//    CGRect popFrame = _conciergePop.frame;
//    popFrame.origin.x = self.bounds.size.width * 2 + imageMarginX;
//    popFrame.origin.y = imageMarginY;
//    popFrame.size.width = imageHeight;
//    popFrame.size.height = imageHeight;
//    _conciergePop.frame = popFrame;
    
    float header = 40.0f;
    
    CGRect mixHeaderFrame = _mixHeaderView.frame;
    mixHeaderFrame.origin.y = self.bounds.size.height - header;
    mixHeaderFrame.size.width = self.bounds.size.width;
    mixHeaderFrame.size.height = header;
    _mixHeaderView.frame = mixHeaderFrame;
    CGRect popHeaderFrame = _popHeaderView.frame;
    popHeaderFrame.origin.y = self.bounds.size.height - header;
    popHeaderFrame.origin.x = self.bounds.size.width;
    popHeaderFrame.size.width = self.bounds.size.width;
    popHeaderFrame.size.height = header;
    _popHeaderView.frame = popHeaderFrame;
    CGRect rockHeaderFrame = _rockHeaderView.frame;
    rockHeaderFrame.origin.y = self.bounds.size.height - header;
    rockHeaderFrame.origin.x = self.bounds.size.width * 2;
    rockHeaderFrame.size.width = self.bounds.size.width;
    rockHeaderFrame.size.height = header;
    _rockHeaderView.frame = rockHeaderFrame;
    CGRect regHeaderFrame = _regHeaderView.frame;
    regHeaderFrame.origin.y = self.bounds.size.height - header;
    regHeaderFrame.origin.x = self.bounds.size.width * 3;
    regHeaderFrame.size.width = self.bounds.size.width;
    regHeaderFrame.size.height = header;
    _regHeaderView.frame = regHeaderFrame;
    CGRect jazzHeaderFrame = _jazzHeaderView.frame;
    jazzHeaderFrame.origin.y = self.bounds.size.height - header;
    jazzHeaderFrame.origin.x = self.bounds.size.width * 4;
    jazzHeaderFrame.size.width = self.bounds.size.width;
    jazzHeaderFrame.size.height = header;
    _jazzHeaderView.frame = jazzHeaderFrame;
    CGRect classHeaderFrame = _classHeaderView.frame;
    classHeaderFrame.origin.y = self.bounds.size.height - header;
    classHeaderFrame.origin.x = self.bounds.size.width * 5;
    classHeaderFrame.size.width = self.bounds.size.width;
    classHeaderFrame.size.height = header;
    _classHeaderView.frame = classHeaderFrame;
    
    
    
    CGRect mixFrame = _mixView.frame;
    mixFrame.size.width = self.bounds.size.width;
    mixFrame.size.height = self.bounds.size.height;
    _mixView.frame = mixFrame;
    
    CGRect popViewFrame = _popView.frame;
    popViewFrame.origin.x = self.bounds.size.width;
    popViewFrame.size.width = self.bounds.size.width;
    popViewFrame.size.height = self.bounds.size.height;
    _popView.frame = popViewFrame;
    
    CGRect rockFrame = _rockView.frame;
    rockFrame.origin.x = self.bounds.size.width * 2;
    rockFrame.size.width = self.bounds.size.width;
    rockFrame.size.height = self.bounds.size.height;
    _rockView.frame = rockFrame;
    
    CGRect regFrame = _regView.frame;
    regFrame.origin.x = self.bounds.size.width * 3;
    regFrame.size.width = self.bounds.size.width;
    regFrame.size.height = self.bounds.size.height;
    _regView.frame = regFrame;
    
    CGRect jazzFrame = _jazzView.frame;
    jazzFrame.origin.x = self.bounds.size.width * 4;
    jazzFrame.size.width = self.bounds.size.width;
    jazzFrame.size.height = self.bounds.size.height;
    _jazzView.frame = jazzFrame;
    
    CGRect classFrame = _classView.frame;
    classFrame.origin.x = self.bounds.size.width * 5;
    classFrame.size.width = self.bounds.size.width;
    classFrame.size.height = self.bounds.size.height;
    _classView.frame = classFrame;
}

#pragma mark - Tap Action

- (void)tapRefreshButton:(UITapGestureRecognizer *)sender
{
    if (self.tappedRefreshButton) {
        self.tappedRefreshButton();
    }
}

#pragma -mark UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _currentIndex = page;
    _pager.currentPage = page;
    
    NSLog(@"%d", page);
    
        if([_suggestionViewDelegate respondsToSelector:@selector(changePage:)]){
            [_suggestionViewDelegate changePage:_pager.currentPage];
        }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([_suggestionViewDelegate respondsToSelector:@selector(scrollControll)]){
        [_suggestionViewDelegate scrollControll];
    }
}


@end
