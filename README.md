## FROS简介  
FROS是一款基于OpenWrt开发的企业级路由器系统  

## 如何编译  
### 1.系统安装    
安装好Linux系统，推荐用ubuntu18之后的版本 
### 2. 依赖包安装  
```
sudo apt update -y   
sudo apt install -y cmake curl wget vim git antlr3 asciidoc autoconf automake autopoint binutils bison  \
build-essential bzip2 ccache  cpio  device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib \
 gperf haveged help2man intltool libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev \
libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz \
mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python2.7 python3 python3-pyelftools \
libpython3-dev qemu-utils rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip \
xmlto xxd zlib1g-dev ack 
```
### 3. 下载源码  
```
git clone https://github.com/openfros/fros.git
```
### 4. 更新feeds  
```
cd fros    
./scripts/feeds update -a 
./scripts/feeds install -a    
```
### 5. 选择编译产品并初始化默认配置  
product目录包含了几款常用的fros产品，里面有一些产品相关配置，比如x86_64、redmi_ac2100等，可以通过build.sh脚本一键编译  
如编译x86_64固件可以执行以下命令:    
```
./build.sh -l x86_64  
```
该命令会将product/x86_64目录中的默认配置拷贝到.config并增加fros相关依赖配置，最后通过make命令编译生成固件  
当然你也可以手动通过make menuconfig选择产品和配置，然后增加fros依赖配置后进行编译  
步骤如下：
```
make menuconfig (选择产品和其他package)  
./build.sh -i  (增加fros依赖package)  
make V=s （开始编译）  
```

## 支持的架构（持续更新中）
- x86_64
- ramips_7621(红米AC2100、小米R3G、K2P、newifi3、极路由4等)
- rockchip_armv7(r2s、r4s等)
- ipq807x_generic(小米ax3600等)

其他芯片架构的产品暂不支持自编译，后续会加入支持  

## 说明  
openwrt源码来自官方23.05版本，官方源码支持的产品相对于国内的分支会有一定的延时，只有合入了openwrt官方的产品才支持，如果没有你的产品，可以先直接使用fros发布的固件。  





