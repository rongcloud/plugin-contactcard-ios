//
//  RCContactCardMessageCell.m
//  RongContactCard
//
//  Created by Sin on 16/8/19.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCContactCardMessageCell.h"
#import "RCContactCardMessage.h"
#import "UIColor+RCCCColor.h"
#import "RCCCUtilities.h"
#import "RCloudImageView.h"

static CGFloat CELL_WIDTH = 0;

@interface RCMessageCell ()
@property (nonatomic, strong) UIView *destructView;
@end

@interface RCIMClient ()
- (NSNumber *)getDestructMessageRemainDuration:(NSString *)messageUId;
@end

@interface RCContactCardMessageCell ()
@property (nonatomic, strong) NSMutableArray *messageContentConstraint;

@property (nonatomic, strong) UILabel *typeLabel;     //个人名片的字样
@property (nonatomic, strong) UIView *separationView; //分割线
@property (nonatomic, assign) BOOL isConversationAppear;
@end

@implementation RCContactCardMessageCell

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {

    CGFloat __messagecontentview_height = 89;
    if (__messagecontentview_height < [RCIM sharedRCIM].globalMessagePortraitSize.height) {
        __messagecontentview_height = [RCIM sharedRCIM].globalMessagePortraitSize.height;
    }
    __messagecontentview_height += extraHeight;
    float screenRatio = 0.637;
    if (collectionViewWidth <= 320) {
        screenRatio = 0.6;
    }
    CELL_WIDTH = (collectionViewWidth * screenRatio) + 7;
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.messageContentConstraint = [[NSMutableArray alloc] init];

    //气泡view
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, 89)];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    self.bubbleBackgroundView.layer.cornerRadius = 4;
    self.bubbleBackgroundView.layer.masksToBounds = YES;
    self.bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = YES;

    //头像imageView
    self.portraitView = [[RCloudImageView alloc] initWithFrame:CGRectMake(16, 12, 45, 45)];
    [self.bubbleBackgroundView addSubview:self.portraitView];
    self.portraitView.translatesAutoresizingMaskIntoConstraints = YES;
    self.portraitView.layer.masksToBounds = YES;
    self.portraitView.layer.cornerRadius = 5.f;
    [self.portraitView
        setPlaceholderImage:[RCCCUtilities imageNamed:@"default_portrait_msg" ofBundle:@"RongCloud.bundle"]];

    //昵称label
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 + 45 + 12, 23, 100, 25)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:16.f]];
    [self.bubbleBackgroundView addSubview:self.nameLabel];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.nameLabel.textColor = [UIColor colorWithHexString:@"262626" alpha:1.f];
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;

    //分割线
    self.separationView = [[UIView alloc] initWithFrame:CGRectMake(16, 12 + 45 + 12, CELL_WIDTH - 12 * 2, 0.5)];
    self.separationView.backgroundColor = [UIColor colorWithHexString:@"ededed" alpha:1.f];
    self.separationView.translatesAutoresizingMaskIntoConstraints = YES;
    [self.bubbleBackgroundView addSubview:self.separationView];

    // typeLabel
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 12 + 45 + 12 + 1, 100, 20)];
    self.typeLabel.text = NSLocalizedStringFromTable(@"ContactCard", @"RongCloudKit", nil);
    self.typeLabel.font = [UIFont systemFontOfSize:9.f];
    self.typeLabel.textColor = [UIColor colorWithHexString:@"939393" alpha:1.f];
    [self.bubbleBackgroundView addSubview:self.typeLabel];

    //开启用户交互
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    self.bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = YES;
    //点击手势
    UITapGestureRecognizer *messageTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMessage:)];
    messageTap.numberOfTapsRequired = 1;
    messageTap.numberOfTouchesRequired = 1;
    [self.bubbleBackgroundView addGestureRecognizer:messageTap];

    //长按手势
    UILongPressGestureRecognizer *messageLongTap =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:messageLongTap];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateCell:)
                                                 name:@"RCKitDispatchUserInfoUpdateNotification"
                                               object:nil];
}

- (void)updateCell:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfoDic = notification.object;
        NSString *userId = userInfoDic[@"userId"];
        RCContactCardMessage *cardMessage = (RCContactCardMessage *)self.model.content;
        if ([userId isEqualToString:cardMessage.userId]) {
            RCUserInfo *userInfo = [[RCIM sharedRCIM] getUserInfoCache:userId];
            NSString *portraitUri = userInfo.portraitUri;
            [self.portraitView setImageURL:[NSURL URLWithString:portraitUri]];
        }
    });
}

- (void)tapMessage:(UIGestureRecognizer *)gestureRecognizer {

    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(didLongTouchMessageCell:inView:)]) {
            [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBackgroundView];
        }
    }
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    [self beginDestructing];
    [self setAutoLayout];
}

