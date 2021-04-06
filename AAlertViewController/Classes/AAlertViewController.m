//
//  CustomAlertViewController.m
//  FMHAppModule
//
//  Created by Y on 2020/8/27.
//  Copyright © 2020 . All rights reserved.
//

#import "AAlertViewController.h"
#import "Masonry.h"

#define messageColor [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1.0]
#define messageFont [UIFont systemFontOfSize:14.0]

#pragma mark - —— AAlertActionModel ——

@interface AAlertActionModel : NSObject

@property (nonatomic, copy) NSString * title;

@property (nonatomic, assign) UIAlertActionStyle style;

@property (nonatomic, strong) UIColor * unitColor;

@end

@implementation AAlertActionModel

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"";
        self.style = UIAlertActionStyleDefault;
    }
    return self;
}

@end

#pragma mark - —— AAlertViewController ——

@interface AAlertViewController ()

{
    BOOL _isConfiged;
}
//AlertActionModel数组
@property (nonatomic, strong) NSMutableArray <AAlertActionModel *>* alertActionModelArray;
//action配置
@property (nonatomic, copy) void (^CustomAlertActionsConfig)(CustomAlertActionBlock);

@property (nonatomic, strong) UIImageView * _Nullable imageView;

@end

@implementation AAlertViewController

- (instancetype)initAlertControllerWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    if (title == nil) {
        title = @"";
    }
    if (message == nil) {
        message = @"";
    }
    
    self = [[self class] alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    _isConfiged = YES;
    if (image) {
        _isConfiged = NO;
        self.imageView.image = image;
    }
    if (!self) return nil;
    
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
}

- (void (^)(CustomAlertActionBlock))CustomAlertActionsConfig
{
    return ^(CustomAlertActionBlock actionBlock) {
        
        if (self.alertActionModelArray.count > 0) {
            
            __weak typeof(self)weakSelf = self;
            [self.alertActionModelArray enumerateObjectsUsingBlock:^(AAlertActionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:obj.title style:obj.style handler:^(UIAlertAction * _Nonnull action) {
                    
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    
                    if (actionBlock) {
                        actionBlock(idx,action,strongSelf);
                    }
                }];
                [action setValue:obj.unitColor ? obj.unitColor: messageColor forKey:@"titleTextColor"];
                [weakSelf addAction:action];
            }];
        }
        else {
            __weak typeof(self)weakSelf = self;
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                if (actionBlock) {
                    actionBlock(0,action,strongSelf);
                }
            }];
            [weakSelf addAction:action];
        }
    };
}

- (CustomAlertAddTitle)addDefaultTitle
{
    return ^(NSString *string,UIColor *unitColor){
        
        AAlertActionModel *model = [[AAlertActionModel alloc] init];
        model.title = string;
        model.style = UIAlertActionStyleDefault;
        model.unitColor = unitColor;
        [self.alertActionModelArray addObject:model];
    };
}

- (CustomAlertAddTitle)addCancelTitle
{
    return ^(NSString *string,UIColor *unitColor){
        
        AAlertActionModel *model = [[AAlertActionModel alloc] init];
        model.title = string;
        model.style = UIAlertActionStyleCancel;
        model.unitColor = unitColor;
        [self.alertActionModelArray addObject:model];
    };
}

- (CustomAlertAddTitle)addDestructiveTitle
{
    return ^(NSString *string,UIColor *unitColor){
        
        AAlertActionModel *model = [[AAlertActionModel alloc] init];
        model.title = string;
        model.style = UIAlertActionStyleDestructive;
        model.unitColor = unitColor;
        [self.alertActionModelArray addObject:model];
    };
}

- (NSMutableArray<AAlertActionModel *> *)alertActionModelArray
{
    if (!_alertActionModelArray) {
        _alertActionModelArray = [NSMutableArray array];
    }
    return _alertActionModelArray;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeCenter;
        UIView * view  = self.view.subviews[0].subviews[0].subviews[0].subviews[0].subviews[0];
        [view addSubview:_imageView];
        if (view.subviews.count>2) {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_offset(0);
                make.top.equalTo(view.subviews[1].mas_bottom).offset(10);
            }];
        }else{
            _imageView.hidden = YES;
        }
    }
    return _imageView;
}

- (void) viewDidLayoutSubviews {
    if (!_isConfiged) {
        _isConfiged = YES;
        [self adjustTitle:self.imageView];
    }
    [super viewDidLayoutSubviews];
}

-(void) adjustTitle:(UIImageView *) imageView {
    if (self.imageView.hidden) {
        return;
    }
    CGFloat lineHeight = messageFont.lineHeight;
//    NSLog(@"----lineHeight: %f, imageView.height: %f", lineHeight, imageView.bounds.size.height);
    int lines = ceil(imageView.image.size.height / lineHeight) + 1;
//    NSLog(@"----lines: %d", lines);
    NSMutableString *originTitle = [NSMutableString stringWithCapacity:self.message.length];
    [originTitle appendString:self.message];
    for (int i = 0; i < lines; i ++ ) {
        [originTitle insertString:@"\n" atIndex:0];
    }
    self.message = originTitle;
}

- (void)dealloc {
    
    NSLog(@"alert dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

#pragma mark - —— UIViewController 扩展 ——

@implementation UIViewController (CustomAlertViewController)

- (void)showAlertWithPreferredStyle:(UIAlertControllerStyle)preferredStyle title:(NSString *)title message:(NSString *)message messageAttributes:(NSDictionary<NSAttributedStringKey, id> *)msgAttributes image:(UIImage *)image  appearanceProcess:(CustomAlertAppearanceProcess)appearanceProcess actionsBlock:(CustomAlertActionBlock)actionBlock
{
    if (appearanceProcess)
    {
        AAlertViewController *alertMaker = [[AAlertViewController alloc] initAlertControllerWithTitle:title message:message image:image preferredStyle:preferredStyle];
        
        NSMutableAttributedString *attrMessage = [[NSMutableAttributedString alloc]initWithString:message attributes: @{NSForegroundColorAttributeName: messageColor, NSFontAttributeName:messageFont}];
        
        if (msgAttributes) {
            [attrMessage setAttributes:msgAttributes range:NSMakeRange(0, message.length)];
        }
        
        [alertMaker setValue: attrMessage forKey: @"attributedMessage"];
        //防止nil
        if (!alertMaker) {
            return ;
        }
        //加工链
        appearanceProcess(alertMaker);
        //配置响应
        alertMaker.CustomAlertActionsConfig(actionBlock);
        
        [self presentViewController:alertMaker animated:YES completion:nil];
    }
}

- (void)showAlertWithTitle:(NSString * _Nullable)title
          message:(NSString * _Nullable)message
messageAttributes:(NSDictionary<NSAttributedStringKey, id> *_Nullable)msgAttributes
            image:(UIImage * _Nullable)image
   appearanceProcess:(CustomAlertAppearanceProcess _Nonnull)appearanceProcess
        actionsBlock:(CustomAlertActionBlock _Nonnull)actionBlock;
{
    [self showAlertWithPreferredStyle:UIAlertControllerStyleAlert title:title message:message messageAttributes:msgAttributes image:image appearanceProcess:appearanceProcess actionsBlock:actionBlock];
}

@end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
