KERNEL_DIR=$PWD
ANYKERNEL_DIR=../AnyKernel2
DTBTOOL=$KERNEL_DIR/dtbTool
DATE=$(date +"%d%m%Y")
KERNEL_NAME="IceColdKernel"
DEVICE="-kenzo-"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE".zip

if [ -f "$FINAL_ZIP" ]; then
   rm -f $FINAL_ZIP
fi

export ARCH=arm64
export KBUILD_BUILD_USER="Stark"
export KBUILD_BUILD_HOST="StarkBoX"
export CROSS_COMPILE="$HOME/toolchain/linaro-6.4/bin/aarch64-linux-gnu-"
export LD_LIBRARY_PATH="$HOME/toolchain/linaro-6.4/lib/"

make mrproper > /dev/null 2>&1
make lineageos_kenzo_defconfig > /dev/null 2>&1
make -j$(($(nproc --all) * 2))

$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
mv $KERNEL_DIR/arch/arm64/boot/dt.img $ANYKERNEL_DIR/dtb
cp $KERNEL_DIR/arch/arm64/boot/Image.gz $ANYKERNEL_DIR/zImage
git clean -fdx > /dev/null 2>&1

cd $ANYKERNEL_DIR
zip -r9 $FINAL_ZIP * -x README.md $FINAL_ZIP > /dev/null 2>&1
mv $FINAL_ZIP $KERNEL_DIR && cd $KERNEL_DIR
