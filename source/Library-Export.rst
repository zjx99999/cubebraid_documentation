1.3 C/C++ 动态导出库设计规范
=============================

为了保证系统在 Windows 与 Linux 环境下的跨平台兼容性，各 SDK 均采用条件编译的动态库导出/导入宏。常见宏包括 ``AGV_API``、``CAMERA3D_API``、``PLC_SDK_API`` 和 ``ROBOT_API``。

.. code-block:: cpp

   #ifdef _WIN32
   #  ifdef AGV_SDK_EXPORTS
   #    define AGV_API __declspec(dllexport)
   #  else
   #    define AGV_API __declspec(dllimport)
   #  endif
   #else
   #  define AGV_API __attribute__((visibility("default")))
   #endif

资源与二进制兼容性
------------------

内部关键资源管理遵循 RAII。复杂硬件操作类采用 PImpl（指向实现的指针）隐藏底层通讯细节和第三方库依赖，使公开头文件保持干净、轻量。

集成应用时仍必须匹配以下条件：

* C++14 标准、编译器 ABI、目标架构和 Debug/Release 配置；
* C ABI 的调用约定、结构体字段顺序和内存对齐；
* 与头文件同一发布版本的 ``.lib``、``.dll`` 和第三方运行时依赖。

``PLCStatus`` 与 ``PickUpData`` 使用 ``#pragma pack(push, 1)``。Python ``ctypes`` 映射时也必须设置 ``_pack_ = 1``；更多跨语言约定见 :doc:`Python 对接规范 <Guides/Python-Integration>`。
