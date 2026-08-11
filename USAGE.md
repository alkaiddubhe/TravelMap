# 使用步骤

## 1. 下载地图数据

首次使用需要下载地图数据到本地（只需一次）：

```bash
node download_map_data.js
```

这会生成 `china_cities.json` 文件（约 10-15 MB）。

> 💡 如果没有 Node.js，可以从这里下载：https://nodejs.org/

## 2. 启动本地服务器

因为浏览器安全限制，需要用本地服务器打开：

### 方法 1：使用 Python（推荐）

```bash
# Python 3
python -m http.server 8000

# Python 2
python -m SimpleHTTPServer 8000
```

然后打开浏览器访问：http://localhost:8000

### 方法 2：使用 Node.js

```bash
npx http-server -p 8000
```

### 方法 3：使用 VS Code

安装 "Live Server" 插件，右键 index.html 选择 "Open with Live Server"

## 3. 开始使用

打开后就可以：
- 选择状态（未去过、很想去、去过、去过但还想去、不想去）
- 切换范围（单个城市 / 整个省）
- 点击地图区域上色
- 分享链接、导出导入数据

## 调试模式

打开浏览器开发者工具（F12），控制台会输出：
- 点击的城市信息
- 当前模式（单城市/整省）
- 省份包含的城市数量
- 地图数据加载情况

## 后续部署

功能调试完成后，可以：
1. 上传到 GitHub Pages / Vercel 等平台
2. `china_cities.json` 文件一起上传（注意 GitHub 单文件限制 100MB）
3. 或者改回在线加载模式（需要修改 loadGeo 函数）
