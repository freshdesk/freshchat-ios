//
//  FDMessageController.m
//  HotlineSDK
//
//  Created by Aravinth Chandran on 27/10/15.
//  Copyright © 2015 Freshdesk. All rights reserved.
//

#import "FDMessageController.h"

@interface FDMessageController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *messages;

@end

@implementation FDMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeButton:)];
    self.navigationItem.leftBarButtonItem = closeButton;
    self.messages = @[@"Welcome to the conversations related to billing", @"how do i book using credit card",
                      @"you can use this link goo.le/d35Gfac"];
}

-(void)closeButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    NSDictionary *views = @{@"tableView" : self.tableView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:views]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"FDMessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row < self.messages.count) {
        cell.textLabel.text  = self.messages[indexPath.row];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

@end
