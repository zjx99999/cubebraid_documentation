3.7 配置文件解析模块（JsonParameter SDK）
===========================================

头文件：``include/CubeBraidSDK/JsonSDK/JsonParameterSDK.h``

Json SDK 是纯 C ABI 的参数读写库，接口以文件路径、索引和输出结构体为主，适合 C/C++、Python ``ctypes`` 和其他 FFI 调用。

生命周期
--------

所有其他接口前调用：

.. code-block:: cpp

   const int ret = JsonParameterSDK_Initialize();
   if (ret != JSONPARAM_SDK_SUCCESS) {
       // 初始化失败
   }

   // 调用读取或写入接口
   JsonParameterSDK_Uninitialize();

数据结构
--------

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

   * - 类型
     - 字段
     - 单位/用途
   * - ``CalibrationPose``
     - ``x/y/z``, ``qw/qx/qy/qz``
     - 手眼标定平移和四元数姿态。
   * - ``SkuData``
     - ``length/width/height/weight``
     - 产品长宽高为 mm，重量为 kg。
   * - ``RobotPose``
     - ``x/y/z``, ``rx/ry/rz``
     - 机器人取料/放料位姿。
   * - ``ContinuationConfig``
     - ``surface_num``, ``layer_num``, ``work_mode_num``, ``agv_mode_num``, ``action_num``, ``stack_type``
     - 续码任务配置。
   * - ``RobotState``
     - 工作模式、面、层、动作、数量及 ``x/y/z/rx/ry/rz``
     - 机器人运行状态。
   * - ``PalletizingPatternData``
     - 面/层、夹具/抓取模式、吸取方式、偏移量、SKU/集装箱尺寸、数量
     - 垛型与装柜计算输入。

查询接口
--------

.. list-table::
   :header-rows: 1
   :widths: 48 52

   * - 函数
     - 功能
   * - ``JsonParameterSDK_CheckJsonFile(file_path)``
     - 检查 JSON 文件存在性和格式。
   * - ``JsonParameterSDK_GetCalibration(file_path, cam_mode, result)``
     - 读取指定相机模式的手眼标定。
   * - ``JsonParameterSDK_GetSku(file_path, sku_index, result)``
     - 读取 SKU。
   * - ``JsonParameterSDK_GetAgvAngle(file_path, angle_index, angle)``
     - 读取 AGV 航向角。
   * - ``JsonParameterSDK_GetRobotPose(file_path, param_mode, result)``
     - 读取机器人位姿。
   * - ``JsonParameterSDK_GetInclinometerPort(file_path, port_index, port)``
     - 将倾角仪端口写入调用方提供的字符缓冲区。
   * - ``JsonParameterSDK_GetContinuationSurfaceLayer(file_path, index, layer_num, surface_num)``
     - 读取指定索引的续码层数和面数。
   * - ``JsonParameterSDK_GetRobotState(file_path, result)``
     - 读取机器人状态。
   * - ``JsonParameterSDK_GetContinuationConfig(file_path, result)``
     - 读取 TXT 续码配置。
   * - ``JsonParameterSDK_GetStackStyleDiffX(file_path, index, diff_x)``
     - 读取特殊面 ``diff_x`` 补偿。
   * - ``JsonParameterSDK_GetPalletizingPatternData(file_path, index, result)``
     - 读取垛型记录。

``GetContinuationSurfaceLayer`` 的头文件声明顺序是 ``layer_num`` 后 ``surface_num``。仓库 C++ demo 中变量名与传参顺序容易造成误解，集成代码应按头文件原型传递指针。

修改接口
--------

* ``JsonParameterSDK_InitRobotData(file_path)``：初始化机器人状态文件；
* ``JsonParameterSDK_SetJsonInt(file_path, field_name, value)``；
* ``JsonParameterSDK_SetJsonFloat(file_path, field_name, value)``；
* ``JsonParameterSDK_SetJsonString(file_path, field_name, value)``。

这些接口会写入配置文件。生产系统应在写入前备份并校验字段范围，避免在机器人动作执行期间无条件重置状态。

