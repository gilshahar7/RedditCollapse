
@interface CommentsViewController
-(void)collapseCommentToRoot:(id)arg1;
@end

@interface Comment
@end

@interface CommentView : UIView
@property (assign, nonatomic) CommentsViewController *delegate;
@property (assign, nonatomic) Comment *comment;
@end

@interface CommentCell : UIView
@property (assign, nonatomic) CommentView *commentView;
-(id)_gestureRecognizers;
@end

%hook BaseCollectionView
- (BOOL)_gestureRecognizer:(UIGestureRecognizer *)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)arg2{
	if([arg1.view superview] == (UIView * _Nullable)self){
		return true;
	}
	return %orig(arg1,arg2);
}
%end

%hook CommentsViewController
%new
-(void)handleCollapseGesture:(UISwipeGestureRecognizer*)gestureRecognizer {
	CommentCell *myCommentCell = (CommentCell*)gestureRecognizer.view;
	[self collapseCommentToRoot:myCommentCell.commentView.comment];
}
%end

%hook CommentCell
- (void)layoutSubviews{
	%orig;
	if([self _gestureRecognizers] == nil){
		UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self.commentView.delegate action:@selector(handleCollapseGesture:)];
		[swipeGesture setDirection:(UISwipeGestureRecognizerDirectionLeft)];
		[swipeGesture setDelegate:(id<UIGestureRecognizerDelegate> _Nullable)[self superview]];
		[self addGestureRecognizer:swipeGesture];
	}
}
%end