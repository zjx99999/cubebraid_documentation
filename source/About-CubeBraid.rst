产品与能力
==========

.. _AboutCubeBraid:

CubeBraid SDK 是装卸柜机器人控制软件的基础组件集合。它不负责替代机器人控制器、PLC 程序或相机厂商 SDK，而是把装卸柜任务中常用的连接、数据、坐标和控制能力封装成可复用的 C++/C 接口。

系统组成
--------

一个典型的装卸柜系统由以下设备和软件层组成：

* **AGV**：负责机器人在集装箱外部或内部的导航位置，以及自动/手动移动。
* **3D 相机**：采集箱体或集装箱结构信息，计算基准点和航向角偏差。
* **六轴机器人**：执行取料、放料和姿态控制；RobotSDK 同时提供抓取目标补偿算法。
* **PLC 与执行机构**：管理吸盘、底托、摆台、液压杆和状态握手信号。
* **倾角仪**：采集 X/Y 方向倾角，为斜面补偿和异常判断提供输入。
* **参数文件**：保存手眼标定、SKU、机器人位姿、垛型和续码状态。

CubeBraid SDK 的模块关系可概括为：

``JsonSDK`` 读取配置，``CameraSDK`` 计算视觉基准点，``SensorSDK`` 提供倾角，``RobotSDK`` 生成机器人目标位姿，``PLC_SDK`` 负责控制信号与状态同步，``AGV_SDK`` 负责移动，``LoggerSDK`` 记录全过程。

适用任务
--------

SDK 当前头文件和 demo 覆盖以下任务：

* 集装箱内传统基准点计算；
* 最后一面侧吸基准点计算；
* 根据加强筋法向计算 AGV 航向角偏差；
* 顶吸、顶吸特殊码法和侧吸目标点补偿；
* 按面、层、箱数和垛型参数同步装柜进度；
* 机械臂笛卡尔位姿、关节角和 J4 角度查询；
* 川崎 RS080N 的正运动学、逆运动学和轨迹奇异点处理。

单位约定
--------

不同模块沿用其公开头文件中的单位，不能把所有坐标直接当成同一单位：

.. list-table::
   :header-rows: 1
   :widths: 25 25 50

   * - 数据
     - 默认单位
     - 说明
   * - RobotSDK ``Pose``
     - mm / deg
     - ``x/y/z`` 为毫米，``rx/ry/rz`` 为度。
   * - RobotSDK ``Joint``
     - deg
     - 六个关节角均为度。
   * - RobotSDK ``centroid``
     - m
     - 抓取补偿接口的基准点示例使用米；算法返回目标位置为 mm。
   * - ``BoxDimension`` / ``SkuData``
     - mm、kg
     - 箱体长宽高为毫米，重量为千克。
   * - CameraSDK ``CalibrationPose``
     - m + quaternion
     - 平移为米，姿态为 ``qw/qx/qy/qz``。
   * - AGV 手动速度
     - mm/s、0.001 rad/s
     - ``vx/vy`` 为线速度，``w`` 按头文件约定传递。
   * - 倾角仪
     - deg
     - X/Y 角度为度。

接口边界
--------

当前 SDK 发行目录提供 Windows ``.dll`` 和 ``.lib`` 文件，以及头文件和 demo。头文件包含跨平台导出宏，但如果要在 Linux 上部署，还需要对应的 ``.so`` 动态库和运行时依赖；仅有 Windows 二进制文件不能直接完成 Linux 构建。

.. seealso::

   :doc:`SDK 架构 <SDK-Architecture>`、:doc:`装卸柜工作流 <Guides/Container-Workflow>` 和 :doc:`安装与构建 <Get-Started/Installation>`。