错误码
------

.. list-table::
   :header-rows: 1
   :widths: 12 38 50

   * - 值
     - 常量
     - 含义
   * - 0
     - ``JSONPARAM_SDK_SUCCESS``
     - 成功。
   * - -1
     - ``JSONPARAM_SDK_ERROR_UNKNOWN``
     - 未知错误。
   * - -2
     - ``JSONPARAM_SDK_ERROR_INVALID_PARAM``
     - 参数无效。
   * - -3
     - ``JSONPARAM_SDK_ERROR_FILE_NOT_FOUND``
     - 文件不存在或无法打开。
   * - -4
     - ``JSONPARAM_SDK_ERROR_JSON_PARSE``
     - JSON 解析失败。
   * - -5
     - ``JSONPARAM_SDK_ERROR_JSON_EMPTY``
     - JSON 内容为空。
   * - -6
     - ``JSONPARAM_SDK_ERROR_FIELD_MISSING``
     - 缺少字段。
   * - -7
     - ``JSONPARAM_SDK_ERROR_INDEX_INVALID``
     - 索引非法。
   * - -8
     - ``JSONPARAM_SDK_ERROR_BUFFER_SMALL``
     - 输出缓冲区过小。
   * - -9
     - ``JSONPARAM_SDK_ERROR_WRITE_FAILED``
     - 文件写入失败。
   * - -10
     - ``JSONPARAM_SDK_ERROR_CONFIG``
     - TXT 配置错误。

失败后可使用 ``JsonParameterSDK_GetLastError(buffer, buffer_size)`` 读取文本错误信息。

.. _parameter-configuration:

参数与配置文件
--------------

JsonSDK 使用 JSON 和 TXT 文件为装卸柜任务提供运行参数。SDK 仓库中的样例位于 ``scripts/JsonSDK/data``，包括 Keba 和 Kuka 命名的部分配置文件。

文件与接口
~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 35 35 30

   * - 数据
     - 典型文件
     - 读取接口
   * - 手眼标定
     - ``Hand-eye_calibration_parameters.json``
     - ``GetCalibration``
   * - SKU
     - ``sku_data.json``
     - ``GetSku``
   * - AGV 航向角
     - ``agv_angle.json``
     - ``GetAgvAngle``
   * - 机器人位姿
     - ``setting_parameters.json`` / ``RobotPose.json``
     - ``GetRobotPose``
   * - 倾角仪端口
     - ``setting_parameters.json``
     - ``GetInclinometerPort``
   * - 机器人状态
     - ``robot_data.json``
     - ``GetRobotState`` / ``InitRobotData``
   * - 垛型
     - ``rd_demo_data_keba.json`` / ``rd_demo_data_kuka.json``
     - ``GetPalletizingPatternData``
   * - 续码
     - ``continuation_config.txt``
     - ``GetContinuationConfig``
   * - 特殊面补偿
     - ``test_demo.json``
     - ``GetStackStyleDiffX``

持久化与续码
~~~~~~~~~~~~

``RobotState`` 与 ``ContinuationConfig`` 记录工作模式、当前面、当前层、当前动作及完成数量。发生可恢复中断时，应用应先读取并校验这些状态，再决定是否继续任务；不要在动作执行中无条件调用 ``InitRobotData``。

``JsonParameterSDK_SetJsonInt``、``JsonParameterSDK_SetJsonFloat`` 和 ``JsonParameterSDK_SetJsonString`` 会直接写入配置文件。生产环境应先备份文件、校验字段范围并记录修改来源。

Python 调用例程
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   from json_parameter_sdk import JsonParameterSDK

   sdk = JsonParameterSDK()
   calib = sdk.get_calibration(
       "./data/json/Hand-eye_calibration_parameters.json", cam_mode=0)
   sku = sdk.get_sku("./data/json/sku_data.json", sku_index=0)
   print(f"标定 X/Y/Z: {calib.x}, {calib.y}, {calib.z}")
   print(f"SKU 尺寸: {sku.length} x {sku.width} x {sku.height}")
