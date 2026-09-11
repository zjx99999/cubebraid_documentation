第一个程序
==========

建议先验证不驱动硬件的能力：读取 JSON 配置或调用机器人抓取补偿算法。确认参数和坐标约定正确后，再连接 AGV、相机、PLC 或机器人。

读取 JSON 配置
--------------

下面的示例对应 ``JsonParameterSDK.h`` 中的 C API，读取一个 SKU，并检查返回码：

.. code-block:: cpp

   #include "CubeBraidSDK/JsonSDK/JsonParameterSDK.h"
   #include <iostream>

   int main()
   {
       if (JsonParameterSDK_Initialize() != JSONPARAM_SDK_SUCCESS)
           return 1;

       SkuData sku{};
       const int ret = JsonParameterSDK_GetSku(
           "./data/json/sku_data.json", 0, &sku);

       if (ret == JSONPARAM_SDK_SUCCESS) {
           std::cout << sku.length << " x "
                     << sku.width << " x "
                     << sku.height << " mm\n";
       }

       JsonParameterSDK_Uninitialize();
       return ret == JSONPARAM_SDK_SUCCESS ? 0 : 1;
   }

SDK demo 使用的参数样例位于仓库的 ``scripts/JsonSDK/data``。如果从其他工作目录启动程序，请将 JSON 路径改为绝对路径或正确的相对路径。

调用纯算法接口
--------------

``RobotSDK`` 的目标位姿计算接口不要求先连接机械臂，可用于离线检查单位、抓取模式和垛型偏移：

.. code-block:: cpp

   #include "CubeBraidSDK/RobotSDK/RobotSDK.h"
   #include <iostream>

   int main()
   {
       using namespace robot_sdk;

       Pose centroid{1.46328, 1.52448, -0.611929};
       BoxDimension box{570.0f, 453.0f, 330.0f};
       Pose offset{-570.0, -453.0, 330.0, 0.0, 0.0, 0.0};

       const Pose target = RobotController::Top_suction_angle(
           centroid, box, 3, 1, 75.0f, offset,
           true, 0, 0.0);

       std::cout << target.x << ", "
                 << target.y << ", "
                 << target.z << " mm\n";
   }

这里的 ``centroid`` 示例为米，箱体和返回目标位置为毫米；请参阅 :doc:`产品与能力 <../About-CubeBraid>` 的单位表。

连接设备前
----------

设备连接程序的最小步骤通常是：

#. 确认设备 IP、端口、控制器模式和急停状态。
#. 创建 SDK 对象或句柄。
#. 建立连接并检查返回值。
#. 登录（AGV）或完成设备初始化。
#. 先读取状态，再发送最小、可回收的测试指令。
#. 在异常和退出路径中断开连接并销毁句柄。

具体的连接和控制接口请进入 :doc:`模块总览 <../Submodules>`。涉及真实运动时，必须先阅读 :doc:`安全须知 <../Guides/Safety>`。
