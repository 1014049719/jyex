//
//  ActivityCell.m
//  ysh


//

#import "ActivityCell.h"



@interface ActivityCell()

@end

@implementation ActivityCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSString *)url title:(NSString  *)strTitle pos:(NSInteger )nPos
{
    UIImage *imgg = [UIImage imageWithContentsOfFile:url];
    //CGSize size = imgg.size;
    self.img.image = imgg;
    self.lbTitle.text = strTitle;
    self.btnDel.tag = 1000+nPos;
}


+(instancetype)activityCellWithTableView:(UITableView *)tableview
{
    static NSString *CellIdentifier = @"ActivityCellIdentifier";
    static BOOL nibsRegistered = NO;
    
    if ( !nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ActivityCell class]) bundle:nil];
        [tableview registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    
    ActivityCell *cell = [tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;
}


@end
