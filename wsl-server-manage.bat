@echo off

setlocal EnableDelayedExpansion & cd /d "%~dp0"

SET WSL_TITLE=WSL子系统服务器管理 v1.4
SET WSL_SYSTEM= Ubuntu-20.04

SET PORT_LIST=20,21,22,80,888,8888,8324


TITLE %WSL_TITLE%

:: 以管理员身份运行
>NUL 2>&1 REG.exe query "HKU\S-1-5-19" || (
    ECHO SET UAC = CreateObject^("Shell.Application"^) > "%TEMP%\Getadmin.vbs"
    ECHO UAC.ShellExecute "%~f0", "%1", "", "runas", 1 >> "%TEMP%\Getadmin.vbs"
    "%TEMP%\Getadmin.vbs"
    DEL /f /q "%TEMP%\Getadmin.vbs" 2>NUL
    Exit /b
)

echo.
echo  %WSL_TITLE%
echo.
echo  新版本网址 https://gitee.com/hhun/wsl-server-manage
echo  请注意你的杀毒软件提示，一定要允许。
echo ―――――――――――――――
for /f "tokens=4" %%i in ('route print^|findstr 0.0.0.0.*0.0.0.0') do (
	set internal_ip=%%i
)
echo  本机内网IP地址 %internal_ip%

for /f "tokens=1" %%i in ('arp -a^|findstr "172.*动态"') do (
	set wsl_ip=%%i
)
echo  WSL 内网IP地址 %wsl_ip%

echo ――――― 操作选项 ―――――
echo  [1]服务器状态         [2]启动服务器         [3]停止服务器
echo  [4]重启服务器         [5]重载服务器
echo.
echo  [6]启动子系统         [7]关闭子系统         [8]查看子系统发行版本
echo.
echo  [9]查看WSL端口映射    [10]添加WSL端口映射   [11]清空WSL端口映射
echo.
echo  [0]退出
echo ――――― 操作选项 ―――――
echo.

:first
set /p v=请输入数字，并按回车：
if /i "%v%" == "" goto first
if /i "%v%" == "1" goto do_status
if /i "%v%" == "2" goto do_start
if /i "%v%" == "3" goto do_stop
if /i "%v%" == "4" goto do_restart
if /i "%v%" == "5" goto do_reload

if /i "%v%" == "6" goto do_start_wsl
if /i "%v%" == "7" goto do_shutdown_wsl
if /i "%v%" == "8" goto show_version

if /i "%v%" == "9" goto do_show_wsl_mapping
if /i "%v%" == "10" goto do_add_wsl_mapping
if /i "%v%" == "11" goto do_del_wsl_mapping
if /i "%v%" == "0" goto exit

:do_status
@echo  #################### 服务器状态 Start ####################
cmd /c "wsl -u root -d %WSL_SYSTEM% /etc/init.wsl status"
cmd /c "wsl -u root -d %WSL_SYSTEM% service bt default"
@echo  #################### 服务器状态  End  ####################
@echo.
goto first

:do_start
@echo  #################### 启动服务器 Start ####################
cmd /c "wsl -u root -d %WSL_SYSTEM% /etc/init.wsl start"
cmd /c "wsl -u root -d %WSL_SYSTEM% service bt default"
@echo  #################### 启动服务器  End  ####################
@echo.
goto first

:do_stop
@echo  #################### 停止服务器 Start ####################
cmd /c "wsl -u root -d %WSL_SYSTEM% /etc/init.wsl stop"
@echo.
@echo  #################### 停止服务器  End  ####################
@echo.
goto first

:do_restart
@echo  #################### 重启服务器 Start ####################
cmd /c "wsl -u root -d %WSL_SYSTEM% /etc/init.wsl restart"
cmd /c "wsl -u root -d %WSL_SYSTEM% service bt default"
@echo  #################### 重启服务器  End  ####################
@echo.
goto first

@echo  #################### 重载服务器 Start ####################
cmd /c "wsl -u root -d %WSL_SYSTEM% /etc/init.wsl reload"
cmd /c "wsl -u root -d %WSL_SYSTEM% service bt default"
@echo  #################### 重载服务器  End  ####################
@echo.
goto first

:show_version
@echo  #################### 查看版本 Start ####################
cmd /c "wsl -l -v"
@echo  #################### 查看版本  End  ####################
@echo.
goto first

:do_start_wsl
@echo  #################### 启动子系统 Start ####################
cmd /c "wsl -u root -d %WSL_SYSTEM% cd /root"
@echo  #################### 启动子系统  End  ####################
@echo.
goto first

:do_shutdown_wsl
@echo  #################### 关闭子系统 Start ####################
cmd /c "wsl --shutdown"
@echo  #################### 关闭子系统  End  ####################
@echo.
goto first

:do_show_wsl_mapping
@echo  #################### 查看WSL端口映射 Start ####################
@echo.
for /f "tokens=1" %%i in ('arp -a^|findstr "172.*动态"') do (
	set wsl_ip=%%i
)
echo  WSL 内网IP地址 %wsl_ip%
cmd /c "netsh interface portproxy show all"
@echo  #################### 查看WSL端口映射  End  ####################
@echo.
goto first

:do_add_wsl_mapping
@echo  #################### 添加WSL端口映射 Start ####################
for /f "tokens=1" %%i in ('arp -a^|findstr "172.*动态"') do (
	set wsl_ip=%%i
)
for %%i in (%PORT_LIST%) do (
	cmd /c "echo netsh interface portproxy add v4tov4 listenport=%%i listenaddress=* connectport=%%i connectaddress=%wsl_ip%"
	cmd /c "netsh interface portproxy add v4tov4 listenport=%%i listenaddress=* connectport=%%i connectaddress=%wsl_ip%"
)
@echo  #################### 添加WSL端口映射  End  ####################
@echo.
goto first

:do_del_wsl_mapping
@echo  #################### 清空WSL端口映射 Start ####################
cmd /c "netsh interface portproxy reset"
@echo  #################### 清空WSL端口映射  End  ####################
@echo.
goto first


:exit
echo 退出
exit