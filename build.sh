#!/bin/sh

# 加载环境变量
source ~/.bash_profile

# 应用的名称，改为正确的应用名称
AppName=licensemanager

# 获取构建信息
BuildVersion=$(git describe --abbrev=0 --tags 2>/dev/null || echo "v1.1.0")
BuildTime=$(date +%FT%T%z)
CommitID=$(git rev-parse HEAD 2>/dev/null || echo "unknown")

# 检查Go环境
check_go_env() {
    if ! command -v go >/dev/null 2>&1; then
        echo "错误：未找到Go命令，请确保Go已正确安装并添加到PATH中"
        exit 1
    fi

    GO_VERSION=$(go version | awk '{print $3}')
    echo "使用Go版本: ${GO_VERSION}"
}

# 显示帮助信息
help() {
    echo "使用方法: $0 [选项]"
    echo "选项:"
    echo "  linux       为Linux构建 (amd64)"
    echo "  linux-arm64 为Linux构建 (aarch64/arm64)"
    echo "  windows     为Windows构建"
    echo "  mac         为MacOS构建 (arm64, 如M1/M2芯片)"
    echo "  macOld      为MacOS构建 (amd64, 如Intel芯片)"
    echo "  clean       清理构建文件"
    echo "  help        显示帮助信息"
}


# Linux (amd64) 构建
linux() {
    echo "开始为 Linux (amd64) 构建..."
    check_go_env
    
    echo "编译应用..."
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $AppName -a -ldflags "-w -s -X main.BuildVersion=${BuildVersion} -X main.CommitID=${CommitID} -X main.BuildTime=${BuildTime}" ./cmd/licensemanager
    
    if [ $? -ne 0 ]; then
        echo "错误：构建失败"
        exit 1
    fi
    
    echo "✓ 构建完成: Linux (amd64)"
}

# Linux (arm64) 构建
linux_arm64() {
    echo "开始为 Linux (arm64) 构建..."
    check_go_env
    
    echo "编译应用..."
    CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o $AppName -a -ldflags "-w -s -X main.BuildVersion=${BuildVersion} -X main.CommitID=${CommitID} -X main.BuildTime=${BuildTime}" ./cmd/licensemanager
    
    if [ $? -ne 0 ]; then
        echo "错误：构建失败"
        exit 1
    fi
    
    echo "✓ 构建完成: Linux (arm64)"
}
# Windows 构建
windows() {
    echo "开始为 Windows 构建..."
    check_go_env
    
    echo "编译应用..."
    CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o $AppName.exe -ldflags "-w -s -X main.BuildVersion=${BuildVersion} -X main.CommitID=${CommitID} -X main.BuildTime=${BuildTime}" ./cmd/licensemanager
    
    if [ $? -ne 0 ]; then
        echo "错误：构建失败"
        exit 1
    fi
    
    echo "✓ 构建完成: Windows"
}
# MacOS (arm64) 构建
mac() {
    echo "开始为 MacOS (arm64) 构建..."
    check_go_env
    
    echo "编译应用..."
    GOOS=darwin GOARCH=arm64 go build -o $AppName -ldflags "-w -s -X main.BuildVersion=${BuildVersion} -X main.CommitID=${CommitID} -X main.BuildTime=${BuildTime}" ./cmd/licensemanager
    
    if [ $? -ne 0 ]; then
        echo "错误：构建失败"
        exit 1
    fi
    
    echo "✓ 构建完成: MacOS (arm64)"
}

# MacOS (amd64/Intel) 构建
macOld() {
    echo "开始为 MacOS (amd64/Intel) 构建..."
    check_go_env
    
    echo "编译应用..."
    GOOS=darwin GOARCH=amd64 go build -o $AppName -ldflags "-w -s -X main.BuildVersion=${BuildVersion} -X main.CommitID=${CommitID} -X main.BuildTime=${BuildTime}" ./cmd/licensemanager
    
    if [ $? -ne 0 ]; then
        echo "错误：构建失败"
        exit 1
    fi
    
    echo "✓ 构建完成: MacOS (amd64/Intel)"
}



# 清理构建文件
clean() {
    echo "清理构建文件..."
    rm -f $AppName
    rm -f $AppName.exe
    echo "✓ 清理完成"
}

# 显示构建信息
show_build_info() {
    echo ""
    echo "构建信息:"
    echo "- 应用名称: $AppName"
    echo "- 版本: $BuildVersion"
    echo "- 构建时间: $BuildTime"
    echo "- 提交ID: $CommitID"
    echo ""
}

# 主控制逻辑
echo "LicenseManager 构建工具"
show_build_info

case "$1" in
    "linux")
        linux
        ;;
    "linux-arm64")
        linux_arm64
        ;;
    "windows")
        windows
        ;;
    "macOld")
        macOld
        ;;
    "mac")
        mac
        ;;
    "clean")
        clean
        ;;
    "help")
        help
        ;;
    *)
        help
        ;;
esac

echo "完成"