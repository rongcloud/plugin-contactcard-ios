//
//  RCSendCardMessageView.m
//  RongContactCard
//
//  Created by Jue on 2016/12/19.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCSendCardMessageView.h"
#import "UIColor+RCCCColor.h"
#import "RCCCUtilities.h"
#import "RCContactCardMessage.h"
#import "RCCCExtensionModule.h"
#import "RCloudImageView.h"

NSString *const RCCC_CardMessageSend = @"RCCC_CardMessageSend";

@interface RCSendCardMessageView ()

@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)UILabel *sendToLabel;
@property(nonatomic, strong)RCloudImageView *portraitView;
@property(nonatomic, strong)UILabel *nicknameLabel;
@property(nonatomic, strong)UIView *separationView1;
@property(nonatomic, strong)UILabel *cardLabel;
@property(nonatomic, strong)UITextField *messageTextField;
@property(nonatomic, strong)UIView *separationView2;
@property(nonatomic, strong)UIView *separationView3;
@property(nonatomic, strong)UIButton *cancleButton;
@property(nonatomic, strong)UIButton *sendButton;
@property(nonatomic, strong)NSDictionary *subViewsDic;
@property(nonatomic)RCConversationType conversationType;
@property(nonatomic, strong)NSString *targetId;

@property(nonatomic, strong)RCCCGroupInfo *groupInfo;

@property(nonatomic, assign)NSInteger destructDuration;
@end

@implementation RCSendCardMessageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    
    
    
    [self setSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
  }
  return self;
}

- (void)setSubViews {
  _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 259)];
  _contentView.center = self.center;
  _contentView.backgroundColor = [UIColor whiteColor];
  [self addSubview:_contentView];
  
  //发送给：
  _sendToLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  _sendToLabel.font = [UIFont systemFontOfSize:18.f];
  _sendToLabel.textColor = [UIColor colorWithHexString:@"000000" alpha:1.f];
  _sendToLabel.text = NSLocalizedStringFromTable(@"SendTo",@"RongCloudKit", nil);
  //[_sendToLabel sizeToFit];
  _sendToLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_sendToLabel];
  
  //头像
  _portraitView = [[RCloudImageView alloc] initWithFrame:CGRectZero];
  _portraitView.layer.cornerRadius = 5.f;
  _portraitView.layer.masksToBounds = YES;
  _portraitView.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_portraitView];
  [_portraitView setPlaceholderImage:[RCCCUtilities imageNamed:@"default_portrait_msg" ofBundle:@"RongCloud.bundle"]];
  
  //昵称
  _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  _nicknameLabel.font = [UIFont systemFontOfSize:17.f];
  _nicknameLabel.textColor = [UIColor colorWithHexString:@"000000" alpha:1.f];
  _nicknameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
  _nicknameLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_nicknameLabel];
  
  //分割线1
  _separationView1 = [[UIView alloc] initWithFrame:CGRectZero];
  _separationView1.backgroundColor = [UIColor  colorWithHexString:@"dfdfdf" alpha:1.f];
  _separationView1.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_separationView1];
  
  //个人名片
  _cardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  _cardLabel.font = [UIFont systemFontOfSize:14.f];
  _cardLabel.textColor = [UIColor colorWithHexString:@"999999" alpha:1.f];
  _cardLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_cardLabel];
  
  //留言
  _messageTextField = [[UITextField alloc] initWithFrame:CGRectZero];
  _messageTextField.font = [UIFont systemFontOfSize:14.f];
  _messageTextField.placeholder = NSLocalizedStringFromTable(@"LeaveAMessage",@"RongCloudKit", nil);
  _messageTextField.layer.borderWidth= 0.5f;
  _messageTextField.layer.borderColor= [[UIColor  colorWithHexString:@"dfdfdf" alpha:1.f] CGColor];
  _messageTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 36)];
  _messageTextField.leftViewMode = UITextFieldViewModeAlways;
  _messageTextField.layer.cornerRadius = 5.f;
  _messageTextField.textColor = [UIColor blackColor];
  NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_messageTextField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999" alpha:1],
                 NSFontAttributeName:_messageTextField.font}];
  _messageTextField.attributedPlaceholder = attrString;
  _messageTextField.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_messageTextField];
  
  //分割线2
  _separationView2 = [[UIView alloc] initWithFrame:CGRectZero];
  _separationView2.backgroundColor = [UIColor  colorWithHexString:@"dfdfdf" alpha:1.f];
  _separationView2.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_separationView2];
  
  //分割线3
  _separationView3 = [[UIView alloc] initWithFrame:CGRectZero];
  _separationView3.backgroundColor = [UIColor  colorWithHexString:@"dfdfdf" alpha:1.f];
  _separationView3.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_separationView3];
  
  //取消按钮
  _cancleButton = [[UIButton alloc] initWithFrame:CGRectZero];
  _cancleButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
  [_cancleButton setTitleColor:[UIColor colorWithHexString:@"000000" alpha:1.f] forState:UIControlStateNormal];
  [_cancleButton setTitle:NSLocalizedStringFromTable(@"Cancel",@"RongCloudKit", nil) forState:UIControlStateNormal];
  [_cancleButton addTarget:self
                    action:@selector(clickCancleBtn)
          forControlEvents:UIControlEventTouchUpInside];
  _cancleButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_cancleButton];
  
  //发送按钮
  _sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
  _sendButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
  [_sendButton setTitleColor:[UIColor colorWithHexString:@"0099ff" alpha:1.f] forState:UIControlStateNormal];
  [_sendButton setTitle:NSLocalizedStringFromTable(@"Send",@"RongCloudKit", nil) forState:UIControlStateNormal];
  [_sendButton addTarget:self
                  action:@selector(clickSendBtn)
        forControlEvents:UIControlEventTouchUpInside];
  _sendButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_sendButton];
  
  _subViewsDic = NSDictionaryOfVariableBindings(_contentView, _sendToLabel, _portraitView, _nicknameLabel, _separationView1, _cardLabel, _messageTextField, _separationView2, _separationView3, _cancleButton, _sendButton);
  
  //设置自动布局
  [self setAutoLayout];
}

