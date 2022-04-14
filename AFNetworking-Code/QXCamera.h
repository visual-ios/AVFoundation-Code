//
//  QXCamera.h
//  AFNetworking-Code
//
//  Created by 秦菥 on 2022/4/14.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@class QXCamera;

@protocol QXCameraDelegate <NSObject>

- (void)didDetectCodes:(NSArray <AVMetadataObject*>*)codes;

@end


@interface QXCamera : NSObject

@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;

@property (nonatomic, weak) id<QXCameraDelegate>delegate;


- (BOOL)setupSession:(NSError **)error;
- (void)startSession;
- (void)stopSession;

@end

NS_ASSUME_NONNULL_END
