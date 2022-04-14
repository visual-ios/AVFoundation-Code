//
//  QXPreviewView.h
//  AFNetworking-Code
//
//  Created by 秦菥 on 2022/4/14.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface QXPreviewView : UIView

@property (nonatomic, strong) AVCaptureSession *session;

- (void)didDetectCodes:(NSArray *)codes;
@end

NS_ASSUME_NONNULL_END
