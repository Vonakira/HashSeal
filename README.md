<div align="center">

# 📦 HashSeal

> 🧾 一套“看得懂、用得顺”的文件哈希工具  
> Elegant & human-friendly file hash generator

<br>

![platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-blue?style=flat-square)
![version](https://img.shields.io/badge/version-v0.12.0-green?style=flat-square)
![license](https://img.shields.io/badge/license-MIT-lightgrey?style=flat-square)
![shell](https://img.shields.io/badge/shell-bash%20%7C%20cmd-orange?style=flat-square)

</div>

---

## ✨ 项目定位

大多数哈希工具的问题很简单：

- ❌ 只能命令行操作  
- ❌ 不同平台行为不一致  
- ❌ 输出信息冷冰冰难以理解  

**HashSeal 的目标很明确：**

> 👉 让文件处理的末端“普通人”也能顺手用哈希

---

## ✨ 核心特性

- 🫴🏻 **拖拽即用**（无需记命令）
- 🧠 **自动识别模式**
  - 输入文件 → 生成封签
  - 输入 `.sha256` → 校验
- 🖥 **三端统一体验**
  - macOS / Linux / Windows
- 🎨 **结构化输出**
  - 不再是一堆杂乱日志
- 🧾 **语义化设计**
  - 📜 卷宗（文件）
  - 🔐 封签（哈希）

---

## 🚀 使用方式

### 🖥 macOS / Linux

```bash
chmod +x HashSeal.sh
./HashSeal.sh file1 file2
```

或：

👉 直接拖文件进终端

---

### 🪟 Windows

👉 直接拖文件到：

```
HashSeal.bat
```

---

## 🧠 工作逻辑

### 📦 封签生成

输入：

```
file.txt
```

输出：

```
file.txt.sha256
```

内容：

```
HASH  file.txt
```

---

### 🔍 封签查验

输入：

```
file.txt.sha256
```

结果：

- ✔ 卷宗无误
- ✖ 卷宗异常
- ⚠ 卷宗缺失

---

## 🎭 设计说明（重要）

HashSeal 并不是一个“普通脚本”。

它有一套明确设计原则：

- 📊 **信息分层**（标题 / 状态 / 结果）
- 🎯 **减少认知负担**
- 🧘 **输出有节奏，不刷屏**
- 🧾 **语义统一（卷宗 / 封签）**

这不是装饰，是为了：

> 👉 让结果“扫一眼就懂”

---

## ⚠️ 注意事项

### Windows

- ⚠ 路径中包含特殊字符时可能异常
- ⚠ 编码环境（UTF-8 / 控制台）可能影响显示
- ⚠ 依赖 `certutil`

### macOS / Linux

- 自动选择：
  - `shasum` 或 `sha256sum`

---

## 📂 输出格式

统一标准：

```
HASH  filename
```

👉 可被其他工具直接识别

---

## 🧪 已测试环境

- macOS（Terminal）
- Linux（bash）
- Windows 10 / 11（CMD）

---

## 🛠 后续计划

- [ ] PowerShell 版本稳定化
- [ ] Windows 路径兼容增强
- [ ] 多算法支持（MD5 / SHA1 / SHA512）
- [ ] GUI 封装（可能）

---

## 📜 License

MIT

---

<div align="center">

**Made by 棉花**

优雅，但不复杂。

</div>