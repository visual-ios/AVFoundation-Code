//
//  QXCamera.m
//  AFNetworking-Code
//
//  Created by 秦菥 on 2022/4/14.
//

#import "QXCamera.h"

@interface QXCamera()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong, readwrite) AVCaptureSession *captureSession;
@property (nonatomic, weak) AVCaptureDeviceInput *activeVideoInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;
@end

@implementation QXCamera

- (BOOL)setupSession:(NSError **)error
{
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    AVCaptureDevice *videoDevice =
        [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (videoDevice.autoFocusRangeRestrictionSupported) {
        if ([videoDevice lockForConfiguration:error]) {
            videoDevice.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
            [videoDevice unlockForConfiguration];
        }
    }
    AVCaptureDeviceInput *videoInput =
        [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    if (videoInput) {
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        }
    } else {
        return NO;
    }
    
    self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    if ([self.captureSession canAddOutput:self.metadataOutput]) {
        [self.captureSession addOutput:self.metadataOutput];
        self.metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,                      // 1
                                                    AVMetadataObjectTypeAztecCode,
                                                    AVMetadataObjectTypeUPCECode];
        [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    } else {
        return NO;
    }
    
    return YES;
}

- (void)startSession {
    if (![self.captureSession isRunning]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.captureSession startRunning];
        });
    }
}

- (void)stopSession {
    if ([self.captureSession isRunning]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.captureSession stopRunning];
        });
    }
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([_delegate respondsToSelector:@selector(didDetectCodes:)]) {
        [_delegate didDetectCodes:metadataObjects];
    }
}
@end
