第四章：跨语言集成与部署指南
============================

本章说明 Python 应用层如何对接底层 SDK，并给出系统联调、异常处理、运行时发布和示例程序的使用要求。

.. toctree::
   :maxdepth: 2

   Guides/Python-Integration
   Guides/System-Integration
   Guides/Deployment
   Developer-Tools

集成原则
--------

应用层负责把 SDK 模块编排为可验证的任务状态机；它不能替代现场 PLC 程序、机器人控制器或功能安全回路。先完成离线参数和算法验证，再进行设备状态读取，最后才在受控条件下验证运动和 PLC 输出。
