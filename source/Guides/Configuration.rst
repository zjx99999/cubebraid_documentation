:orphan:

参数与配置文件
==============

JsonSDK 使用 JSON 和 TXT 文件为装卸柜任务提供运行参数。SDK 仓库中的样例位于 ``scripts/JsonSDK/data``，包括 Keba 和 Kuka 命名的部分配置文件。

文件与接口
----------

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

结构体要点
----------

* ``CalibrationPose``：``x/y/z`` 加 ``qw/qx/qy/qz`` 四元数；
* ``SkuData``：长、宽、高为 mm，重量为 kg；
* ``RobotPose``：``x/y/z`` 与 ``rx/ry/rz``；
* ``RobotState``：工作模式、面、层、动作、总数量以及当前位姿；
* ``PalletizingPatternData``：面/层、夹具和抓取模式、吸取方式、偏移量、SKU/集装箱尺寸及单次数量。

错误处理
--------

所有读取接口返回 ``JsonParameterSDKError`` 枚举中的整数错误码。常见错误包括文件不存在 ``-3``、JSON 解析失败 ``-4``、字段缺失 ``-6``、索引非法 ``-7`` 和 TXT 配置错误 ``-10``。失败后可以调用 ``JsonParameterSDK_GetLastError`` 获取文本信息。

参数修改
--------

``SetJsonInt``、``SetJsonFloat`` 和 ``SetJsonString`` 会直接修改文件中的字段；生产系统应先备份、校验字段范围，再执行写入。``InitRobotData`` 也会更新机器人状态文件，不应在任务运行中无条件调用。

接口细节
--------

``JsonParameterSDK_GetContinuationSurfaceLayer`` 的头文件参数顺序是 ``layer_num`` 后 ``surface_num``；仓库 demo 中局部变量命名与传参顺序容易混淆，集成时应以头文件声明为准。
