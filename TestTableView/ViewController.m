//
//  ViewController.m
//  TestTableView
//
//  Created by __无邪_ on 15/1/2.
//  Copyright (c) 2015年 __无邪_. All rights reserved.
//

#import "ViewController.h"
#import "DataInfo.h"


#define kDefaultCellHeight 45;
#define isAttached @"isAttached"
#define Cell @"Cell"

static NSString *CellIdentifier = @"LazyTableCell";
static NSString *AttachedViewIdentifier = @"AttachedViewIdentifier";


#////////////////////////////////////////////////////////////////////////////////
#pragma mark - MyTableViewCell
////////////////////////////////////////////////////////////////////////////////
@interface MyTableViewCell : UITableViewCell
@end
@implementation MyTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
        [view setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:view];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}
@end



#////////////////////////////////////////////////////////////////////////////////
#pragma mark - AttachedCell
////////////////////////////////////////////////////////////////////////////////

@interface AttachedCell : UITableViewCell
@end
@implementation AttachedCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}
@end

#////////////////////////////////////////////////////////////////////////////////
#pragma mark - AlertView
////////////////////////////////////////////////////////////////////////////////

void GAlertView(NSString *message,NSString *tite){
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:tite message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}



@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSIndexPath *showedIndexPath;
    int showState;//当为2时说明有子视图展开，当初始化为1时说明只显示一个子视图
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DataInfo *info = [[DataInfo alloc] init];
    info.identifier = CellIdentifier;
    info.isOpened = NO;
    info.dataDic = @{@"key":@"yyyyy"};
    
    showState = 1;
    
    NSArray * categoryArr = @[info,info,info,info,info,info,info];
    self.dataArr = [[NSMutableArray alloc] init];
    [self.dataArr addObjectsFromArray:categoryArr];
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:self.tableView];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    
//    GAlertView(@"alert", @"123");
    
    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableView registerClass:[AttachedCell class] forCellReuseIdentifier:AttachedViewIdentifier];
}



#////////////////////////////////////////////////////////////////////////////////
#pragma mark - DataSource
////////////////////////////////////////////////////////////////////////////////


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[self.dataArr[indexPath.row] identifier] isEqualToString:CellIdentifier]){
        
        MyTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",@"xxx"];
        return cell;
        
    }else if([[self.dataArr[indexPath.row] identifier] isEqualToString:AttachedViewIdentifier]){
        AttachedCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:AttachedViewIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",@" ssss"];
        return cell;
    }
    
    return nil;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.dataArr[indexPath.row] identifier] isEqualToString:CellIdentifier]){
        return kDefaultCellHeight;
    }else{
        return 100;
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleInsert;
}



#////////////////////////////////////////////////////////////////////////////////
#pragma mark - Delegate
////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"did select row %lu",indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (showState == 2) {//有打开的抽屉，先关闭已经打开的抽屉，再打开新的
        if ([[self.dataArr[indexPath.row] identifier] isEqualToString:CellIdentifier] && indexPath != showedIndexPath) {
            if (indexPath.row > showedIndexPath.row) {
                indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
            }
            [self controlFromIndexPath:showedIndexPath];
        }
    }
    
    [self controlFromIndexPath:indexPath];
}


- (void)controlFromIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *path = nil;
    
    

    if ([[self.dataArr[indexPath.row] identifier] isEqualToString:CellIdentifier]) {
        path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
    }else{
        path = indexPath;
    }
    
    if ([self.dataArr[indexPath.row] isOpened]) {//关闭
        DataInfo *info = [[DataInfo alloc] init];
        info.identifier = CellIdentifier;
        info.isOpened = NO;
        info.dataDic = [self.dataArr[path.row - 1] dataDic];
        
        self.dataArr[(path.row-1)] = info;
        [self.dataArr removeObjectAtIndex:path.row];
        
        if (2 == showState) {
            showState -= 1;
        }
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView endUpdates];
        
    }else{//打开
        DataInfo *info = [[DataInfo alloc] init];
        info.identifier = CellIdentifier;
        info.isOpened = YES;
        info.dataDic = [self.dataArr[path.row - 1] dataDic];
        self.dataArr[(path.row-1)] = info;
        
        if (1 == showState) {
            showedIndexPath = indexPath;
            showState += 1;
        }
        
        DataInfo *addInfo = [[DataInfo alloc] init];
        addInfo.identifier = AttachedViewIdentifier;
        addInfo.isOpened = YES;
        
        [self.dataArr insertObject:addInfo atIndex:path.row];
        
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView endUpdates];
        
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