- (void)setAutoLayout {
  [_contentView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|-20-[_sendToLabel]"
                   options:0
                   metrics:nil
                   views:_subViewsDic]];
  
  [_contentView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|-20-[_portraitView(40)]-10-[_nicknameLabel]-20-|"
                   options:0
                   metrics:nil
                   views:_subViewsDic]];
  
  [_contentView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|-20-[_separationView1]-20-|"
                   options:0
                   metrics:nil
                   views:_subViewsDic]];
  
  [_contentView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|-20-[_cardLabel]-20-|"
                   options:0
                   metrics:nil
                   views:_subViewsDic]];
  
  [_contentView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|-20-[_messageTextField]-20-|"
                   options:0
                   metrics:nil
                   views:_subViewsDic]];
  
  [_contentView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|[_separationView2]|"
                   options:0
                   metrics:nil
                   views:_subViewsDic]];
  
  CGFloat buttonWidth = 280 / 2.f - 0.25;
  [_contentView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|[_cancleButton(width)]-0-[_separationView3(0.5)]-0-[_sendButton(width)]"
                   options:0
                   metrics:@{@"width":@(buttonWidth)}
                   views:_subViewsDic]];
  
  [_contentView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"V:|-17-[_sendToLabel]-6-[_portraitView(40)]-15-[_separationView1(0.5)]-15-[_cardLabel]-15-[_messageTextField(36)]-20-[_separationView2(0.5)]-0-[_cancleButton(50)]|"
                   options:0
                   metrics:nil
                   views:_subViewsDic]];
  
  [_contentView
   addConstraint:[NSLayoutConstraint constraintWithItem:_nicknameLabel
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_portraitView
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1
                                               constant:0]];
  [_contentView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"V:[_nicknameLabel(20)]"
                   options:0
                   metrics:nil
                   views:_subViewsDic]];
  
  [_contentView
   addConstraint:[NSLayoutConstraint constraintWithItem:_separationView3
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_cancleButton
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1
                                               constant:0]];
  [_contentView
   addConstraint:[NSLayoutConstraint constraintWithItem:_separationView3
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_cancleButton
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1
                                               constant:0]];
  
  [_contentView
   addConstraint:[NSLayoutConstraint constraintWithItem:_sendButton
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_cancleButton
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1
                                               constant:0]];
  [_contentView
   addConstraint:[NSLayoutConstraint constraintWithItem:_sendButton
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_cancleButton
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1
                                               constant:0]];
}

