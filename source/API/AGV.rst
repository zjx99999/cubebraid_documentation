AGV SDK
=======

头文件：``include/CubeBraidSDK/AGV_SDK/AGV_SDK.h``

``AGVController`` 通过 TCP 连接 AGV 控制器，内部维护接收线程和心跳线程。接口支持 C++ 对象方式，也导出以 ``AGV_Handle`` 为核心的 C ABI。

数据类型
--------

``AGVPose`` 包含 ``x``、``y``、``z``、``roll``、``pitch``、``yaw`` 六个 ``double`` 字段。仓库 demo 将 ``roll`` 和 ``pitch`` 输出为 AGV 前方/左侧距离；实际坐标含义应以 AGV 控制器协议和现场坐标系为准。

``ControlMode`` 枚举值：

.. list-table::
   :header-rows: 1
   :widths: 30 20 50

   * - 枚举
     - 值
     - 说明
   * - ``ControlMode::Manual``
     - 2
     - 手动速度控制。
   * - ``ControlMode::Auto``
     - 3
     - 自动位移控制。

C++ 生命周期与连接
------------------

.. code-block:: cpp

   #include "CubeBraidSDK/AGV_SDK/AGV_SDK.h"

   agv_sdk::AGVController agv;
   if (!agv.connectAGV("192.168.1.91", 5005)) {
       // 处理连接失败
   }

   if (agv.login("admin", password_hash)) {
       agv.switchControlMode(agv_sdk::ControlMode::Auto);
       const bool ok = agv.goForward(500.0, 30000);
       const auto pose = agv.getPose();
       agv.logout();
   }
   agv.disconnectAGV();

生产环境不要直接使用 demo 中的 IP、用户名或密码哈希。登录接口的第二个参数是已经计算好的 ``password_hash`` 字符串，哈希算法和凭据管理不由此接口定义。

运动与状态接口
--------------

.. list-table::
   :header-rows: 1
   :widths: 42 28 30

   * - 接口
     - 返回值
     - 说明
   * - ``connectAGV(ip, port)``
     - ``bool``
     - 建立 TCP 连接并启动后台线程。
   * - ``disconnectAGV()``
     - ``void``
     - 停止后台线程并释放连接。
   * - ``login(username, password_hash)``
     - ``bool``
     - 登录 AGV 系统。
   * - ``logout()``
     - ``bool``
     - 注销当前会话。
   * - ``switchControlMode(mode)``
     - ``bool``
     - 切换手动或自动模式。
   * - ``goForward(dist_mm, timeout_ms)``
     - ``bool``
     - 自动模式下阻塞等待前进动作完成，默认超时 30000 ms。
   * - ``goBack(dist_mm, timeout_ms)``
     - ``bool``
     - 自动模式下阻塞等待位移完成，默认超时 30000 ms。
   * - ``manualCtlVelSet(vx, vy, w)``
     - ``bool``
     - 手动模式发送一次速度指令；``vx/vy`` 为 mm/s，``w`` 按头文件为 0.001 rad/s。
   * - ``moveManualForDuration(...)``
     - ``bool``
     - 持续重发手动速度，结束时发送速度归零；仅 C++ 类接口提供。
   * - ``querySystemState()``
     - ``bool``
     - 主动请求 AGV 系统状态。
   * - ``sendHeartBeatsMsg()``
     - ``bool``
     - 手动发送一次心跳；类内部已有心跳线程。
   * - ``getPose()``
     - ``AGVPose``
     - 线程安全读取本地缓存位姿。

``goBack`` 的正负方向由 AGV 控制器协议定义；仓库 C++/Python demo 使用 ``+500`` 表示单步前进、``-500`` 表示单步后退，集成前应在现场确认。

C ABI
-----

.. code-block:: cpp

   typedef void* AGV_Handle;
   AGV_Handle AGV_Create();
   void AGV_Destroy(AGV_Handle handle);
   bool AGV_Connect(AGV_Handle handle, const char* ip, int port);
   void AGV_Disconnect(AGV_Handle handle);
   bool AGV_Login(AGV_Handle handle, const char* username,
                  const char* password_hash);
   bool AGV_Logout(AGV_Handle handle);
   bool AGV_SwitchControlMode(AGV_Handle handle, C_ControlMode mode);
   bool AGV_GoForward(AGV_Handle handle, double dist_mm, int timeout_ms);
   bool AGV_GoBack(AGV_Handle handle, double dist_mm, int timeout_ms);
   bool AGV_ManualCtlVelSet(AGV_Handle handle, float vx, float vy, float w);
   bool AGV_QuerySystemState(AGV_Handle handle);
   bool AGV_SendHeartBeatsMsg(AGV_Handle handle);
   C_AGVPose AGV_GetPose(AGV_Handle handle);

Python 封装中的 ``AGVClient`` 还提供 ``move_manual_for_duration``，会在 ``finally`` 中发送 ``0, 0, 0`` 停止指令。网络中断或控制器异常时，应用仍必须依赖现场安全回路和人工急停。
