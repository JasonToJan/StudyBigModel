# Day01：Transformer 三大架构

> 时长：2.5～3h ｜ 目标：从 01 模块的"三种拼法"直觉，升级到能看懂三种 block 的**结构图纸**——差异不在积木种类，而在组合方式和"谁能看谁"
> 前置：01 模块 Day2（三大架构直觉版、自注意力直觉版）

---

## 一、学习目标（今日结束时你应该能回答）

1. 一个 Transformer block 的通用骨架是什么？（四大件）
2. Encoder block 和 Decoder block 在结构上差在哪？（层数与注意力种类）
3. 原版 Decoder（如 T5 的解码器）里的"交叉注意力"是干什么的？
4. Decoder-only 把结构砍到最简，为什么反而赢了？（比 01 模块更深一层的原因）
5. 模型的 config.json 里，哪些数字对应"架构规模"？

---

## 二、学习内容（约 95 分钟）

### 1. 复习与升级：从拼法到图纸（10min）

- 01 模块直觉版：三种拼法（只读 / 读+写 / 只写）
- 今天的升级：打开每种 block 的结构图，看清"积木怎么组合"

### 2. 通用骨架：每个 block 都有的四大件（15min）

- 注意力层（信息交换）+ FFN（独立消化）+ 残差连接（防记忆丢失）+ LayerNorm（稳住数值）
- 记住这个"套娃公式"：**Block = 注意力 → FFN，外面各包一层（残差+归一化）**

### 3. Encoder block 解剖（15min）

- 双向自注意力 + FFN，一层式结构
- 双向 = 每个 token 能看到左右所有词（理解力强）

### 4. Decoder block 解剖（25min，今日重点）

- 原版 Decoder（T5/翻译模型）有三层：
  1. **带掩码的自注意力**（生成时只能看已生成的左边）
  2. **交叉注意力**（拿生成的半成品去"查阅"Encoder 的理解结果）——翻译场景：看一眼原文，写一个词
  3. FFN
- Decoder-only（GPT 系）把中间的交叉注意力删了——因为输入输出已经在同一条序列里

### 5. Decoder-only 为什么极简反而赢（15min）

- 01 模块的理由：任务统一、数据白嫖、结构简单、已验证
- 今天追加两个技术理由：
  - **训练信号效率**：每个位置都能产生一个"预测下一个词"的训练信号（Encoder-Decoder 只有 Decoder 侧有）
  - **KV Cache 友好**：单流结构缓存机制天然简单（Day09 展开）

### 6. 读 config.json：把架构参数对上号（15min）

- 用 HuggingFace 上 Qwen 的真实 config.json 对照：hidden_size / num_hidden_layers / num_attention_heads
- 和 Day2 笔记的"4096 维、32 层、32 头"互相验证

---

## 三、实操任务（约 60 分钟）

### 实操 1：画三种 block 的结构图（20min）

- 不看笔记，画出 Encoder block / Decoder block / Decoder-only block 的结构草图并标注差异
- 对照笔记 01 补漏，产出存 `block_diagrams.md`

### 实操 2：读真实模型的 config.json（20min）

- 打开 HuggingFace 搜 "Qwen2.5-7B"（或任一模型）→ Files → config.json
- 找出并记录：hidden_size、num_hidden_layers、num_attention_heads、max_position_embeddings、vocab_size
- 每个数字用一句话说明"它管什么"，产出存 `config_reading.md`

### 实操 3：架构进阶分类（20min）

- 判断以下组件/模型属于哪种架构，并说明结构依据：
  T5 的解码器为什么有三层注意力相关组件？bert-base-chinese 能用来写小说吗？为什么？
- 产出存 `architecture_quiz.md`

---

## 四、今日产出（存入本文件夹）

- [ ] `notes.md`：用自己的话回答开头 5 个问题（参考答案：`notes-参考答案.md`）
- [ ] `block_diagrams.md`：实操 1 结构图
- [ ] `config_reading.md`：实操 2 记录
- [ ] 一句话总结：**三种架构的差异 = 注意力掩码方向 + 有没有交叉注意力 + 砍得多不多**

---

## 五、自测清单

- [ ] 能默写 block 的四大件和"套娃公式"
- [ ] 能画出 Decoder block 三层结构并说出交叉注意力的作用
- [ ] 能说出 Decoder-only 赢的两个技术理由（训练信号 + KV Cache）
- [ ] 看到 config.json 里的 num_hidden_layers=32 知道它是什么

---

## 六、明日预告（Day02：位置编码 RoPE）

今天的图纸里有一块没画：**位置信息从哪来**。明天拆"座次号"的发法——从绝对位置编码到旋转位置编码 RoPE，以及它如何决定"上下文窗口能不能外推"。

---

## 参考资料推荐

- HuggingFace 任一模型的 config.json（今天的主角之一）
- The Illustrated Transformer（对照本篇看结构图）
- Jay Alammar 的 "The Illustrated Transformer" 与图解 GPT-2 系列
