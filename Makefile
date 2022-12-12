# go/Makefile

OUT = ../build

clean:
	cd kagome; \
	rm -R $(OUT)



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
	go.exe build -o $(OUT)/win/libkagome_win_x86_64.dll -buildmode=c-shared kagome.go

windows-arm64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=windows \
	GOARCH=arm64 \
	go.exe build -o $(OUT)/win/libkagome_win_arm64.dll -buildmode=c-shared kagome.go

windows-universal: windows-x86_64 windows-arm64
	cd kagome; \
	lipo -create -output $(OUT)/mac/libkagome_mac.dylib $(OUT)/win/libkagome_win_x86_64.dll $(OUT)/win/libkagome_win_arm64.dll

windows: windows-universal


# MACOS
macos-x86_64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=darwin \
	GOARCH=amd64 \
	go build -buildmode=c-shared -o $(OUT)/mac/libkagome_mac_x86_64.dylib kagome.go

macos-arm64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=darwin \
	GOARCH=arm64 \
	SDKROOT=$(xcrun --sdk macosx --show-sdk-path) \
	go build -buildmode=c-shared -o $(OUT)/mac/libkagome_mac_arm64.dylib kagome.go

macos-merge-universal:
	cd kagome; \
	lipo -create -output $(OUT)/mac/libkagome_mac.dylib \
		$(OUT)/mac/libkagome_mac_x86_64.dylib \
		$(OUT)/mac/libkagome_mac_arm64.dylib

macos: macos-x86_64 macos-arm64 macos-universal


# ANDROID
android:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=amd64 \
	

# IOS
ios-arm64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=ios \
	GOARCH=arm64 \
	SDK=iphoneos \
	CC=$(PWD)/clangwrap.sh \
	CGO_CFLAGS="-fembed-bitcode" \
	go build -buildmode=c-archive -tags ios -o $(OUT)/ios/libkagome_ios_arm64.a kagome.go

ios-x86_64:
	cd kagome; \
	CGO_ENABLED=1 \
	GOOS=ios \
	GOARCH=amd64 \
	SDK=iphonesimulator \
	CC=$(PWD)/clangwrap.sh \
	go build -buildmode=c-archive -tags ios -o $(OUT)/ios/libkagome_ios_x86_64.a kagome.go

ios-universal: ios-arm64 ios-x86_64
	cd kagome; \
	lipo \
		$(OUT)/ios/libkagome_ios_x86_64.a \
		$(OUT)/ios/libkagome_ios_arm64.a \
		-create -output $(OUT)/ios/libkagome_ios.a; \
	xcodebuild -create-xcframework \
		-library $(OUT)/ios/libkagome_ios_x86_64.a \
		-library $(OUT)/ios/libkagome_ios_arm64.a \
		-output $(OUT)/ios/libkagome_ios.xcframework

ios: ios-universal