- (void)clickCancleBtn {
  [self removeFromSuperview];
}

- (void)clickSendBtn {
  self.sendButton.userInteractionEnabled = NO;
  RCContactCardMessage *cardMessage = [RCContactCardMessage messageWithUserInfo:_cardUserInfo];
  RCUserInfo *currentUserInfo = [RCIM sharedRCIM].currentUserInfo;
  cardMessage.sendUserId = currentUserInfo.userId;
  cardMessage.sendUserName = currentUserInfo.name;
  NSString *pushContent = nil;
  NSString *tail = [NSString stringWithFormat:NSLocalizedStringFromTable(@"RecommendedToYou",@"RongCloudKit", nil),_cardUserInfo.name];
  if(_conversationType == ConversationType_GROUP) {
    pushContent = [NSString stringWithFormat:@"%@(%@)%@",cardMessage.sendUserName,_groupInfo.groupName,tail];
  }else {
    pushContent = [NSString stringWithFormat:@"%@%@",cardMessage.sendUserName,tail];
  }
    if (self.destructDuration > 0) {
        cardMessage.destructDuration = self.destructDuration;
    }
  __weak typeof(self) ws = self;
  [[RCIM sharedRCIM] sendMessage:_conversationType
                        targetId:_targetId
                         content:cardMessage
                     pushContent:pushContent
                        pushData:nil
                         success:^(long messageId) {
                           [ws sendTextMessageIfNeed];
                           [ws dealWithWhenSendComplete];
                         } error:^(RCErrorCode nErrorCode, long messageId) {
                           [ws sendTextMessageIfNeed];
                           [ws gotoConversationVC];
                           [ws dealWithWhenSendComplete];
                         }];
}

- (void)dealWithWhenSendComplete {
  if ([[RCContactCardKit shareInstance].contactVCDelegate respondsToSelector:@selector(clickSendContactCardButton)]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [[RCContactCardKit shareInstance].contactVCDelegate clickSendContactCardButton];
      [self removeFromSuperview];
    });
  } else {
    [self gotoConversationVC];
  }
}

- (void) gotoConversationVC {
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:RCCC_CardMessageSend object:nil];
    [self removeFromSuperview];
  });
}

- (void)sendTextMessageIfNeed {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (_messageTextField.text.length > 0) {
        RCTextMessage *textMessage = [RCTextMessage messageWithContent:_messageTextField.text];
          if (self.destructDuration > 0) {
              textMessage.destructDuration = self.destructDuration;
          }
        [[RCIM sharedRCIM] sendMessage:_conversationType
                              targetId:_targetId
                               content:textMessage
                           pushContent:nil
                              pushData:nil
                               success:^(long messageId) {
                                       
                               } error:^(RCErrorCode nErrorCode, long messageId) {
                                       
                               }];
        }
    });
}

- (void)setConversationType:(RCConversationType)conversationType targetId:(NSString *)targetId {
  if (conversationType > 0 && targetId.length >0) {
    _conversationType = conversationType;
    _targetId = targetId;
    if (conversationType == ConversationType_PRIVATE) {
      RCUserInfo *userInfo = [[RCIM sharedRCIM] getUserInfoCache:_targetId];
      _nicknameLabel.text = userInfo.name;
      [_portraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];
    }
    if (conversationType == ConversationType_GROUP) {
      __weak typeof(self) ws = self;
        if([self canSendContactCardMessageInGroup]) {
            [[RCContactCardKit shareInstance].
             groupDataSource getGroupInfoByGroupId:_targetId
             result:^(RCCCGroupInfo *groupInfo) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                   [ws updateGroupInfo:groupInfo];
                 });
             }];
        }
    }
  }
}

