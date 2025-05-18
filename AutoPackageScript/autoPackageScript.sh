#!/bin/sh

#  autoPackageScript.sh
#  LSBuyer
#
#  Created by 刘光强 on 2017/6/3.
#  Copyright © 2017年 Facebook. All rights reserved.

envionmentVariables() {

    # ==================== 工程配置环境变量 ==================== #

    echo "\033[37;45m*************************  step1:初始化环境变量 🚀 🚀 🚀  *************************  \033[0m"

    sleep 0.5
    # 计时
    SECONDS=0
    # 工作空间 (例:若是用Cocopods管理的.xcworkspace项目,赋值true;用Xcode默认创建的.xcodeproj,赋值false)
    is_workspace="false"
    # 指定要打包编译的方式 : Release or Debug (默认是Release)
    build_configuration="Release"
    # fir账户的token, 这个token换成自己fir账号生成的token即可
    firim_token="_octo=GH1.1.2097120439.1747562019; cpu_bucket=lg; preferred_color_mode=light; tz=Asia%2FShanghai; _device_id=1cfed49f92f09acd8111fb6e23cb4354; saved_user_sessions=86941520%3AqBb38xA2bxQ9rSqV9RkLc45UeNbCnvoK5eageiGRLPfd41Bm; user_session=qBb38xA2bxQ9rSqV9RkLc45UeNbCnvoK5eageiGRLPfd41Bm; __Host-user_session_same_site=qBb38xA2bxQ9rSqV9RkLc45UeNbCnvoK5eageiGRLPfd41Bm; tz=Asia%2FShanghai; color_mode=%7B%22color_mode%22%3A%22auto%22%2C%22light_theme%22%3A%7B%22name%22%3A%22light%22%2C%22color_mode%22%3A%22light%22%7D%2C%22dark_theme%22%3A%7B%22name%22%3A%22dark%22%2C%22color_mode%22%3A%22dark%22%7D%7D; logged_in=yes; dotcom_user=taojinliang123; _gh_sess=DJyTlNVmRiUowFtpFLm9nBzuD1DB7QhR7xmjTdyjBVKlIS33De5Y2OwNpuWWpP7wpbWsI4L5%2FRlMCjJ3YwkC%2Fv5f%2Bs%2FeCB1c3sh9wKsxHjBhxsiErO%2Bkz0oEKiMUVFGhHEilbJUqU0JnFWWxFYY2VZPRx0kArg%2BmBC2P4i0gwPQRocv0jkmXIgu2heHc%2Fm6XI1P4PTEHie%2FJpPZ2z1TA8VWGDwV3J7awLOd8Ob9XYwI3OJ3nLKRI%2FNBqLh0feqLZs8TplvTyZGVmNscrop%2BvRfPyJsa3DjclF9l8Q8Q4moVUQfMnAlL4I6kFgJdT14cXMIO9szOl5DH5Y%2BRMoLoVKce0E1iWCAV7pPZBTXSTO2cg%2B6urfJjFC4vx6RbO4TTZ6vwBaW7IohbmTRlOuWiWx8vpicQGZI9Yef86fLa3Ez%2BPqIzr--ok9PO605ZrS70zhU--M%2F2LQeOKZO1FnJemzmBwpg%3D%3D"

    # 打包脚本文件夹路径
    script_path=$(pwd)
    # 指定项目的scheme名称（默认为one，需要再次赋值）
    scheme_name="one"
    # 工程中Target对应的配置plist文件名称, Xcode默认的配置文件为info.plist (需要再次赋值)
    info_plist_name="info"
    # 导出ipa所需要的对应的plist文件路径 (默认为EnterpriseExportOptionsPlist.plist)
    ExportOptionsPlistPath="$script_path/EnterpriseExportOptionsPlist.plist"

    # 返回上上级目录,进入项目工程根目录
    cd ..
    cd ..
    # 工程根目录
    project_dir=$(https://github.com/taojinliang123/lx-music-mobile)
    # 获取工程名称（LSBuyer）
    project_name=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`

    # Dev,Pre,Pro三种环境
    echo "\033[31;1m请选择打包类型(输入序号,按回车即可) \033[0m"
    echo "\033[31;1m1. 测试       \033[0m"
    echo "\033[31;1m2. 预发    \033[0m"
    echo "\033[31;1m3. 生产  \033[0m"

    # 捕获用户键盘输入
    read packageType
    sleep 0.5
    method="$packageType"

    # 判断用户是否有输入
    if [ -n "$method" ] ; then
        if [ "$method" = "1" ] ; then
            ExportOptionsPlistPath="$script_path/EnterpriseExportOptionsPlist.plist"
            # 根据用户选择的打包类型来设置对应的scheme和plist文件
            scheme_name="one"
            info_plist_name="info"
        elif [ "$method" = "2" ] ; then
            ExportOptionsPlistPath="$script_path/EnterpriseExportOptionsPlist.plist"
            scheme_name="LSBuyerPre"
            info_plist_name="LSBuyerPre"
        elif [ "$method" = "3" ] ; then
            ExportOptionsPlistPath="$script_path/AppStoreExportOptionsPlist.plist"
            scheme_name="LSBuyer"
            info_plist_name="Info"
        else
            echo "\033[37;45m*************************  你是不是瞎，是不是瞎  😢 😢 😢  *************************  \033[0m"
            exit 1
        fi
    fi

    # 获取对应的plist文件
    info_plist_path="$project_dir/$project_name/$info_plist_name.plist"

    # 对应plist中的Bundle versions string, short
    bundle_short_version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$info_plist_path"`
    # 对应plist中的Bundle version
    bundle_version=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$info_plist_path"`

    # 指定输出ipa文件夹路径 (需要再次赋值)
    export_path=~/Desktop/$scheme_name-IPA
    # 指定输出xcarchive路径
    export_archive_path="$export_path/$scheme_name.xcarchive"
    # 删除旧.xcarchive文件
    rm -rf "$export_archive_path"

    # 指定输出ipa路径
    export_ipa_path="$export_path"
    # 指定输出ipa名称 : scheme_name + bundle_short_version (需要重新赋值)
    ipa_name="$scheme_name-v$bundle_short_version"

}

Xcodebuild() {

    echo "\033[37;45m*************************  step2:开始构建项目 🚀 🚀 🚀  *************************  \033[0m"
    sleep 1
    if [ -d "$export_path" ]; then
        echo $export_path
    else
        mkdir $export_path
    fi

    # 判断编译的项目类型是workspace还是project
    if $is_workspace ; then
        # 编译前做clear操作
        xcodebuild clean -workspace ${project_name}.xcworkspace \
        -scheme ${scheme_name} \
        -configuration ${build_configuration}
        # archive操作
        xcodebuild archive -workspace ${project_name}.xcworkspace \
        -scheme ${scheme_name} \
        -configuration ${build_configuration} \
        -archivePath ${export_archive_path}
    else
        xcodebuild clean -project ${project_name}.xcodeproj \
        -scheme ${scheme_name} \
        -configuration ${build_configuration}

        xcodebuild archive -project ${project_name}.xcodeproj \
        -scheme ${scheme_name} \
        -configuration ${build_configuration} \
        -archivePath ${export_archive_path}
    fi

    #  检查是否构建成功
    #  xcarchive 是一个文件夹不是一个文件所以使用 -d 判断
    if [ -d "$export_archive_path" ] ; then
        echo "\033[37;45m项目构建成功 🚀 🚀 🚀  \033[0m"
    else
        echo "\033[37;45m项目构建失败 😢 😢 😢  \033[0m"
        exit 1
    fi

}

ExportArchive() {
    echo "\033[37;43m*************************  step3:开始导出ipa文件 🚀 🚀 🚀  *************************  \033[0m"
    sleep 0.5
    # 导出ipa
    xcodebuild  -exportArchive \
    -archivePath ${export_archive_path} \
    -exportPath ${export_ipa_path} \
    -exportOptionsPlist ${ExportOptionsPlistPath}

    # 修改ipa文件名称
    mv $export_ipa_path/$scheme_name.ipa $export_ipa_path/$ipa_name.ipa
    # 检查文件是否存在
    if [ -f "$export_ipa_path/$ipa_name.ipa" ] ; then
        echo "\033[37;45m导出 ${ipa_name}.ipa 包成功 🎉  🎉  🎉   \033[0m"
    else
        echo "\033[37;45m导出 ${ipa_name}.ipa 包失败 😢 😢 😢     \033[0m"
        exit 1
    fi
    # 输出打包总用时
    echo "\033[37;46m总用时: ${SECONDS}s \033[0m"
    open $export_path

}

previewIPAInfo() {
    echo "\033[37;43m*************************  step4:预览IPA信息 💩 💩 💩  *************************  \033[0m"
    fir info $export_ipa_path/$ipa_name.ipa

}

publishIPAToFir() {
    echo "\033[37;43m*************************  step5:上传中 🚀 🚀 🚀  *************************  \033[0m"
    echo "\033[37;43m*************************  step4:预览用户登录信息 💩 💩 💩  *************************  \033[0m"
    fir login "$firim_token"
    fir publish $export_ipa_path/$ipa_name.ipa -Q
    echo "\033[37;43m*************************  step6:上传完成 🚀 🚀 🚀  *************************  \033[0m"
    # 输出总用时
    echo "\033[37;46m总用时: ${SECONDS}s 👄 👄 👄 \033[0m"
    open $export_path

}

envionmentVariables
Xcodebuild
ExportArchive
previewIPAInfo
publishIPAToFir
