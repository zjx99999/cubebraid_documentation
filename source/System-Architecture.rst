第一章：系统总体架构与工程设计
================================

本章介绍 CubeBraid 装卸柜机器人系统的分层架构、SDK 职责边界、典型装卸柜业务流程，以及 C/C++ 动态库的工程设计规范。

.. toctree::
   :maxdepth: 2

   SDK-Architecture
   About-CubeBraid
   Library-Export

阅读顺序
--------

#. 从 :doc:`系统架构设计 <SDK-Architecture>` 了解硬件通信、SDK 导出、业务控制和应用层的职责。
#. 阅读 :doc:`CubeBraid SDK 简介 <About-CubeBraid>`，确认模块能力、单位和接口边界。
#. 在 SDK 简介内阅读 :ref:`典型装卸柜业务流程 <container-workflow>`，理解各模块在任务中的协同关系。
#. 在集成 C++ 或 Python 前阅读 :doc:`C/C++ 动态导出库设计规范 <Library-Export>`，并按其中的 :ref:`模块总览 <module-overview>` 选择模块。
