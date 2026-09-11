Robot SDK
=========

头文件：``include/CubeBraidSDK/RobotSDK/RobotSDK.h``

命名空间：``robot_sdk``

RobotSDK 负责机器人控制器连接、状态读取、笛卡尔/关节运动和装卸柜抓取目标位姿计算。它使用 Eigen 进行姿态和运动学相关计算。

数据类型与单位
--------------

* ``Pose``：``x/y/z`` 为毫米，``rx/ry/rz`` 为度；
* ``Joint``：``j1`` 到 ``j6`` 为度；
* ``BoxDimension``：``length/width/height`` 为毫米；
* 抓取补偿接口的 ``centroid`` 注释和 demo 使用米，返回目标 ``Pose`` 的位置使用毫米。

``ControlMode``：

.. list-table::
   :header-rows: 1
   :widths: 32 16 52

   * - 模式
     - 值
     - 适用场景
   * - ``Coarse``
     - 1
     - 粗略到位/过渡点，头文件注释精度为 50 mm。
   * - ``Fine``
     - 2
     - 精准目标点，头文件注释精度为 1 mm。
   * - ``Transition``
     - 3
     - 远距离过渡点，头文件注释精度为 200 mm；关节控制接口的注释主要列出 Coarse/Fine。

连接与状态
----------

.. code-block:: cpp

   #include "CubeBraidSDK/RobotSDK/RobotSDK.h"

   robot_sdk::RobotController robot;
   if (robot.connectRobot("192.168.0.2", 31400, 31401)) {
       const robot_sdk::Pose pose = robot.GetCurrentPose();
       const robot_sdk::Joint joint = robot.GetCurrentJoint();
       const double j4 = robot.GetJoint4Angle();
       robot.disconnectRobot();
   }

默认运动端口为 ``31400``，状态端口为 ``31401``。连接成功只表示通信连接建立，运动前仍需确认机器人状态、模式、工具、限位和安全回路。

运动控制
--------

* ``controlPosture(mode, pose)``：以 ``Pose`` 发送笛卡尔空间目标；
* ``controlJoint(mode, joint)``：以六个关节角发送目标；
* ``GetCurrentPose()``、``GetCurrentJoint()``：读取当前缓存状态；
* ``GetJoint4Angle()``：单独读取 J4 角度；
* ``isConnected()``：读取连接状态。

抓取目标补偿
------------

.. code-block:: cpp

   const auto target = robot_sdk::RobotController::Top_suction_angle(
       centroid, box, fetchMode, sku_num, dis_y,
       poseOffset, ROffset, model_mod, inclx_angle);

公开的静态算法包括：

* ``top_x_value`` / ``top_z_value``：顶吸斜面 X/Z 补偿；
* ``side_x_value`` / ``side_z_value``：侧吸斜面 X/Z 补偿；
* ``Top_suction_angle``：普通码法顶吸；
* ``Top_suction_special``：特殊码法顶吸；
* ``Side_suction_angle``：侧吸，并通过 ``container_h`` 和 ``switch_top_bottom_suction`` 区分上层/下层场景；
* ``computeDeltaEulerZYZ_deg``：计算 ZYZ 欧拉角相对旋转。

``fetchMode`` 的头文件注释将 1/2 归为沿长边抓取，3/4 归为沿短边抓取。``model_mod`` 为 0 表示第一面、1 表示其他面；``ROffset`` 表示是否为每层最左侧垛型。

C ABI
-----

头文件导出 ``Robot_Create``、``Robot_Destroy``、``Robot_Connect``、``Robot_Disconnect``、``Robot_ControlPosture``、``Robot_ControlJoint``、``Robot_GetCurrentPose``、``Robot_GetCurrentJoint`` 和 ``Robot_GetJoint4Angle``，另外还导出目标位姿补偿和 ZYZ 计算函数。

.. warning::

   虽然这些函数位于 ``extern "C"`` 区域，补偿函数的参数仍包含 ``robot_sdk::Pose`` 和 ``robot_sdk::BoxDimension`` 等 C++ 类型。使用 Python ``ctypes`` 或其他 FFI 前，必须以实际导出 ABI 验证结构体布局；不能仅凭函数名判断它是纯 C 兼容接口。
