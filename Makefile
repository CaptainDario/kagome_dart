# go/Makefile

OUT = build

clean:
	cd kagome; \
	rm -R ../$(OUT)



# LINUX
linux-x86_64:
	cd kagome; \
	CGO_ENABLED=1

linux-arm64:
	cd kagome; \
	CGO_ENABLED=1

linux-universal: linux-x86_64 linux-arm64
	cd kagome; \

linux: linux-universal


# WINDOWS
windows-x86_64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=windows \
	GOARCH=amd64 \
	go.exe build -o ../$(OUT)/win/kagome_dart_win_x86_64.dll -buildmode=c-shared kagome.go

windows-arm64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=windows \
	GOARCH=arm64 \
	go.exe build -o ../$(OUT)/win/kagome_dart_win_arm64.dll -buildmode=c-shared kagome.go

windows-universal: windows-x86_64 windows-arm64
	cd kagome; \
	lipo -create -output ../$(OUT)/mac/kagome_dart_mac.dylib \
		../$(OUT)/win/kagome_dart_win_x86_64.dll \
		../$(OUT)/win/kagome_dart_win_arm64.dll

windows: windows-universal


# MACOS
macos-x86_64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=darwin \
	GOARCH=amd64 \
	go build -buildmode=c-shared -o ../$(OUT)/mac/kagome_dart_mac_x86_64.dylib kagome.go

macos-arm64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=darwin \
	GOARCH=arm64 \
	SDKROOT=$(xcrun --sdk macosx --show-sdk-path) \
	go build -buildmode=c-shared -o ../$(OUT)/mac/kagome_dart_mac_arm64.dylib kagome.go

macos-merge-universal:
	cd kagome; \
	lipo -create -output ../$(OUT)/mac/kagome_dart_mac.dylib \
		../$(OUT)/mac/kagome_dart_mac_x86_64.dylib \
		../$(OUT)/mac/kagome_dart_mac_arm64.dylib

macos: macos-x86_64 macos-arm64 macos-merge-universal


# ANDROID
android-amd64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=amd64 \
	CC=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/x86_64-linux-android21-clang \
	go build -buildmode=c-shared kagome.go -o ../$(OUT)/android/kagome_dart_droid_$GOARCH.so

android-amd32:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=amd32 \
	CC=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/i686-linux-android21-clang \
	go build -buildmode=c-shared kagome.go -o ../$(OUT)/android/kagome_dart_droid_$GOARCH.so

android-arm64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=arm64 \
	CC=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android21-clang \
	go build -buildmode=c-shared kagome.go -o ../$(OUT)/android/kagome_dart_droid_$GOARCH.so

android-arm32:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=arm32 \
	CC=$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi21-clang \
	go build -buildmode=c-shared kagome.go -o ../$(OUT)/android/kagome_dart_droid_$GOARCH.so

android: android-amd32 android-amd64 android-arm32 android-arm64


# IOS
ios-arm64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=darwin \
	GOARCH=arm64 \
	SDK=iphoneos \
	CC=$(PWD)/clangwrap.sh \
	CGO_CFLAGS="-fembed-bitcode" \
	go build -buildmode=c-archive -o ../$(OUT)/ios/kagome_dart_ios_arm64.a kagome.go

simulator-arm64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=darwin \
	GOARCH=arm64 \
	SDK=iphonesimulator \
	CGO_CFLAGS="-fembed-bitcode" \
	CC=$(PWD)/clangwrap.sh \
	go build -buildmode=c-archive -o ../$(OUT)/ios/kagome_dart_simulator_arm64.a kagome.go

simulator-x86_64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=darwin \
	GOARCH=amd64 \
	SDK=iphonesimulator \
	CGO_CFLAGS="-fembed-bitcode" \
	CC=$(PWD)/clangwrap.sh \
	go build -buildmode=c-archive -o ../$(OUT)/ios/kagome_dart_simulator_x86_64.a kagome.go

ios-universal: ios-arm64 simulator-x86_64
	cd kagome; \
	lipo \
		../$(OUT)/ios/kagome_dart_simulator_x86_64.a \
		../$(OUT)/ios/kagome_dart_simulator_arm64.a \
		-create -output ../$(OUT)/ios/kagome_dart_simulator.a; \

	xcodebuild -create-xcframework \
		-library $(OUT)/ios/kagome_dart_simulator_arm64.a \
		-library $(OUT)/ios/kagome_dart_ios_arm64.a \
		-output  $(OUT)/ios/kagome_dart.xcframework

ios: ios-universal


wasm:
	cd kagome; \
	GOOS=js \
	GOARCH=wasm \
	go build -o ../$(OUT)/wasm/kagome_dart.wasm