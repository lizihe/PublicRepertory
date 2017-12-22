//
//  CustomHostsView.m
//  HostsChangeDemo
//
//  Created by Mr_zhaohy on 2017/11/9.
//  Copyright © 2017年 Mr_zhaohy. All rights reserved.
//

#import "CustomHostsView.h"
#import "HostsManager.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WINDOW [UIApplication sharedApplication].keyWindow

@interface CustomHostsView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UIButton *addBtn;
@property (nonatomic,strong)UILabel *tipLabel;
@property (nonatomic,strong)UIButton *cancelBtn;

@end

@implementation CustomHostsView

-(instancetype)init{
    self = [super init];
    self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    [self createSubview];
    return self;
}

-(void)createSubview{
    self.bgView = [[UIView alloc]init];
    self.bgView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - ((375.0/WIDTH) * 260));
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (self.bgView.bounds.size.height + self.bgView.bounds.origin.y) + 35, WIDTH-30, 100)];
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = [UIColor lightGrayColor];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.text = @"注：输入的地址请注意格式，侧滑列表可进行设置默认/删除操作;\n此功能仅为开发使用，目前仅支持摇一摇开启,上线版本不会开启此功能。";
    [self addSubview:self.tipLabel];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.bgView.bounds style:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 0, self.bgView.bounds.size.width, self.bgView.bounds.size.height - 30);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.bgView addSubview:_tableView];
    
    self.textField = [[UITextField alloc] init];
    self.textField.frame = CGRectMake(15, 30, WIDTH - 130, 40);

    self.textField.placeholder= @"请输入地址(注意http/https)";
    self.textField.text= @"http://";
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.textField];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.addBtn.frame = CGRectMake(self.textField.frame.origin.x + self.textField.frame.size.width, 30, 50, 40);
    [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addBtn];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelBtn.frame = CGRectMake(self.textField.frame.origin.x + self.textField.frame.size.width + self.addBtn.bounds.size.width, 30, 50, 40);
    [self.cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
}

-(void)show{
    [WINDOW addSubview:self];
}

-(void)dismiss{
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(customHostsViewDismiss)]) {
        [self.delegate customHostsViewDismiss];
    }
}

-(void)cancelBtnClick{
    [self dismiss];
}

-(void)addBtnClick{
    if ([_textField.text isEqualToString:@"http://"] || [_textField.text isEqualToString:@"https://"] || !_textField.text.length) {
        return;
    }
    
    [[HostsManager shared] addHostsUrl:_textField.text default:YES];
    [self defaultUrl:_textField.text];

    _textField.text = @"http://";
    
    [self.tableView reloadData];
    
    [self endEditing:YES];
}

-(void)defaultUrl:(NSString *)url{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setDefaultWithUrl:)]) {
        [self.delegate setDefaultWithUrl:url];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    BOOL defaultHosts = [[HostsManager shared].hostsArray[indexPath.row][DefaultHosts] boolValue];
    
    cell.backgroundColor = defaultHosts ? [UIColor greenColor] : [UIColor whiteColor];
    cell.textLabel.text = [HostsManager shared].hostsArray[indexPath.row][HostsUrl];
    
    cell.userInteractionEnabled = !defaultHosts;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL defaultHosts = [[HostsManager shared].hostsArray[indexPath.row][DefaultHosts] boolValue];
    if (defaultHosts) {
        return @[];
    }
    NSString *url = [HostsManager shared].hostsArray[indexPath.row][HostsUrl];
    UITableViewRowAction *defaultAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"默认" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[HostsManager shared] addHostsUrl:url default:YES];
        [self defaultUrl:url];

        [tableView reloadData];
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[HostsManager shared] removeHostsUrl:url];
        [tableView reloadData];
    }];
    
    return @[deleteAction,defaultAction];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"当前:%@",[HostsManager shared].currentHostsUrl];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [HostsManager shared].hostsArray.count;
}

@end
