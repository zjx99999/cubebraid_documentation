# CubeBraid 装卸柜机器人技术文档

本仓库使用 Sphinx 和 Read the Docs 主题构建 CubeBraid 装卸柜机器人技术文档网站。页面内容围绕 `cubebraid_sdk` 的公开头文件、C++ demo、Python ctypes 封装和参数样例整理。

## 文档构建环境

需要 Python 3.11 或更高版本，以及 Sphinx 依赖：

```powershell
python -m venv cubebraiddoc

# 激活
cubebraiddoc\Scripts\activate

# 安装依赖（仅安装一次）
python -m pip install -r requirements.txt -c constraints.txt
```


## 构建 HTML

```powershell
python -m sphinx -E -W -b html -c . source build\html
```

生成结果位于 `build\html`，使用项目内置的禁缓存 HTTP 服务预览：

```powershell
python serve_docs.py --host localhost --port 8000 --directory build\html
```

浏览器访问 <http://localhost:8000>。


## CubeBraid SDK

SDK 源码和二进制文件请从官方仓库获取：

<https://github.com/GJXS1980/cubebraid_sdk>

SDK 仓库包含 `include`、`lib`、`bin`、`src`、`scripts` 和 `doc` 目录。当前构建说明以 Windows、Visual Studio 2022、x64 和 C++14 为主；Linux 使用需要匹配的 `.so` 发布包。

## 目录说明

* `source/`：Sphinx 文档源文件；
* `source/API/`：按模块整理的 API 页面；
* `source/Guides/`：装卸柜工作流、配置、安全和部署指南；
* `conf.py`：项目、主题和构建配置；
* `build/`：HTML 输出目录，不提交到 Git。

# 设置开机自启动(ubuntu)
```bash
# 创建 systemd 服务
sudo gedit /etc/systemd/system/cubebraiddoc.service
```
cubebraiddoc.service文件内容如下：
```bash
[Unit]
Description=CubeBraid Documentation HTTP Server
After=network.target

[Service]
Type=simple
User=hgrd
WorkingDirectory=/home/hgrd/demo/cubebraid_documentation
ExecStart=/home/hgrd/demo/cubebraid_documentation/cubebraiddoc/bin/python -m http.server 8000 --bind 0.0.0.0 --directory /home/hgrd/demo/cubebraid_documentation/build/html
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

环境配置：
```bash
# 让 systemd 重新读取配置
sudo systemctl daemon-reload

# 设置开机自动启动
sudo systemctl enable cubebraiddoc.service

# 立即启动
sudo systemctl start cubebraiddoc.service

# 检查服务状态
sudo systemctl status cubebraiddoc.service

# 浏览器访问
http://localhost:8000
```