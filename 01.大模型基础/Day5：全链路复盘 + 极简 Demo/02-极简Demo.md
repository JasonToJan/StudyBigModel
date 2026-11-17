# 02. 极简 Demo：人生第一次 API 调用

> Day5 学习笔记 · 第二篇 ｜ 阅读时间约 15 分钟 + 动手 25 分钟
> 目标：读完并跑通 demo 脚本后，你能独立完成一次 LLM API 调用，并看懂回包里每个字段的含义。

---

## 一、先说结论：调 API 就像点外卖

前四天我们搞懂了"后厨"（模型怎么工作）。今天第一次以**顾客身份**走进餐厅——调 API。

一次调用只需四要素，正好对应点外卖的全过程：

| 要素 | 点外卖类比 | 代码里长什么样 |
|---|---|---|
| **base_url** | 哪家店（平台地址） | `https://api.deepseek.com` |
| **api_key** | 你的会员卡（身份+扣款凭证） | `sk-xxxx`（**保密！**） |
| **model** | 点什么菜（用哪个模型） | `"deepseek-flash"` |
| **messages** | 订单备注（你想要什么） | 一组对话列表 |

> 🔑 **四要素记住就能调通任何平台的 API**——各家大模型（DeepSeek/GLM/Qwen，甚至 OpenAI）的接口格式高度一致（事实上的行业标准），换平台基本只改前三行。

---

## 二、messages：三种角色

messages 是一个列表，每条消息有 role 和 content。三种角色：

```python
messages = [
    {"role": "system",    "content": "你是一个简洁的中文助手。"},   # 人设/规则
    {"role": "user",      "content": "什么是大语言模型？"},          # 用户的问题
    {"role": "assistant", "content": "大语言模型是……"},               # 模型之前的回答
    {"role": "user",      "content": "能给个例子吗？"}               # 追问
]
```

- **system**：给模型的"岗位说明书"——人设、规则、输出格式。**多轮对话时它必须每轮都带着**（回忆 Day1：模型无记忆，历史靠你每次重新发送）
- **user**：用户说的话
- **assistant**：模型说过的话——多轮对话就是不断把 user/assistant 成对追加进列表再发出去

> 🔑 有没有觉得这个结构眼熟？**Day4 讲 SFT 数据时的 messages 结构，和你现在调 API 传的格式是同源的**——模型就是照这个格式被训练的，所以你也要按这个格式跟它说话。

---

## 三、回包解剖：菜 + 小票

非流式调用返回一个结构化对象，最重要的三个部位：

```
resp
├── choices[0].message.content   ← 【菜】模型说的话（真正要的东西）
├── choices[0].finish_reason     ← 【小票·停止原因】"stop"=说完 / "length"=被截断
└── usage                        ← 【小票·账单】
    ├── prompt_tokens            ← 输入消耗
    ├── completion_tokens        ← 输出消耗（更贵！）
    └── total_tokens             ← 总计
```

三个工程反射（Day1/Day3 学过的知识，在这里落地）：

1. 每次都看 **finish_reason**——`length` 说明被截断，先查 max_tokens
2. 每次都看 **usage**——这是你优化成本的数据来源；输出贵于输入，多轮对话输入滚雪球
3. **system prompt 也计费**——它每轮都被重新发送，长了就是持续成本

---

## 四、流式调用：一行之差

```python
# 非流式：等全部生成完，一次性拿到完整回答
resp = client.chat.completions.create(...)

# 流式：逐 token 推送，加上一个参数即可
stream = client.chat.completions.create(..., stream=True)
for chunk in stream:
    print(chunk.choices[0].delta.content, end="", flush=True)
```

这正是 Day1 第三课埋的伏笔的兑现时刻：**打字机效果 = 逐 token 推送**。面向用户的产品对话必开流式；批处理、数据流水线用非流式（好处理、好统计）。

---

## 五、跑起来

```bash
pip install openai          # 只需这一个库（各平台通用）
python first_api_demo.py    # 同文件夹下已备好
```

脚本分三部分，对应三个观察任务：

1. **非流式调用** → 解剖回包，看清 choices / finish_reason / usage
2. **流式调用** → 亲眼看到 token 一个个到达（终端里逐字蹦出来）
3. **usage 对比** → 短 system 和长 system 各调一次，看 prompt_tokens 跳变

跑完后把观察记录进 `demo_log.md`。

---

## 六、本篇小结

1. API 四要素：**base_url（哪家店）、api_key（会员卡）、model（点什么）、messages（备注）**——通吃各家平台
2. messages 三 role：**system 管人设、user 是提问、assistant 是历史**——和 SFT 数据结构同源
3. 回包三部位：**content（菜）、finish_reason（为什么停）、usage（账单）**——后两个每次都要看
4. 流式 = `stream=True` 一行之差；产品对话必开，批处理关闭

> 下一篇：**03. 模块 01 收官**——三句话带走整个模块，然后向 02 模块（大模型原理）进发。

---

## 自测三问（尝试不看正文回答）

1. 想让模型扮演"毒舌影评人"，该动 messages 里的哪个 role？
2. 看到回包 finish_reason="length"，说明什么？下一步查什么？
3. 为什么说"system prompt 长了是持续成本"？（提示：模型无记忆 + usage 怎么计费）
