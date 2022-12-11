# go/Makefile

OUT = ./build


android:
	CGO_ENABLED=1 \
	GOOS=android \
	GOARCH=amd64 \
	

ios-arm64:
	CGO_ENABLED=1 \
	GOOS=ios \
	GOARCH=arm64 \
	SDK=iphoneos \
	CC=$(PWD)/clangwrap.sh \
	CGO_CFLAGS="-fembed-bitcode" \
	go build -buildmode=c-archive -tags ios -o $(OUT)/arm64.a kagome.go

ios-x86_64:
	CGO_ENABLED=1 \
	GOOS=ios \
	GOARCH=amd64 \
	SDK=iphonesimulator \
	CC=$(PWD)/clangwrap.sh \
	go build -buildmode=c-archive -tags ios -o $(OUT)/x86_64.a kagome.go

ios: ios-arm64 ios-x86_64
	lipo $(OUT)/x86_64.a $(OUT)/arm64.a -create -output $(OUT)/kagome_ios.a
	cp $(OUT)/arm64.h $(OUT)/kagome_ios.h