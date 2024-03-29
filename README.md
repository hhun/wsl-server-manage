# WSL子系统服务器管理

这个程序是为了方便在Windows系统里面方便管理WSL子系统Linux服务器。

## 功能列表

- 服务器
  - [1] 服务器状态
  - [2] 启动服务器
  - [3] 停止服务器
  - [4] 重启服务器
  - [5] 重载服务器
- 子系统
  - [6] 启动子系统
  - [7] 关闭子系统
  - [8] 查看子系统发行版本
- 端口映射
  - [9] 查看WSL端口映射
  - [10] 添加WSL端口映射
  - [11] 清空WSL端口映射

> 括号里面的数字的操作指令。

# 操作界面

![操作界面](https://files.catbox.moe/j4m56z.png)

# 使用说明

1. 将 `/etc/init.wsl` 文件复制到Linux系统里面。
2. 在Windows系统里面双击打开 `wsl-server-manage.bat` 即可。

## 子系统发行版本

若您使用的子系统发行版本不是`Ubuntu-20.04`，需要将`wsl-server-manage.bat`文件里面的`Ubuntu-20.04`改成您正在使用的子系统发行版本。

例如：将 `SET WSL_SYSTEM= Ubuntu-20.04` 改成 `SET WSL_SYSTEM= Debian`