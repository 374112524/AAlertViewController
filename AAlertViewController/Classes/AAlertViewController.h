//
//  AAlertViewController.h
//  FMHAppModule
//
//  Created by Y on 2020/8/27.
//  Copyright © 2020 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AAlertViewController;
/// @param buttonIndex addAction的顺序，和ActionStyle无关
typedef void (^CustomAlertActionBlock)(NSInteger buttonIndex, UIAlertAction * action, AAlertViewController * alertSelf);

typedef void(^CustomAlertAddTitle)(NSString * string,UIColor * _Nullable unitColor);


@interface AAlertViewController : UIAlertController

@property (nonatomic, copy) CustomAlertAddTitle addDefaultTitle;
@property (nonatomic, copy) CustomAlertAddTitle addCancelTitle;
@property (nonatomic, copy) CustomAlertAddTitle addDestructiveTitle;

@end

typedef void(^CustomAlertAppearanceProcess)(AAlertViewController * alertMaker);

@interface UIViewController (CustomAlertViewController)

/// @param title 标题
/// @param message 内容
/// @param msgAttributes 当前message内容颜色和大小的修改 默认@{NSForegroundColorAttributeName: CustomBlackColor3, NSFontAttributeName:CustomFont14}
/// @param appearanceProcess  按钮的文字以及颜色设置
/// @param actionBlock 按钮的点击方法
- (void)showAlertWithTitle:(NSString * _Nullable)title
                   message:(NSString * _Nullable)message
         messageAttributes:(NSDictionary<NSAttributedStringKey, id> *_Nullable)msgAttributes
                     image:(UIImage * _Nullable)image
            appearanceProcess:(CustomAlertAppearanceProcess )appearanceProcess
                 actionsBlock:(CustomAlertActionBlock )actionBlock;
@end
NS_ASSUME_NONNULL_END
