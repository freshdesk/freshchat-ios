//
//  HLChannelViewController.m
//  HotlineSDK
//
//  Created by user on 04/11/15.
//  Copyright © 2015 Freshdesk. All rights reserved.
//

#import "HLChannelViewController.h"
#import "HLMacros.h"
#import "HLTheme.h"
#import "FDLocalNotification.h"
#import "FDChannelUpdater.h"
#import "HLChannel.h"
#import "HLContainerController.h"
#import "FDMessageController.h"
#import "FDChannelListViewCell.h"
#import "KonotorMessage.h"
#import "KonotorConversation.h"
#import "FDDateUtil.h"
#import "KonotorUtil.h"
#import "FDUtilities.h"

@interface HLChannelViewController ()

@property (nonatomic, strong) NSArray *channels;

@end

@implementation HLChannelViewController

-(void)willMoveToParentViewController:(UIViewController *)parent{
    [super willMoveToParentViewController:parent];
    parent.title = @"Channels";
    HLTheme *theme = [HLTheme sharedInstance];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [theme channelTitleFontColor],
                                                           NSFontAttributeName: [theme channelTitleFont]
                                                           }];
    self.channels = [[NSMutableArray alloc] init];
    [self setNavigationItem];
    [self updateChannels];
    [self localNotificationSubscription];
}

-(BOOL)canDisplayFooterView{
    return NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [self fetchUpdates];
    self.footerView.hidden = YES;
}

-(void)updateChannels{
    [[KonotorDataManager sharedInstance]fetchAllVisibleChannels:^(NSArray *channels, NSError *error) {
        if (!error) {
            self.channels = channels;
            [self.tableView reloadData];
        }
    }];
}

-(void)setNavigationItem{
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]initWithTitle:HLLocalizedString(@"FAQ_GRID_VIEW_CLOSE_BUTTON_TITLE_TEXT") style:UIBarButtonItemStylePlain target:self action:@selector(closeButton:)];
    
    self.parentViewController.navigationItem.leftBarButtonItem = closeButton;
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
}

-(void)localNotificationSubscription{
    __weak typeof(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter]addObserverForName:HOTLINE_CHANNELS_UPDATED object:nil queue:nil usingBlock:^(NSNotification *note) {
        HideNetworkActivityIndicator();
        [weakSelf updateChannels];
    }];
}

-(void)fetchUpdates{
    FDChannelUpdater *updater = [[FDChannelUpdater alloc]init];
    [[KonotorDataManager sharedInstance]areChannelsEmpty:^(BOOL isEmpty) {
        if(isEmpty)[updater resetTime];
        ShowNetworkActivityIndicator();
        [updater fetchWithCompletion:^(BOOL isFetchPerformed, NSError *error) {
            if (!isFetchPerformed) HideNetworkActivityIndicator();
        }];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"HLChannelsCell";
    FDChannelListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[FDChannelListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row < self.channels.count) {
        HLChannel *channel =  self.channels[indexPath.row];
        KonotorConversation *conversation = channel.conversations.allObjects.firstObject;
        KonotorMessageData *lastMessage = [self getLastMessageInConversation:conversation];
        
        cell.titleLabel.text  = channel.name;
        
        if (lastMessage) {
            cell.detailLabel.text = [self getDetailDescriptionForMessage:lastMessage];
            NSDate* date=[NSDate dateWithTimeIntervalSince1970:lastMessage.createdMillis.longLongValue/1000];
            cell.lastUpdatedLabel.text= [FDDateUtil getStringFromDate:date];
            
        }else{
            cell.detailLabel.text = channel.welcomeMessage.text;
        }
        
        if (channel.icon) {
            cell.imgView.image = [UIImage imageWithData:channel.icon];
        }else{
            UIImage *placeholderImage = [FDChannelListViewCell generateImageForLabel:channel.name];
            if(channel.iconURL){
                NSURL *iconURL = [[NSURL alloc]initWithString:channel.iconURL];
                NSURLRequest *request = [[NSURLRequest alloc]initWithURL:iconURL];
                __weak FDChannelListViewCell *weakCell = cell;
                [cell.imgView setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    weakCell.imgView.image = image;
                    channel.icon = UIImagePNGRepresentation(image);
                    [[KonotorDataManager sharedInstance]save];
                } failure:nil];
            }else{
                cell.imgView.image = placeholderImage;
            }
        }
        
        [cell.badgeView updateBadgeCount:conversation.unreadMessagesCount.integerValue];

    }
    return cell;
}


-(NSString *)getDetailDescriptionForMessage:(KonotorMessageData *)message{
    
    NSString *description = nil;

    NSInteger messageType = message.messageType.integerValue;
    
    switch (messageType) {
        case KonotorMessageTypeText:
            description = message.text;
            break;
            
        case KonotorMessageTypeAudio:
            description = @"Audio message";
            break;
            
        case KonotorMessageTypePicture:
        case KonotorMessageTypePictureV2:{
            if (message.text) {
                description = message.text;
            }else{
                description = @"Picture message";
            }
            break;
        }
            
        default:
            description = message.text;
            break;
    }
    
    return description;
}

-(KonotorMessageData *)getLastMessageInConversation:(KonotorConversation *)conversation{
    NSSortDescriptor *sortDesc =[[NSSortDescriptor alloc] initWithKey:@"createdMillis" ascending:YES];
    NSArray *messages = [Konotor getAllMessagesForConversation:conversation.conversationAlias];
    return [messages sortedArrayUsingDescriptors:@[sortDesc]].lastObject;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    return self.channels.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.channels.count) {
        HLChannel *channel = self.channels[indexPath.row];
        FDMessageController *conversationController = [[FDMessageController alloc]initWithChannel:channel andPresentModally:NO];
        HLContainerController *container = [[HLContainerController alloc]initWithController:conversationController];
        [self.navigationController pushViewController:container animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

-(void)closeButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end