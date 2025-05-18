#!/bin/sh

#  autoPackage.sh
#  CRM
#
#  Created by 刘光强 on 2017/6/19.
#  Copyright © 2017年 Facebook. All rights reserved.

#  ******************** 安卓一键式打包并上传到fir生成二维码并直接扫描安装 ********************

# 预先定义对应的环境变量
envionmentVariables(){

# 打包时间初始值
SECONDS=0
# 当前的路径
pwd
#安卓项目工程路径
android_project_path=$(https://github.com/taojinliang123/lx-music-mobile)
# 安卓apk目录路径
apk_dir_path="$android_project_path/app/build/outputs/apk"
# apk 路径
apk_path="$apk_dir_path/app-dev-release.apk"
# fir账户的token,这个token换成自己fir账号生成的token即可
firim_token="_octo=GH1.1.2097120439.1747562019; cpu_bucket=lg; preferred_color_mode=light; tz=Asia%2FShanghai; _device_id=1cfed49f92f09acd8111fb6e23cb4354; saved_user_sessions=86941520%3AqBb38xA2bxQ9rSqV9RkLc45UeNbCnvoK5eageiGRLPfd41Bm; user_session=qBb38xA2bxQ9rSqV9RkLc45UeNbCnvoK5eageiGRLPfd41Bm; __Host-user_session_same_site=qBb38xA2bxQ9rSqV9RkLc45UeNbCnvoK5eageiGRLPfd41Bm; tz=Asia%2FShanghai; color_mode=%7B%22color_mode%22%3A%22auto%22%2C%22light_theme%22%3A%7B%22name%22%3A%22light%22%2C%22color_mode%22%3A%22light%22%7D%2C%22dark_theme%22%3A%7B%22name%22%3A%22dark%22%2C%22color_mode%22%3A%22dark%22%7D%7D; logged_in=yes; dotcom_user=taojinliang123; _gh_sess=DJyTlNVmRiUowFtpFLm9nBzuD1DB7QhR7xmjTdyjBVKlIS33De5Y2OwNpuWWpP7wpbWsI4L5%2FRlMCjJ3YwkC%2Fv5f%2Bs%2FeCB1c3sh9wKsxHjBhxsiErO%2Bkz0oEKiMUVFGhHEilbJUqU0JnFWWxFYY2VZPRx0kArg%2BmBC2P4i0gwPQRocv0jkmXIgu2heHc%2Fm6XI1P4PTEHie%2FJpPZ2z1TA8VWGDwV3J7awLOd8Ob9XYwI3OJ3nLKRI%2FNBqLh0feqLZs8TplvTyZGVmNscrop%2BvRfPyJsa3DjclF9l8Q8Q4moVUQfMnAlL4I6kFgJdT14cXMIO9szOl5DH5Y%2BRMoLoVKce0E1iWCAV7pPZBTXSTO2cg%2B6urfJjFC4vx6RbO4TTZ6vwBaW7IohbmTRlOuWiWx8vpicQGZI9Yef86fLa3Ez%2BPqIzr--ok9PO605ZrS70zhU--M%2F2LQeOKZO1FnJemzmBwpg%3D%3D"
}

apkBuild(){

# 删除老的apk
rm -rf $apk_path
cd "$android_project_path"
echo "\033[37;45m打包开始！！！ 🎉  🎉  🎉   \033[0m"
sleep 1
# 执行安卓打包脚本
./gradlew assembleRelease
# 检查apk文件（app-LSW-release.apk）是否存在
if [ -f "$apk_path" ]; then
echo "$apk_path"
echo "\033[37;45m打包成功 🎉  🎉  🎉   \033[0m"
sleep 1
else
echo "\033[37;45m没有找到对应的apk文件 😢 😢 😢   \033[0m"
exit 1
fi
}

# 预览apk信息
previewIPAInfo(){
echo "\033[37;43m*************************  step4:预览apk信息 💩 💩 💩  *************************  \033[0m"
fir info $apk_path
sleep 1
}

# 将apk目录下的app-LSW-release.apk 上传到fir
publishIPAToFir(){

echo "\033[37;43m*************************  step5:上传中 🚀 🚀 🚀  *************************  \033[0m"
echo "\033[37;43m*************************  step4:预览用户登录信息 💩 💩 💩  *************************  \033[0m"
fir login "$firim_token"
fir publish $apk_path -Q
echo "\033[37;43m*************************  step6:上传完成 🚀 🚀 🚀  *************************  \033[0m"
# 输出总用时
echo "\033[37;46m总用时: ${SECONDS}s 👄 👄 👄 \033[0m"
open $apk_dir_path
}

envionmentVariables
apkBuild
previewIPAInfo
publishIPAToFir
