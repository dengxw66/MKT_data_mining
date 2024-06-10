
# 多模态识别


# 一、任务目标：

对于社交媒体的人物衣服image和文本帖子text，同时嵌入同一个特征空间。然后训练学习，用于预测未来趋势（二分类）


# 二、解决方案：

- 模型采用MLP神经网络

```
mlp = make_pipeline(StandardScaler(), MLPClassifier(hidden_layer_sizes=(512, 256), max_iter=500, random_state=42))
mlp.fit(X_train, y_train)
```

# 三、实验效果：

1. 去小红书爬取250个左右数据。数据格式如[`data`](https://python.langchain.com/v0.1/docs/modules/data_connection/document_transformers/)







































