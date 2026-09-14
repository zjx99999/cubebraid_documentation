4.4 开发工具与示例
==================

SDK 仓库同时提供 C++ demo、Python ``ctypes`` 封装和参数样例。它们适合验证接口映射和设备联调，不是可直接用于生产的完整装卸柜任务调度器。

C++ demo
--------

根目录 ``CMakeLists.txt`` 为以下源码创建可执行文件：

.. list-table::
   :header-rows: 1
   :widths: 28 42 30

   * - 目标
     - 源文件
     - 主要验证内容
   * - ``agv_sdk_demo``
     - ``src/CubeBraidSDK/AGV_SDK/agv_sdk_demo.cpp``
     - AGV 登录、自动位移、手动速度和位姿。
   * - ``CameraSDK_demo``
     - ``src/CubeBraidSDK/CameraSDK/CameraSDK_demo.cpp``
     - 基准点、最后一面、航向角算法。
   * - ``jsonsdk_demo``
     - ``src/CubeBraidSDK/JsonSDK/jsonsdk_demo.cpp``
     - 配置读取、状态初始化、垛型数据。
   * - ``kawasaki_kinematics_sdk_demo``
     - ``src/CubeBraidSDK/KawasakiSDK/kawasaki_kinematics_sdk_demo.cpp``
     - RS080N 正解和逆解。
   * - ``logger_demo``
     - ``src/CubeBraidSDK/LoggerSDK/logger_demo.cpp``
     - 单例日志、格式化日志和急停记录。
   * - ``plc_sdk_demo``
     - ``src/CubeBraidSDK/PLC_SDK/plc_sdk_demo.cpp``
     - PLC 初始化、取料参数、信号和状态轮询。
   * - ``RobotSDK_demo``
     - ``src/CubeBraidSDK/RobotSDK/RobotSDK_demo.cpp``
     - 机器人运动、状态读取和抓取补偿。
   * - ``sensorsdk_demo``
     - ``src/CubeBraidSDK/SensorSDK/sensorsdk_demo.cpp``
     - 串口倾角仪启动、读取和停止。

Python 封装
-----------

``scripts`` 中可见的封装包括：

* ``AGV_SDK/agv_sdk.py``：``AGVClient``，支持上下文管理器和手动持续运动后自动归零；
* ``CameraSDK/camera_sdk.py``：Camera3D C ABI 的 ctypes 封装；
* ``JsonSDK/jsonparameter.py``：配置结构体和 JSON/TXT 查询接口；
* ``RobotSDK/robot_sdk.py``：机器人运动与目标位姿算法封装；
* ``SensorSDK/inclinometer.py``：倾角仪创建、启动、读取、归零和关闭；
* ``PLC_SDK/plc_sdk_demo.py``、``LoggerSDK/logger_sdk_demo.py`` 和运动学 demo：联调用例。

这些脚本通过相对路径寻找 ``bin`` 中的 DLL，实际使用时应从脚本所在目录或配置过的绝对路径启动。Python ``ctypes`` 的 ``argtypes`` 和 ``restype`` 必须与对应头文件一致。

参数样例
--------

JsonSDK 样例位于 ``scripts/JsonSDK/data``：

* ``data/json/Hand-eye_calibration_parameters.json``：手眼标定；
* ``data/json/sku_data.json``：SKU 尺寸和重量；
* ``data/json/setting_parameters.json``：机器人/倾角仪等设置；
* ``data/json/rd_demo_data_keba.json``、``rd_demo_data_kuka.json``：垛型数据；
* ``data/json/robot_data.json``：机器人状态；
* ``data/txt/continuation_config.txt``：续码配置。

不要把现场生产参数、设备凭据或含敏感信息的日志直接提交到公共仓库。
