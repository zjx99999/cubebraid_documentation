5. 电气控制与 PLC 交互模块（PLC SDK）
======================================

头文件：``include/CubeBraidSDK/PLC_SDK/PLC_SDK.h``

命名空间：``plc_sdk``

PLC_SDK 基于 Snap7 客户端连接 PLC，提供 DB 块安全读写、装卸柜离散信号、取料参数发送和实时状态缓存。公开目录中 PLC 模块还依赖 ``bin/snap7.dll``。

数据结构
--------

``PLCStatus`` 使用 ``#pragma pack(push, 1)``，包含 10 个 ``int16_t`` 状态字段：

* ``suction_cup_state``：吸盘状态；
* ``fixture_state``：底托状态；
* ``robot_pick_state``：机器人取料状态；
* ``robot_leave_state``：允许机器人取料离开状态；
* ``table_control_state``：摆台控制状态；
* ``hydraulic_rod_rise_state`` / ``hydraulic_rod_lower_state``：液压杆状态；
* ``plc_init_state``：PLC 初始化状态；
* ``table_init_control_ok_state``：摆台初始化完成状态；
* ``plc_data_request_state``：PLC 数据请求状态。

``PickUpData`` 同样按 1 字节对齐，包含 ``fetch_mode``、``mode_switch``、SKU 长宽高、``sku_num`` 和单箱重量 ``sku_weight``。尺寸单位为 mm，重量单位为 kg。

C++ 接口
--------

.. code-block:: cpp

   plc_sdk::PLCController plc;
   if (plc.connect("192.168.30.49", 0, 1)) {
       PickUpData data{};
       data.fetch_mode = 4;
       data.mode_switch = 2;
       data.sku_l = 600;
       data.sku_w = 500;
       data.sku_h = 400;
       data.sku_num = 1;
       data.sku_weight = 5.5;

       plc.triggerPLCInit();
       plc.sendPickUpData(data);
       const PLCStatus status = plc.getStatus();
       plc.disconnect();
   }

主要接口：

* 连接：``connect(ip, rack = 0, slot = 1)``、``disconnect``、``isConnected``；
* DB：``safeDBWrite``、``safeDBRead``；
* 吸盘/底托：``setOpenSuctionCup``、``setCloseSuctionCup``、``setSuctionCupPickingOK``、``setFixtureRollOut``、``setFixtureInitialization``；
* 异常：``setInclinometerErrorSignal``；
* 状态：``getStatus``；
* 业务同步：``controlTableAngle``、``updateBoxState``、``updateInclinometerAngle``、``updateTotalBoxState``、``sendPickUpData``；
* 初始化：``triggerPLCInit``、``triggerTableInit``。

C ABI
-----

C 接口使用 ``PLC_HANDLE``：

.. code-block:: cpp

   PLC_HANDLE plc_create(void);
   void plc_destroy(PLC_HANDLE handle);
   bool plc_connect(PLC_HANDLE handle, const char* ip, int rack, int slot);
   void plc_disconnect(PLC_HANDLE handle);
   bool plc_is_connected(PLC_HANDLE handle);
   bool plc_safe_db_write(PLC_HANDLE handle, int dbNumber,
                          int start, int size, void* buffer);
   bool plc_safe_db_read(PLC_HANDLE handle, int dbNumber,
                         int start, int size, void* buffer);
   bool plc_get_status(PLC_HANDLE handle, PLCStatus* status_out);
   bool plc_send_pickup_data(PLC_HANDLE handle, const PickUpData* data);

   void plc_set_open_suction_cup(PLC_HANDLE handle, bool enable);
   void plc_set_close_suction_cup(PLC_HANDLE handle, bool enable);
   void plc_set_fixture_roll_out(PLC_HANDLE handle, bool enable);
   void plc_set_fixture_initialization(PLC_HANDLE handle, bool enable);
   void plc_set_suction_cup_picking_ok(PLC_HANDLE handle, bool enable);
   void plc_set_retrieving_completion_side(PLC_HANDLE handle, bool enable);
   void plc_set_inclinometer_error_signal(PLC_HANDLE handle, bool enable);
   void plc_control_table_angle(PLC_HANDLE handle, int angle_mode);
   void plc_update_box_state(PLC_HANDLE handle, int surface_num,
                             int lay_num, int box_num);
   void plc_update_inclinometer_angle(PLC_HANDLE handle, float angle_value);
   void plc_update_total_box_state(PLC_HANDLE handle, int totalbox_num,
                                  int remain_num);
   bool plc_trigger_plc_init(PLC_HANDLE handle);
   bool plc_trigger_table_init(PLC_HANDLE handle);

Python 映射
-----------

Python demo 将 ``PLCStatus`` 和 ``PickUpData`` 都设置为 ``_pack_ = 1``，并且先加载 ``snap7.dll`` 再加载 ``PLC_SDK.dll``。缺少 Snap7、结构体未对齐或 DLL 位数不匹配都会导致加载或数据读取失败。

PLC 输出接口会改变现场状态，联调时必须配合 PLC 程序、信号表和安全回路逐项核对，不能仅凭 ``void`` 返回类型判断已完成。
