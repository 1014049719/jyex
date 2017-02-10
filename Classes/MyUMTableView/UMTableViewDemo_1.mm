//
//  UMTableViewDemo.m
//  UMAppNetwork
//
//  Created by liu yu on 12/17/11.
//  Copyright (c) 2011 Realcent. All rights reserved.
//

#import "UMTableViewDemo.h"
#import "UMTableViewCell.h"
    
@implementation UMTableViewDemo

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

- (void)dealloc {
    _mTableView.dataLoadDelegate = nil;
    [_mTableView removeFromSuperview];
    _mTableView = nil;
    [_mPromoterDatas release];
    _mPromoterDatas = nil;
    [statusLabel release];
    statusLabel = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [noNetworkImageView release];
    noNetworkImageView = nil;
    [maskView removeFromSuperview];
    [maskView release];
    maskView = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"精彩推荐";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.view.backgroundColor = [UIColor whiteColor];
    
    maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor lightGrayColor];
    
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 300, 21)];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    statusLabel.text = @"正在加载数据，请稍等...";
    statusLabel.textAlignment = UITextAlignmentCenter;
    [maskView addSubview:statusLabel];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.backgroundColor = [UIColor clearColor];
    activityIndicator.frame = CGRectMake(145, 190, 30, 30);
    [maskView addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    _mPromoterDatas = [[NSMutableArray alloc] init];
    
    _mTableView =  [[UMUFPTableView alloc] initWithFrame:CGRectMake(0, 44, 320, 460-44) style:UITableViewStylePlain appkey:@"4f7046375270156912000011" slotId:nil currentViewController:self];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.dataLoadDelegate = (id<UMUFPTableViewDataLoadDelegate>)self;
    [self.view addSubview:_mTableView];
    [_mTableView release];
    
    //如果设置了tableview的dataLoadDelegate，请在viewController销毁时将tableview的dataLoadDelegate置空，这样可以避免一些可能的delegate问题，虽然我有在tableview的dealloc方法中将其置空
    
    [self.view insertSubview:maskView aboveSubview:_mTableView];
    
    [_mTableView requestPromoterDataInBackground];
}

- (void)viewDidUnload
{
    //发送退出消息
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!_mTableView.mIsAllLoaded && [_mPromoterDatas count] > 0)
    {
        return [_mPromoterDatas count] + 1;
    }
    else if (_mTableView.mIsAllLoaded && [_mPromoterDatas count] > 0)
    {
        return [_mPromoterDatas count];
    }
    else 
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UMUFPTableViewCell";
    
    if (indexPath.row < [_mPromoterDatas count])
    {
        UMTableViewCell *cell = (UMTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UMTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
        
        NSDictionary *promoter = [_mPromoterDatas objectAtIndex:indexPath.row];
        cell.textLabel.text = [promoter valueForKey:@"title"];
        cell.detailTextLabel.text = [promoter valueForKey:@"ad_words"];
        [cell setImageURL:[promoter valueForKey:@"icon"]];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"UMUFPTableViewCell2"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UMUFPTableViewCell2"] autorelease];
        }
        
        UILabel *addMoreLabel = [[[UILabel alloc] initWithFrame:CGRectMake(120, 20, 120, 30)] autorelease];
        addMoreLabel.backgroundColor = [UIColor clearColor];
        addMoreLabel.textAlignment = UITextAlignmentCenter;
        addMoreLabel.font = [UIFont boldSystemFontOfSize:14];
        addMoreLabel.text = @"加载中...";
        [cell.contentView addSubview:addMoreLabel];
        
        UIActivityIndicatorView *loadingIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        loadingIndicator.backgroundColor = [UIColor clearColor];
        loadingIndicator.frame = CGRectMake(115, 20, 30, 30);
        [loadingIndicator startAnimating];
        [cell.contentView addSubview:loadingIndicator];
        
        return cell;
    }    
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [_mPromoterDatas count])
    {
        NSDictionary *promoter = [_mPromoterDatas objectAtIndex:indexPath.row];
        [_mTableView didClickPromoterAtIndex:promoter index:indexPath.row];
    }
}

#pragma mark - UMTableViewDataLoadDelegate methods

- (void)removeLoadingMaskView {
    
    if ([maskView superview])
    {        
        [maskView removeFromSuperview];
    }
}

- (void)loadDataFailed {
    
    activityIndicator.hidden = YES;
    
    if (!noNetworkImageView)
    {
        UIImage *image = [UIImage imageNamed:@"um_no_network.png"];
        CGSize imageSize = image.size;
        noNetworkImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - imageSize.width) / 2, 100, imageSize.width, imageSize.height)];
        noNetworkImageView.image = image;
    }
    
    if (![noNetworkImageView superview])
    {
        [maskView addSubview:noNetworkImageView];
    }
    
    statusLabel.text = @"抱歉，网络连接不畅，请稍后再试！";
}

- (void)UMUFPTableViewDidLoadDataFinish:(UMUFPTableView *)tableview promoters:(NSArray *)promoters {
    
    if ([promoters count] > 0)
    {
        [self removeLoadingMaskView];
        
        [_mPromoterDatas addObjectsFromArray:promoters];
        [_mTableView reloadData];
    }  
    else if ([_mPromoterDatas count])
    {
        [_mTableView reloadData];
    }
    else 
    {
        [self loadDataFailed];
    }    
}

- (void)UMUFPTableView:(UMUFPTableView *)tableview didLoadDataFailWithError:(NSError *)error {
    
    if ([_mPromoterDatas count])
    {
        [_mTableView reloadData];
    }
    else 
    {
        [self loadDataFailed];
    }
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize contentSize = scrollView.contentSize;
    UIEdgeInsets contentInset = scrollView.contentInset;
    
    float y = contentOffset.y + bounds.size.height - contentInset.bottom;
    if (y > contentSize.height-30) 
    {
        if (!_mTableView.mIsAllLoaded && !_mTableView.mIsLoadingMore)
        {
            [_mTableView requestMorePromoterInBackground];
        }
    }    
}



@end