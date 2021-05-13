#临时解压目录
TEMP_PATH="${SRCROOT}/Temp"
#资源文件夹，我们提前在工程目录下新建一个APP文件夹，里面放ipa包（砸壳后的）
ASSETS_PATH="${SRCROOT}/APP"
#目标ipa包路径
#TARGET_IPA_PATH="${ASSETS_PATH}/*.app"


#清空&创建Temp文件夹
rm -rf "$TEMP_PATH"
mkdir -p "$TEMP_PATH"


## 1. 解压IPA到Temp目录下
#unzip -oqq "$TARGET_IPA_PATH" -d "$TEMP_PATH"
## 拿到解压后的临时的APP的路径
#TEMP_APP_PATH=$(set -- "$TEMP_PATH/Payload/"*.app;echo "$1")

TEMP_APP_PATH=$(set -- "${ASSETS_PATH}/"*.app;echo "$1")


#2. 将解压出来的.app拷贝进入工程下
#2.1拿到当前工程目标Target路径
# BUILT_PRODUCTS_DIR 工程生成的APP包的路径
# TARGET_NAME target名称
TARGET_APP_PATH="$BUILT_PRODUCTS_DIR/$TARGET_NAME.app"
echo "app path:$TARGET_APP_PATH"

#2.2删除工程本身的Target，将解压的Target拷贝到工程本身的路径
rm -rf "$TARGET_APP_PATH"
mkdir -p "$TARGET_APP_PATH"
cp -rf "$TEMP_APP_PATH/" "$TARGET_APP_PATH"


# 3. 删除extension和WatchAPP，个人证书没法签名Extention
rm -rf "$TARGET_APP_PATH/PlugIns"
rm -rf "$TARGET_APP_PATH/Watch"



# 4. 更新info.plist文件 CFBundleIdentifier
#  设置:"Set : KEY Value" "目标文件路径"，PlistBuddy是苹果自带的。
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $PRODUCT_BUNDLE_IDENTIFIER" "$TARGET_APP_PATH/Info.plist"

#删除UISupportedDevices设备相关配置(越狱手机dump ipa包需要删除相关配置)
#/usr/libexec/PlistBuddy -c "Delete :UISupportedDevices" "$TARGET_APP_PATH/Info.plist"

# 5. 给MachO文件上执行权限
# 拿到MachO文件的名称
APP_BINARY=`plutil -convert xml1 -o - $TARGET_APP_PATH/Info.plist|grep -A1 Exec|tail -n1|cut -f2 -d\>|cut -f1 -d\<`
#上可执行权限
chmod +x "$TARGET_APP_PATH/$APP_BINARY"



# 6. 重签名第三方 FrameWorks
TARGET_APP_FRAMEWORKS_PATH="$TARGET_APP_PATH/Frameworks"
if [ -d "$TARGET_APP_FRAMEWORKS_PATH" ];
then
for FRAMEWORK in "$TARGET_APP_FRAMEWORKS_PATH/"*
do
#签名 --force --sign 就是-fs
/usr/bin/codesign --force --sign "$EXPANDED_CODE_SIGN_IDENTITY" "$FRAMEWORK"
done
fi

#yololib修改MachO文件
#./yololib "$TARGET_APP_PATH/$APP_BINARY" "Frameworks/libHPDylibHook.dylib"
./yololib "$TARGET_APP_PATH/$APP_BINARY" "Frameworks/HPHook.framework/HPHook"
