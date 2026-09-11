安装与构建
==========

SDK 源码与二进制文件位于 `GJXS1980/cubebraid_sdk <https://github.com/GJXS1980/cubebraid_sdk>`__。推荐从仓库获取完整目录，不要只复制单个 DLL，因为 demo、头文件、导入库和运行时依赖需要配套使用。

前置条件
--------

当前仓库的构建说明以 Windows 为主：

* Visual Studio 2022，x64 工具链；
* CMake 3.5 或更高版本；
* C++14 编译器；
* Git；
* 运行 demo 时，``bin`` 目录必须能被系统 DLL 搜索路径找到。

SDK 目录
--------

从仓库根目录可以看到以下关键目录：

.. list-table::
   :header-rows: 1
   :widths: 22 48 30

   * - 路径
     - 用途
     - 备注
   * - ``include/``
     - C++ 头文件、Eigen 和 Protobuf 头文件
     - 编译时加入 include path。
   * - ``lib/``
     - Visual Studio 导入库
     - 包含 8 个 CubeBraid 模块的 ``.lib``。
   * - ``bin/``
     - Windows 动态库
     - PLC 模块还需要 ``snap7.dll``。
   * - ``src/``
     - C++ demo 源码
     - CMake 会为每个模块生成 demo。
   * - ``scripts/``
     - Python 封装、demo 和参数样例
     - Python 通过 ``ctypes`` 调用 DLL。
   * - ``doc/``
     - 已有 Markdown/PDF API 说明
     - AGV 和 JsonParameter API 文档。

获取代码
--------

在 PowerShell 或 Git Bash 中执行：

.. code-block:: console

   git clone https://github.com/GJXS1980/cubebraid_sdk.git
   cd cubebraid_sdk

如果已经下载仓库，也可以直接在 SDK 根目录执行后续命令。

生成 Visual Studio 工程
-----------------------

仓库根目录的 ``CMakeLists.txt`` 使用 C++14，并链接 ``lib`` 中的模块库：

.. code-block:: console

   mkdir build
   cd build
   cmake -G "Visual Studio 17 2022" -A x64 ..
   cmake --build . --config Release

构建目标包括：

* ``logger_demo``
* ``plc_sdk_demo``
* ``sensorsdk_demo``
* ``jsonsdk_demo``
* ``kawasaki_kinematics_sdk_demo``
* ``RobotSDK_demo``
* ``agv_sdk_demo``
* ``CameraSDK_demo``

可执行文件输出到 CMake 配置的 ``SDK_Demos`` 目录。由于这些 demo 中部分会连接真实设备或发送运动/PLC 信号，请不要在未检查 IP、端口和安全条件时直接运行。

运行时 DLL
----------

运行 demo 或 Python 脚本前，将 SDK 的 ``bin`` 目录加入当前终端的 ``PATH``，或者把所需 DLL 复制到可执行文件所在目录：

.. code-block:: powershell

   $sdkRoot = (Get-Location).Path
   $env:Path = "$sdkRoot\bin;$env:Path"

``PLC_SDK.dll`` 依赖 ``snap7.dll``；Python PLC 示例会先检查并加载这两个文件。若 DLL 位数、编译配置或依赖版本不一致，加载阶段可能直接失败。

Python 脚本
-----------

仓库内的 Python 示例位于 ``scripts`` 子目录。脚本没有统一的安装包入口，通常从脚本目录运行，并按实际位置调整 DLL 路径和数据文件路径。Python 封装主要使用 ``ctypes.CDLL`` 或 Windows 下的 ``ctypes.WinDLL``。

.. warning::

   仓库中的部分 Python 示例包含设备 IP、串口号和相对路径示例。部署前请替换为现场配置，不要把真实密码或密码哈希提交到公共仓库。

Linux 说明
----------

头文件为 Linux 保留了默认可见性宏，但当前 SDK 目录中可见的发行文件是 Windows ``.dll/.lib``。在 Linux 上使用时，需要从 SDK 发布方获得匹配的 ``.so``、依赖库和构建说明；不能直接用 Windows 导入库替代。
