

DEPENDS_PACKAGES="
	PACKAGE_luci
	PACKAGE_luci-base
	LUCI_LANG_zh_Hans
	PACKAGE_luci-compat
	PACKAGE_wget-ssl
	PACKAGE_curl
	PACKAGE_openssl-util
	PACKAGE_luci-app-zerotier
	PACKAGE_iptables-nft 
	PACKAGE_tc-tiny
	PACKAGE_iptables-mod-iprange
	PACKAGE_tc-mod-iptables
	PACKAGE_kmod-sched-core
	PACKAGE_iptables-zz-legacy
	PACKAGE_fros
	PACKAGE_fros_files
	PACKAGE_luci-app-fros 
"
init_depend_package_config()
{
	sed -i "/CONFIG_PACKAGE_firewall4/d" .config
        echo 'CONFIG_PACKAGE_firewall4=n' >>.config
	for package in $DEPENDS_PACKAGES;do
		echo "add depend package CONFIG_PACKAGE_$package"
		sed -i "/CONFIG_$package/d" .config
		echo "CONFIG_$package=y" >>.config
	done
	make defconfig
}
build_product()
{
    local p=$1
	local core=$2
    	test -z $p && return 1
	if [ ! -e  product/$p ];then
		echo "##error, product $p not exist"
		echo "-----product list-------"
		ls product |grep $p
		return
	fi
	rlog "begin build product $p"
	rm tmp -fr
	cp product/$p/product_config .config
	init_depend_package_config
	make target/linux/clean
	make product=$p  -j$core V=s
	if [ $? -ne 0 ];then
		rlog "build product $p failed, try agin"
		make 
		if [ $? -ne 0 ];then
			rlog "build product $p failed."
			exit
		fi
	fi
	rlog "build product $p ok"
	if [ ! -e "release" ];then
		mkdir release
	fi
    find bin/ -name "*sysup*" |xargs -i cp  {} ./release
    find bin/ -name "*tar.gz*" |xargs -i cp  {} ./release
    find bin/ -name "*img.gz*" |xargs -i cp  {} ./release
    find bin/ -name "*vmdk*" |xargs -i cp  {} ./release
    find bin/ -name "*trx*" |xargs -i cp  {} ./release
    find bin/ -name "*factory*" |xargs -i cp  {} ./release
    find bin/ -name "*kernel*" |xargs -i cp  {} ./release
    find bin/ -name "*rootfs*" |xargs -i cp  {} ./release
    rm ./release/*.ipk
}

core=1
arch=""
rlog(){
    date_str=`date`
    echo "$date_str  $1" >>./build.log
}


build_single_product()
{
	product=$1
	core=$2
	test -z $product && return
	if [ x"" == x"$core" ];then
		core=1
	fi
	echo "build single product $product, core=$core"
	build_product $product $core
}


build_list_product()
{
	rlog "build list product"
	for product in $*;do
		rlog "product = $product"
		build_product $product 2
	done
	rlog "build list product done"
}
usage(){
	echo "usage:"
	echo "  -p build product(eg:x86_64,redmi_ac2100,etc)"
	echo "  -i init fros default config"
	echo "  -l product1 product2(eg:x86_64,redmi_ac2100)"
}

case "$1" in
	-p) 
	build_single_product $2 $3;;
	-l)
		shift
		build_list_product $*;;
	-i)
		init_depend_package_config;;
	--help) usage;;
	*)
	usage;;
esac

