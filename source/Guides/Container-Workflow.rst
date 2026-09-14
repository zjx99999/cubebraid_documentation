:orphan:

装卸柜业务流程
==============

本页把 SDK 中的接口映射到一个典型的装卸柜任务。它描述的是软件协同关系，不是对现场 PLC、机器人程序或安全回路的替代；真正的动作顺序必须由项目控制逻辑和安全评审确认。

任务数据准备
------------

任务开始时，使用 JsonSDK 读取：

* 手眼标定 ``CalibrationPose``；
* SKU 长、宽、高和重量 ``SkuData``；
* 机器人取料/放料位姿 ``RobotPose``；
* 当前机器人状态 ``RobotState``；
* 面数、层数、动作号和 AGV 模式 ``ContinuationConfig``；
* 当前垛型、抓取模式、吸取方式、集装箱尺寸和偏移量 ``PalletizingPatternData``。

如果任务从断点恢复，还应先读取并校验 JSON/TXT 中的面、层和动作状态，再决定是否继续动作。

感知与定位
----------

#. 启动 Inclinometer，读取 X/Y 倾角并确认 ``isRunning()``。
#. 连接 Camera3D；根据项目模式选择主相机或上相机。
#. 使用 ``processTradition`` 计算集装箱内部或斜坡基准点。
#. 最后一面侧吸时使用 ``processLastSurface``。
#. 需要修正 AGV 航向时使用 ``processYaw``，并检查返回状态码和 yaw 输出。

CameraSDK 的 ``CalibrationPose`` 平移单位为米，算法输出 ``Point3D`` 也按 demo 以米输出；不要与 RobotSDK 目标位姿的毫米单位混用。

目标位姿计算
------------

RobotSDK 的算法接口根据视觉基准点、SKU 尺寸、垛型偏移和倾角计算抓取目标：

* ``Top_suction_angle``：顶吸的普通码法补偿；
* ``Top_suction_special``：顶吸特殊码法补偿；
* ``Side_suction_angle``：上层或下层侧吸补偿；
* ``computeDeltaEulerZYZ_deg``：计算 ZYZ 欧拉角相对旋转。

``fetchMode``、``fetchMode_side``、``model_mod``、``ROffset`` 和 ``switch_top_bottom_suction`` 会改变目标计算结果，应用层应把这些参数与当前垛型记录绑定，而不是写死在动作程序中。

设备协同
--------

典型的控制关系如下：

* AGV_SDK：完成定位移动、模式切换和位姿查询；
* RobotSDK：发送机器人目标位姿/关节指令并读取实际状态；
* PLC_SDK：发送取料参数、吸盘/底托信号、摆台角度和装柜进度；
* SensorSDK：持续提供倾角，并在需要时同步到 PLC；
* LoggerSDK：记录连接、状态、动作结果和急停原因。

动作完成后再更新 ``surface``、``layer``、``action`` 和数量状态。发生超时、状态不一致或倾角异常时，停止后续动作，记录上下文并进入项目定义的安全恢复流程。

建议的状态机
------------

可以在应用层实现如下状态机，并为每个状态增加超时和取消条件：

``准备参数`` → ``设备自检`` → ``AGV 定位`` → ``视觉定位`` → ``计算目标`` → ``PLC 握手`` → ``机器人取/放料`` → ``更新状态`` → ``下一箱/下一层``

其中每个箭头都应由实际状态反馈确认，不应仅根据“指令发送成功”判断动作完成。
