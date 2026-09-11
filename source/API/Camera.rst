Camera SDK
==========

头文件：``include/CubeBraidSDK/CameraSDK/CameraSDK.h``

命名空间：``camera3d_sdk``

CameraSDK 面向装卸柜视觉定位和几何计算。公开头文件提供 C++ ``Camera3D`` 类，使用 PImpl 隐藏实现；SDK 仓库的 Python 脚本还尝试绑定 ``Camera3D_Create`` 等 C 导出符号，使用前应确认当前 DLL 确实导出了这些符号。

状态码
------

``StatusCode``：

.. list-table::
   :header-rows: 1
   :widths: 38 15 47

   * - 枚举
     - 值
     - 含义
   * - ``SUCCESS``
     - 0
     - 执行成功。
   * - ``CAMERA_CONNECT_FAILED``
     - 1
     - 相机连接失败。
   * - ``CAMERA_CAPTURE_FAILED``
     - 2
     - 图像采集失败。
   * - ``INVALID_PARAMETER``
     - 3
     - 参数无效。
   * - ``CALIBRATION_FAILED``
     - 4
     - 标定失败。
   * - ``POINT_CLOUD_FAILED``
     - 5
     - 点云处理失败。
   * - ``ALGORITHM_FAILED``
     - 6
     - 算法处理失败。
   * - ``INTERNAL_ERROR``
     - 99
     - 内部错误。

数据结构
--------

* ``Point3D``：``float x/y/z`` 三维点；算法 demo 以米打印结果。
* ``CalibrationPose``：``x/y/z`` 为米，``qw/qx/qy/qz`` 为四元数姿态。
* ``CameraConfig``：主相机 ``camera_ip``、装卸一体模式的上相机 ``camera_ip_up``、深度文件和颜色文件路径。

初始化与连接
------------

.. code-block:: cpp

   camera3d_sdk::Camera3D camera;
   camera3d_sdk::CameraConfig config;
   config.camera_ip = "192.168.23.203";
   config.camera_ip_up = "192.168.23.88";
   config.depth_file = "./data/img/depth.tiff";
   config.color_file = "./data/img/demo.png";

   const auto status = camera.initialize(config);
   if (status == camera3d_sdk::StatusCode::SUCCESS && camera.connect()) {
       // 进行视觉算法调用
       camera.disconnect();
   }

也可以使用 ``isConnected``、``getLastStatus`` 和 ``getLastError`` 诊断连接或算法失败。``Camera3D`` 禁止拷贝，但支持移动构造和移动赋值。

业务算法
--------

``processTradition``：

.. code-block:: cpp

   camera3d_sdk::CalibrationPose calib;
   camera3d_sdk::Point3D result;
   const auto status = camera.processTradition(
       calib, camera_ip, 0, agv_x, agv_y, angle,
       j1_angle, false, result);

``model_mod`` 为 ``0`` 时表示第一面顶吸基准点，``1`` 表示其他面；``integrated_load_unload_mode`` 为 ``true`` 表示装卸一体模式，``false`` 表示摆台模式。``agv_x``、``agv_y``、``angle`` 和 ``j1_angle`` 的含义必须与现场坐标及标定流程一致。

其他算法接口：

* ``processLastSurface(calib_pose, cameraIP, agv_x, agv_y, j1_angle, integrated_mode, result)``：最后一面侧吸基准点；
* ``processYaw(calib_pose, cameraIP, slam_x, slam_y, j1_angle, integrated_mode, yaw)``：加强筋法向和 AGV 航向角偏差，输出 yaw 为度；失败或误差过大时，头文件说明可能返回 ``90.0`` 作为异常结果；
* ``statusToString(status)``：将状态码转换为可读字符串。

头文件当前未声明 Camera3D 的 C ABI。Python 脚本的 C ABI 映射属于仓库脚本实现，若要作为稳定公共接口使用，应在发布头文件中补齐并固定 C 结构体声明。
