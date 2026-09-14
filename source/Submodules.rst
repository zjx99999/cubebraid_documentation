:orphan:

模块总览
========

CubeBraid SDK 的公开模块按装卸柜机器人系统中的职责组织。点击模块名称进入对应的接口参考页。

.. list-table::
   :header-rows: 1
   :widths: 20 35 25 20

   * - 模块
     - 主要能力
     - 头文件
     - 二进制
   * - :doc:`AGV SDK <API/AGV>`
     - AGV 连接、登录、模式切换、位移和位姿
     - ``AGV_SDK.h``
     - ``AGV_SDK.dll``
   * - :doc:`Camera SDK <API/Camera>`
     - 基准点、最后一面和航向角算法
     - ``CameraSDK.h``
     - ``CameraSDK.dll``
   * - :doc:`Json SDK <API/Json>`
     - 参数、状态、垛型和续码文件
     - ``JsonParameterSDK.h``
     - ``JsonParameterSDK.dll``
   * - :doc:`Robot SDK <API/Robot>`
     - 机器人运动、状态和抓取位姿补偿
     - ``RobotSDK.h``
     - ``RobotSDK.dll``
   * - :doc:`PLC SDK <API/PLC>`
     - DB 读写、离散信号和装柜状态
     - ``PLC_SDK.h``
     - ``PLC_SDK.dll`` + ``snap7.dll``
   * - :doc:`Sensor SDK <API/Sensor>`
     - DXL360 串口倾角采集
     - ``InclinometerSDK.h``
     - ``InclinometerSDK.dll``
   * - :doc:`Kawasaki SDK <API/Kawasaki>`
     - RS080N 正逆运动学和奇异点规避
     - ``kawasaki_kinematics_sdk.h``
     - ``KawasakiKinematicsSDK.dll``
   * - :doc:`Logger SDK <API/Logger>`
     - 文件日志、格式化输出和急停日志
     - ``LoggerSDK.h``
     - ``LoggerSDK.dll``

选择 C++ 还是 C ABI
--------------------

* C++ 接口通常包含更完整的对象模型、枚举、引用参数和 Eigen 类型，适合直接集成到 C++ 控制程序。
* C ABI 以句柄和基础类型为主，适合 Python ``ctypes``、C# 或其他 FFI；但各模块公开的 C ABI 完整度不同。
* 使用动态库前，必须检查导出的符号是否与头文件和 Python 封装一致。发现声明不一致时，以实际发布版本的头文件和二进制为准，不要盲目复制示例。完整接口列表见 :doc:`API 参考 <API-Reference>`。
