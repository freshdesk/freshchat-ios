//
//  HLCollectionView.m
//  HotlineSDK
//
//  Created by kirthikas on 22/09/15.
//  Copyright © 2015 Freshdesk. All rights reserved.
//

#import "HLCategoryGridViewController.h"
#import "HLGridViewCell.h"
#import "HLContainerController.h"
#import "HLArticlesController.h"
#import "KonotorDataManager.h"
#import "HLFAQServices.h"
#import "HLMacros.h"
#import "HLArticlesController.h"
#import "HLLocalNotification.h"
#import "HLCategory.h"
#import "FDSolutionUpdater.h"
#import "HLTheme.h"
#import "IconDownloader.h"

@interface HLCategoryGridViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *categories;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@end

@implementation HLCategoryGridViewController

-(void)willMoveToParentViewController:(UIViewController *)parent{
    parent.title = @"Collections View";
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageDownloadsInProgress = [NSMutableDictionary new];
    [self updateCategories];
    [self setupCollectionView];
    [self setNavigationItem];
    [self fetchUpdates];
    [self localNotificationSubscription];
}

-(void)setNavigationItem{
    UIImage *searchButtonImage = [HLTheme getImageFromMHBundleWithName:@"SearchButton"];

    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonAction:)];

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeButton:)];
    
    self.parentViewController.navigationItem.leftBarButtonItem = closeButton;
    self.parentViewController.navigationItem.rightBarButtonItem = searchButton;
}

-(void)searchButtonAction:(id)sender{
    NSLog(@"Launch");
}

-(void)updateCategories{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:HOTLINE_CATEGORY_ENTITY];
    NSSortDescriptor *position   = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
    request.sortDescriptors = @[position];
    NSError *error;
    NSArray *results =[[KonotorDataManager sharedInstance].mainObjectContext executeFetchRequest:request error:&error];
    if (results) {
        self.categories = results;
        [self.collectionView reloadData];
    }
}

-(void)fetchUpdates{
    FDSolutionUpdater *updater = [[FDSolutionUpdater alloc]init];
    [[KonotorDataManager sharedInstance]areSolutionsEmpty:^(BOOL isEmpty) {
        if(isEmpty){
            [updater resetTime];
        }
        [updater fetch];
    }];
}

-(void)closeButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)localNotificationSubscription{
    [[NSNotificationCenter defaultCenter]addObserverForName:HOTLINE_SOLUTIONS_UPDATED object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.categories = @[];
        [self updateCategories];
        NSLog(@"Got Notifications !!!");
    }];
}

-(void)setupCollectionView{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    NSDictionary *views = @{ @"collectionView" : self.collectionView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[collectionView]-10-|"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:views]];
    
    //Collection view subclass
    [self.collectionView registerClass:[HLGridViewCell class] forCellWithReuseIdentifier:@"FAQ_GRID_CELL"];
}

#pragma mark - Collection view delegat0e

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(!self.categories){
        return 0;
    }
    return [self.categories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger categoryCount = self.categories.count;
    HLGridViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"FAQ_GRID_CELL" forIndexPath:indexPath];
        if (categoryCount > 0){
            HLCategory *category = (self.categories)[indexPath.row];
            cell.label.text = category.title;
            // Only load cached images; defer new downloads until scrolling ends
            if (!category.icon){
                if (self.collectionView.dragging == NO && self.collectionView.decelerating == NO){
                    [self startIconDownload:category forIndexPath:indexPath];
                }
            }else{
                cell.imageView.image = [UIImage imageWithData:category.icon];
            }
        }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake( ([UIScreen mainScreen].bounds.size.height/5)+15, ([UIScreen mainScreen].bounds.size.height/5)+15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HLCategory *category = self.categories[indexPath.row];
    HLArticlesController *articleController = [[HLArticlesController alloc] initWithCategory:category];
    HLContainerController *container = [[HLContainerController alloc]initWithController:articleController];
    [self.navigationController pushViewController:container animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if IS_IPHONE {
        return self.view.bounds.size.width/25;
    }
    else if IS_IPAD{
        return self.view.bounds.size.width/45;
    }
    else{
        return self.view.bounds.size.width/25;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if IS_IPHONE {
        return self.view.bounds.size.width/25;
    }
    else if IS_IPAD{
        return self.view.bounds.size.width/45;
    }
    else{
        return self.view.bounds.size.width/25;
    }
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15,15,15,15);  // top, left, bottom, right
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutForCells = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
    for(int i = 1; i < [layoutForCells count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = layoutForCells[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = layoutForCells[i - 1];
        NSInteger maximumSpacing = 4;
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < 10) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return layoutForCells;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate){
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadImagesForOnscreenRows];
}

- (void)loadImagesForOnscreenRows{
    if (self.categories.count > 0){
        NSArray *visiblePaths = [self.collectionView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visiblePaths){
            HLCategory *category = (self.categories)[indexPath.row];
            if (!category.icon){
                [self startIconDownload:category forIndexPath:indexPath];
            }
        }
    }
}

- (void)startIconDownload:(HLCategory *)category forIndexPath:(NSIndexPath *)indexPath{
    IconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil){
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.category = category;
        __weak IconDownloader *temp = iconDownloader;
        [temp setCompletionHandler:^{

            HLGridViewCell *cell = (HLGridViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imageView.image = [UIImage imageWithData:temp.category.icon];
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = temp;
        [temp startDownload];
    }
}

- (void)terminateAllDownloads{
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
}

- (void)dealloc{
    [self terminateAllDownloads];
}

@end
