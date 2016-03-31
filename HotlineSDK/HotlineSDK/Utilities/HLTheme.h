//
//  HLTheme.h
//  HotlineSDK
//
//  Created by Aravinth Chandran on 30/09/15.
//  Copyright © 2015 Freshdesk. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGE_SEARCH_ICON @"Search"
#define IMAGE_CONTACT_US_ICON @"ContactUsIcon"
#define IMAGE_CONTACT_US_LIGHT_ICON @"ContactUsLightIcon"
#define IMAGE_BACK_BUTTON @"BackButton"
#define IMAGE_CLOSE_PREVIEW @"CloseImagePreview"
#define IMAGE_ATTACH_ICON @"AttachmentUpload"
#define IMAGE_BUBBLE_CELL_LEFT @"BubbleLeft"
#define IMAGE_BUBBLE_CELL_RIGHT @"BubbleRight"
#define IMAGE_AUDIO_TOOLBAR_CANCEL @"AudioToolbarCancel"
#define IMAGE_INPUT_TOOLBAR_MIC @"Mic"
#define IMAGE_SEND_ICON @"Send"
#define IMAGE_MESSAGE_SENDING_ICON @"MessageSending"
#define IMAGE_MESSAGE_SENT_ICON @"MessageSent"
#define IMAGE_PLACEHOLDER @"ImagePlaceholder"
#define IMAGE_AVATAR_USER @"UserAvatarImage"
#define IMAGE_AVATAR_AGENT @"AgentAvatarImage"
#define IMAGE_AUDIO_PLAY_BUTTON @"AudioMessagePlayButton"
#define IMAGE_AUDIO_STOP_BUTTON @"AudioMessageStopButton"
#define IMAGE_AUDIO_PROGRESS_BAR_MIN @"AudioProgessBarMin"
#define IMAGE_AUDIO_PROGRESS_BAR_MAX @"AudioProgessBarMax"
#define IMAGE_TABLEVIEW_ACCESSORY_ICON @"TableViewAccessoryIcon"
#define IMAGE_NOTIFICATION_CANCEL_ICON @"NotificationCancel"
#define IMAGE_CHANNEL_ICON @"ChannelImage"
#define IMAGE_FAQ_ICON @"FAQImage"
#define IMAGE_EMPTY_SEARCH_ICON @"EmptySearchImage"

@interface HLTheme : NSObject

@property (strong, nonatomic) NSString *themeName;

+ (instancetype)sharedInstance;
-(void)setThemeName:(NSString *)themeName;
-(UIColor *)searchBarInnerBackgroundColor;
+(UIColor *)colorWithHex:(NSString *)value;

//Search Bar
-(UIFont *)searchBarFont;
-(UIFont *)searchBarCancelButtonFont;
-(UIColor *)searchBarFontColor;
-(UIColor *)searchBarOuterBackgroundColor;
-(UIColor *)searchBarCancelButtonColor;
-(UIColor *)searchBarCursorColor;

//Table View
-(UIFont *)tableViewCellTitleFont;
-(UIColor *)tableViewCellTitleFontColor;
-(UIFont *)tableViewCellDetailFont;
-(UIColor *)tableViewCellDetailFontColor;
-(UIColor *)tableViewCellBackgroundColor;
-(UIColor *)tableViewCellSeparatorColor;
- (int)numberOfChannelListDescriptionLines;
- (int)numberOfCategoryListDescriptionLines;

//Article Table View
-(UIColor *)articleListFontColor;
-(UIFont *)articleListFont;

//Overall SDK
-(UIColor *)backgroundColorSDK;
-(UIColor *)noItemsFoundMessageColor;
-(UIColor *)channelIconPalceholderImageBackgroundColor;
-(UIFont *)channelIconPlaceholderImageCharFont;

//Talk to us button
-(UIFont *)talkToUsButtonFont;
-(UIColor *)talkToUsButtonTextColor;
-(UIColor *)talkToUsButtonBackgroundColor;

//Dialogues
-(UIFont *)dialogueTitleFont;
-(UIColor *)dialogueTitleTextColor;
-(UIFont *)dialogueYesButtonFont;
-(UIColor *)dialogueYesButtonTextColor;
-(UIColor *)dialogueYesButtonBackgroundColor;
-(UIColor *)dialogueNoButtonBorderColor;
-(UIColor *)dialogueYesButtonBorderColor;
-(UIColor *)dialogueNoButtonBackgroundColor;
-(UIFont *)dialogueNoButtonFont;
-(UIColor *)dialogueNoButtonTextColor;
-(UIColor *)dialogueBackgroundColor;
-(UIColor *)dialogueButtonColor;

//NavigationBar
-(UIColor *)navigationBarBackgroundColor;
-(UIFont *)navigationBarTitleFont;
-(UIColor *)navigationBarTitleColor;
-(UIColor *)navigationBarButtonColor;
-(UIFont *)navigationBarButtonFont;


//Messagecell & Conversation UI
-(UIColor *)inputTextFontColor;
-(UIFont *) inputTextFont;
-(UIColor *)sendButtonColor;

-(UIColor *)actionButtonTextColor;
-(UIColor *)actionButtonSelectedTextColor;
-(UIColor *)actionButtonColor;
-(UIColor *)actionButtonBorderColor;
-(UIColor *)hyperlinkColor;
//-(NSString *)chatBubbleFontName;
-(NSString *)conversationUIFontName;
//-(float)chatBubbleFontSize;
-(UIFont *)getChatBubbleMessageFont;
-(UIFont *)getChatbubbleTimeFont;
- (UIColor *) agentMessageFontColor;
- (UIColor *) userMessageFontColor;

//Notification
-(UIColor *)notificationBackgroundColor;
-(UIColor *)notificationTitleTextColor;
-(UIColor *)notificationMessageTextColor;
-(UIFont *)notificationTitleFont;
-(UIFont *)notificationMessageFont;
-(UIColor *)notificationChannelIconBorderColor;

//Grid View Cell
-(UIFont *)gridViewCellTitleFont;
-(UIColor *)gridViewCellTitleFontColor;
-(UIColor *)gridViewCellBackgroundColor;
-(UIColor *)gridViewImageBackgroundColor;
-(UIColor *) gridViewCellBorderColor;

//Conversation List View
-(UIColor *)channelListCellBackgroundColor;
-(UIFont *)channelTitleFont;
-(UIColor *)channelTitleFontColor;
-(UIFont *)channelDescriptionFont;
-(UIFont *)channelDescriptinLines;
-(UIColor *)channelDescriptionFontColor;
-(UIFont *)channelLastUpdatedFont;
-(UIColor *)channelLastUpdatedFontColor;
-(UIFont *)badgeButtonFont;
-(UIColor *)badgeButtonBackgroundColor;
-(UIColor *)badgeButtonTitleColor;

//Message Conversation Overlay

- (UIColor *) conversationOverlayBackgroundColor;
- (UIFont *) conversationOverlayTextFont;
- (UIColor *) conversationOverlayTextColor;

//Empty Result
-(UIColor *)emptyResultMessageFontColor;
-(UIFont *)emptyResultMessageFont;

//Footer
- (NSString *) getFooterSecretKey;

//Chat bubble insets
- (UIEdgeInsets) getAgentBubbleInsets;
- (UIEdgeInsets) getUserBubbleInsets;

//Voice Recording Prompt
-(UIFont *)voiceRecordingTimeLabelFont;

-(UIImage *)getImageWithKey:(NSString *)key;

-(NSString *)getCssFileContent:(NSString *)key;
@end