- (void)setAutoLayout {
    RCContactCardMessage *cardMessage = (RCContactCardMessage *)self.model.content;
    if (cardMessage) {
        self.nameLabel.text = cardMessage.name;
        NSString *portraitUri = cardMessage.portraitUri;
        if (portraitUri.length < 1) {
            RCUserInfo *userInfo = [[RCIM sharedRCIM] getUserInfoCache:cardMessage.userId];
            if (userInfo == nil || userInfo.portraitUri.length < 1) {
                if ([[RCIM sharedRCIM]
                            .userInfoDataSource respondsToSelector:@selector(getUserInfoWithUserId:completion:)]) {
                    [[RCIM sharedRCIM]
                            .userInfoDataSource
                        getUserInfoWithUserId:cardMessage.userId
                                   completion:^(RCUserInfo *userInfo) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [self.portraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];
                                       });
                                   }];
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.portraitView setImageURL:[NSURL URLWithString:userInfo.portraitUri]];
                });
            }
        } else {
            [self.portraitView setImageURL:[NSURL URLWithString:portraitUri]];
        }
    }

    CGSize bubbleBackgroundViewSize = [[self class] sizeOfMessageCell];
    CGRect messageContentViewRect = self.messageContentView.frame;

    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {
        self.portraitView.frame = CGRectMake(16, 12, 45, 45);
        self.nameLabel.frame = CGRectMake(16 + 45 + 12, 23, 100, 25);
        self.separationView.frame = CGRectMake(16, 12 + 45 + 12, CELL_WIDTH - 12 * 2 + 7, 0.5);
        self.typeLabel.frame = CGRectMake(16, 12 + 45 + 12 + 1, 100, 20);
        self.bubbleBackgroundView.frame =
            CGRectMake(0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);

        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
        self.messageContentView.frame = messageContentViewRect;

        self.bubbleBackgroundView.frame =
            CGRectMake(0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
        UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
        self.bubbleBackgroundView.image =
            [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8,
                                                                image.size.height * 0.2, image.size.width * 0.2)];
    } else {
        self.portraitView.frame = CGRectMake(12, 12, 45, 45);
        self.nameLabel.frame = CGRectMake(12 + 45 + 12, 22, 100, 25);
        self.separationView.frame = CGRectMake(12, 12 + 45 + 12, CELL_WIDTH - 7 - 12 * 2, 0.5);
        self.typeLabel.frame = CGRectMake(12, 12 + 45 + 12 + 1, 100, 20);
        self.bubbleBackgroundView.frame =
            CGRectMake(0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);

        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
        messageContentViewRect.origin.x =
            self.baseContentView.bounds.size.width - (messageContentViewRect.size.width + HeadAndContentSpacing +
                                                      [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);

        self.messageContentView.frame = messageContentViewRect;

        self.bubbleBackgroundView.frame =
            CGRectMake(0, 0, bubbleBackgroundViewSize.width, bubbleBackgroundViewSize.height);
        UIImage *image = [RCKitUtility imageNamed:@"chat_to_bg_white" ofBundle:@"RongCloud.bundle"];

        self.bubbleBackgroundView.image =
            [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2,
                                                                image.size.height * 0.2, image.size.width * 0.8)];
    }

    [self setDestructViewLayout];
}

- (void)beginDestructing {
    RCContactCardMessage *cardMessage = (RCContactCardMessage *)self.model.content;
    if (self.model.messageDirection == MessageDirection_RECEIVE && cardMessage.destructDuration > 0 &&
        [UIApplication sharedApplication].applicationState != UIApplicationStateBackground &&
        self.isConversationAppear) {
        [[RCIMClient sharedRCIMClient]
            messageBeginDestruct:[[RCIMClient sharedRCIMClient] getMessageByUId:self.model.messageUId]];
    }
}

- (void)setDestructViewLayout {
    RCContactCardMessage *cardMessage = (RCContactCardMessage *)self.model.content;
    if (cardMessage.destructDuration > 0) {
        self.destructView.hidden = NO;
        [self.messageContentView bringSubviewToFront:self.destructView];
        if (self.messageDirection == MessageDirection_RECEIVE) {
            self.destructView.frame = CGRectMake(CGRectGetMaxX(self.bubbleBackgroundView.frame) + 4.5,
                                                 CGRectGetMaxY(self.bubbleBackgroundView.frame) - 13 - 8.5, 21, 12);
        } else {
            self.destructView.frame = CGRectMake(CGRectGetMinX(self.bubbleBackgroundView.frame) - 25.5,
                                                 CGRectGetMaxY(self.bubbleBackgroundView.frame) - 13 - 8.5, 21, 12);
        }
    } else {
        self.destructView.hidden = YES;
        self.destructView.frame = CGRectZero;
    }
}

+ (CGSize)sizeOfMessageCell {
    return CGSizeMake(CELL_WIDTH, 89);
}

@end
