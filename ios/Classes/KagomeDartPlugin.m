#import "KagomeDartPlugin.h"
#if __has_include(<kagome_dart/kagome_dart-Swift.h>)
#import <kagome_dart/kagome_dart-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "kagome_dart-Swift.h"
#endif

@implementation KagomeDartPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKagomeDartPlugin registerWithRegistrar:registrar];
}
@end
