//
//  QPSplitViewController.m
//  Example
//
//  Created by QuangPC on 3/31/14.
//  Copyright (c) 2014 quangpc. All rights reserved.
//

#import "QPSplitViewController.h"
#import "QPSplitView.h"

@interface QPSplitViewController ()
{
    
}
@property (strong, nonatomic) QPSplitView *splitView;
@end

@implementation QPSplitViewController

- (void)setupWithLeftViewController:(UIViewController *)leftController rightViewController:(UIViewController *)rightController {
    CGRect frame = self.view.frame;
    
    self.leftSplitWidth = 308;
    self.rightSplitWidth = frame.size.width - self.leftSplitWidth;
    
    QPSplitView *splitView = [[QPSplitView alloc] initWithFrame:frame controller:self];
    splitView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.splitView = splitView;
    
    [self initLeftViewController:leftController];
    [self initRightViewController:rightController];
    
    [self.view addSubview:splitView];
}

#pragma mark -
#pragma mark Set Controllers methods
- (void)setLeftController:(UIViewController *)leftController {
    [self setLeftController:leftController animated:NO];
}
- (void)setLeftController:(UIViewController *)leftController animated:(BOOL)animated {
    if (![self isViewLoaded]) {
        [self initLeftViewController:leftController];
        return;
    }
    if (leftController == _leftController) {
        return;
    }
    [self changeLeftViewController:leftController];
}

- (void)setRightController:(UIViewController *)rightController {
    [self setRightController:rightController animated:NO];
}
- (void)setRightController:(UIViewController *)rightController animated:(BOOL)animated {
    if (![self isViewLoaded]) {
        [self initRightViewController:rightController];
        return;
    }
    if (rightController == _rightController) {
        return;
    }
    [self changeRightViewController:rightController];
}

#pragma mark -
#pragma mark - Transition between controllers
- (void)initLeftViewController:(UIViewController *)leftController {
    if (leftController) {
        [self addChildViewController:leftController];
        leftController.view.frame = _splitView.leftView.bounds;
        [_splitView.leftView addSubview:leftController.view];
        [leftController didMoveToParentViewController:self];
        _leftController = leftController;
    }
    
}

- (void)initRightViewController:(UIViewController *)rightController {
    if (rightController) {
        [self addChildViewController:rightController];
        rightController.view.frame = _splitView.rightView.bounds;
        [_splitView.rightView addSubview:rightController.view];
        [rightController didMoveToParentViewController:self];
        _rightController = rightController;
    }
}

- (void)changeLeftViewController:(UIViewController *)leftController{
    UIViewController *oldController = _leftController;
    [oldController willMoveToParentViewController:nil];
    [oldController.view removeFromSuperview];
    [oldController removeFromParentViewController];
    
    leftController.view.frame = _splitView.leftView.bounds;
    [self changeNewLeftController:leftController];
}
- (void)changeNewLeftController:(UIViewController *)newLeftController {
    [self addChildViewController:newLeftController];
    [_splitView.leftView addSubview:newLeftController.view];
    [newLeftController didMoveToParentViewController:self];
    _leftController = newLeftController;
}

- (void)changeRightViewController:(UIViewController *)rightController{
    UIViewController *oldController = _rightController;
    [oldController willMoveToParentViewController:nil];
    [oldController.view removeFromSuperview];
    [oldController removeFromParentViewController];
    
    rightController.view.frame = _splitView.rightView.bounds;
    [self changeNewRightController:rightController];
}
- (void)changeNewRightController:(UIViewController *)newRightController {
    [self addChildViewController:newRightController];
    [_splitView.rightView addSubview:newRightController.view];
    [newRightController didMoveToParentViewController:self];
    _rightController = newRightController;
}

#pragma mark -
#pragma mark Change Width
- (void)setLeftSplitWidth:(CGFloat)leftSplitWidth {
    [_splitView setLeftSplitWidth:leftSplitWidth];
    _leftSplitWidth = leftSplitWidth;
    _rightSplitWidth = _splitView.rightView.frame.size.width;
}

- (void)setRightSplitWidth:(CGFloat)rightSplitWidth {
    [_splitView setRightSplitWidth:rightSplitWidth];
    _rightSplitWidth = rightSplitWidth;
    _leftSplitWidth = _splitView.leftView.frame.size.width;
}

#pragma mark - Rotation Support
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

#pragma mark -
#pragma mark UIViewController Category

@implementation UIViewController (QPSplitViewController)

- (QPSplitViewController *)qp_splitViewController {
    UIViewController *parent = self;
    Class revealClass = [QPSplitViewController class];
    
    while ( nil != (parent = [parent parentViewController]) && ![parent isKindOfClass:revealClass] )
    {
    }
    
    return (id)parent;
}

@end

