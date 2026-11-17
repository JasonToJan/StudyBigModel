# Day5 notes.md 参考答案

> 用法：先自己写 `notes.md`，再对照自评。意思对、能讲出来就合格。

---

## 1. 从你敲下文字到看到回答，中间经过哪几站？

七站 + 一个底座：

```
输入侧：① 切 token（Tokenizer 文字→编号）
        ② Embedding 上语义地图 + 位置编码发座号
计算侧：③ N 层 Block（自注意力开会 Q/K/V + FFN 消化）
输出侧：④ 全词表打分 → 概率表
        ⑤ 采样参数遥控（temperature 分蛋糕 / top_p 圈人）挑出 token
循环：  ⑥ 拼回输入回到③，直到结束符或 max_tokens
交付：  ⑦ 逐 token 流式推送到屏幕（打字机效果）
底座：  预训练学知识 → SFT 教格式 → RLHF/DPO 教偏好 → 三看选型上岗
```

## 2. 一次 API 调用的四要素是什么？

| 要素 | 作用 |
|---|---|
| base_url | 哪家店（平台地址） |
| api_key | 会员卡（身份+扣款凭证，**保密**） |
| model | 点什么菜（用哪个模型） |
| messages | 订单备注（一组带 role 的对话：system 人设 / user 提问 / assistant 历史） |

各家平台接口格式高度一致，换平台基本只改前三行。

## 3. API 回包里的 choices、usage、finish_reason 分别是什么？

- `choices[0].message.content`：**菜**——模型说的话，真正要的东西
- `finish_reason`：**小票·停止原因**——"stop"=正常说完；"length"=撞上 max_tokens 被截断（先查参数再怀疑 prompt）
- `usage`：**小票·账单**——prompt_tokens（输入）/ completion_tokens（输出，更贵）/ total_tokens。system prompt 每轮都重新计费，是多轮对话成本滚雪球的根源

## 4. 流式和非流式调用在代码上差在哪一行？

只差一个参数：`stream=True`。

- 非流式：等全部生成完一次性返回完整对象（批处理用，好统计）
- 流式：逐 token 推送，代码里 `for chunk in stream: print(chunk.choices[0].delta.content, end="")`——打字机效果。注意 **chunk ≠ token**（一块可能携带几个 token）

产品对话必开流式（首 token 时间 = 体验生死线）。

---

## 一句话总结（readme 要求）

**五天知识 = 一条流水线：token 进 → 概率表出 → 参数遥控 → 对齐兜底。**
