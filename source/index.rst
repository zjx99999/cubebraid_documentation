CubeBraid 装卸柜机器人技术文档
==============================

CubeBraid SDK 面向集装箱装卸柜机器人系统，提供 AGV、工业相机、机器人、PLC、倾角仪、运动学、参数管理和日志等基础能力。本网站采用 ROS 2 Documentation 使用的 Sphinx + Read the Docs 模板，内容以 CubeBraid SDK 的公开头文件、示例程序和脚本，以及《CubeBraid SDK 技术文档》中的系统设计说明为准。

文档结构
--------

* **系统架构与产品能力**：从整体分层、模块职责和接口边界了解 CubeBraid SDK。
* **快速入门**：完成 SDK 获取、Windows 构建、运行时依赖配置和第一个程序。
* **SDK 参考**：按 AGV、相机、机器人、PLC、倾角仪、运动学、参数和日志模块查阅接口。
* **集成与部署**：了解典型装卸柜流程、配置文件、Python ``ctypes`` 对接和运行时发布要求。
* **安全、版本与支持**：在真实设备联调前阅读安全须知，并记录 SDK 版本和现场依赖。

.. toctree::
   :titlesonly:
   :maxdepth: 2
   :hidden:

   About-CubeBraid
   Get-Started
   SDK-Architecture
   Submodules
   API-Reference
   Guides/Container-Workflow
   Guides/Configuration
   Guides/Safety
   Guides/Deployment
   Developer-Tools
   Releases
   Contact

快速开始
--------

如果您第一次使用 CubeBraid SDK，建议按以下顺序阅读：

* :doc:`产品与能力 <About-CubeBraid>`：了解 SDK 在装卸柜机器人中的职责边界。
* :doc:`安装与构建 <Get-Started/Installation>`：从 GitHub 获取 SDK，并使用 CMake 生成 demo。
* :doc:`第一个程序 <Get-Started/Quickstart>`：先从不连接硬件的参数读取和算法调用开始。
* :doc:`装卸柜业务流程 <Guides/Container-Workflow>`：了解视觉、AGV、机器人和 PLC 如何协同。
* :doc:`模块总览 <Submodules>`：根据设备或功能进入对应的 API 参考。

核心模块
--------

* **AGV_SDK**：AGV 网络连接、登录、自动/手动运动和位姿读取。
* **CameraSDK**：集装箱基准点、最后一面侧吸基准点和航向角偏差计算。
* **RobotSDK**：机械臂连接、笛卡尔/关节运动和顶吸、侧吸目标位姿补偿。
* **PLC_SDK**：PLC DB 块读写、吸盘/底托信号、装柜状态和取料参数同步。
* **SensorSDK**：DXL360 倾角仪串口采集、自动重连和角度归零。
* **JsonSDK**：读取手眼标定、SKU、机器人位姿、垛型及续码配置。
* **KawasakiSDK**：川崎 RS080N 运动学正解、逆解和奇异点规避。
* **LoggerSDK**：线程安全日志、格式化输出和紧急停止记录。

接口形态
--------

SDK 同时提供原生 C++ 接口和部分 C ABI 接口。C ABI 适合 Python ``ctypes``、C# 或其他 FFI 封装；使用时必须保证调用方的结构体布局、参数类型、单位和 DLL 位数与头文件一致。

.. important::

   任何会调用 ``connect``、``control``、``goForward``、``goBack`` 或 PLC 输出信号的示例，都可能驱动真实设备。首次运行前请阅读 :doc:`安全须知 <Guides/Safety>`，并在断开执行机构或仿真环境中完成验证。

版本说明
--------

当前页面对应 CubeBraid SDK 仓库中的接口快照。若头文件、动态库和本文档版本不一致，请优先以随 SDK 发布的 ``include`` 目录头文件为准，并记录 SDK commit 或发布版本。

* `CubeBraid 官方网站 <https://www.cubebraid.com/>`__
* `CubeBraid SDK GitHub 仓库 <https://github.com/GJXS1980/cubebraid_sdk>`__