- (void)updateGroupInfo:(RCCCGroupInfo *)groupInfo {
  self.groupInfo = groupInfo;
  [self.portraitView setImageURL:[NSURL URLWithString:groupInfo.portraitUri]];
  self.nicknameLabel.text = [NSString stringWithFormat:@"%@ (%@%@)",groupInfo.groupName,groupInfo.number,NSLocalizedStringFromTable(@"Person",@"RongCloudKit", nil)];
}

- (BOOL)canSendContactCardMessageInGroup {
    BOOL result = [RCContactCardKit shareInstance].groupDataSource && [[RCContactCardKit shareInstance].groupDataSource respondsToSelector:@selector(getGroupInfoByGroupId:result:)];
    if(!result) {
        NSLog(@"Error:在群组中发送名片消息必须实现RCContactCardKit的RCCCGroupDataSource代理方法");
    }
    return result;
}

- (void)setCardUserInfo:(RCUserInfo *)cardUserInfo {
  _cardUserInfo = cardUserInfo;
  _cardLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedStringFromTable(@"ContactCard",@"RongCloudKit", nil),cardUserInfo.name];
  _cardUserInfo.name = cardUserInfo.name;
}

- (void)setTargetUserInfo:(RCCCUserInfo *)targetUserInfo {
  _targetUserInfo = targetUserInfo;
  if (targetUserInfo.displayName.length > 0) {
    _nicknameLabel.text = targetUserInfo.displayName;
  } else {
  _nicknameLabel.text = targetUserInfo.name;
  }
  [_portraitView setImageURL:[NSURL URLWithString:targetUserInfo.portraitUri]];
  self.conversationType = ConversationType_PRIVATE;
  self.targetId = targetUserInfo.userId;
}


- (void)setTargetgroupInfo:(RCCCGroupInfo *)targetgroupInfo {
  self.groupInfo = targetgroupInfo;
  self.nicknameLabel.text = [NSString stringWithFormat:@"%@ (%@%@)",targetgroupInfo.groupName,targetgroupInfo.number,NSLocalizedStringFromTable(@"Person",@"RongCloudKit", nil)];
  [_portraitView setImageURL:[NSURL URLWithString:targetgroupInfo.portraitUri]];
  self.conversationType = ConversationType_GROUP;
  self.targetId = targetgroupInfo.groupId;
}

- (void)addTapGestureForSelf {
  self.userInteractionEnabled = YES;
  UITapGestureRecognizer *clickSelf =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(clickSelf)];
  [self addGestureRecognizer:clickSelf];
}

- (void)clickSelf {
  if ([_messageTextField isFirstResponder]) {
    [_messageTextField resignFirstResponder];
  }
}

//键盘将要弹起时，修改subviews的坐标
- (void)keyboardWillShow:(NSNotification *)notif {
  if (self.hidden == YES) {
    return;
  }
  
  CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGFloat y = rect.origin.y;
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.25];
  NSArray *subviews = [self subviews];
  for (UIView *sub in subviews) {
    
    CGFloat maxY = CGRectGetMaxY(sub.frame);
    if (maxY > y - 2) {
      sub.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, sub.center.y - maxY + y - 2);
    }
  }
  [UIView commitAnimations];
  
  //为黑色背景添加点击收起键盘的手势
  [self addTapGestureForSelf];
}

//键盘将要收起时，修改subviews的坐标
- (void)keyboardWillHide:(NSNotification *)notif {
  if (self.hidden == YES) {
    return;
  }
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.25];
  NSArray *subviews = [self subviews];
  for (UIView *sub in subviews) {
    if (sub.center.y < CGRectGetHeight(self.frame)/2.0) {
      sub.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    }
  }
  [UIView commitAnimations];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
