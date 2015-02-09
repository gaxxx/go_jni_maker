#!/bin/bash
export CC=/opt/android-ndk/bin/arm-linux-androideabi-gcc
export ARMABI=armeabi-v7a
export GOLIB=testgojni




MODULE_DIR=`realpath ..`
MODULE_LIB_DIR="$MODULE_DIR/src/main/jniLibs/$ARMABI"
MODULE_SRC_DIR="$MODULE_DIR/src/main/java/go"
mkdir -p $MODULE_LIB_DIR $MODULE_SRC_DIR $MODULE_SRC_DIR/$GOLIB
mkdir $GOPATH/src/$GOLIB/go_jni
gobind -lang=go $GOLIB > $GOPATH/src/$GOLIB/go_jni/go_jni.go
UGOLIB=`echo ${GOLIB:0:1} | tr  '[a-z]' '[A-Z]'`${GOLIB:1}
gobind -lang=java $GOLIB >  $MODULE_SRC_DIR/$GOLIB/$UGOLIB.java

ln -sf $GOPATH/src/golang.org/x/mobile/bind/java/Seq.java $MODULE_SRC_DIR
ln -sf $GOPATH/src/golang.org/x/mobile/app/Go.java $MODULE_SRC_DIR
sed  "s#JNI_LIB#$GOLIB/go_jni#" < main.base > main.go
CGO_ENABLED=1  GOOS=android GOARCH=arm GOARM=7 go build -ldflags=-shared -o $MODULE_LIB_DIR/libgojni.so .
