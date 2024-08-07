

# word embedding



## 1. 降维方法

贸然降维比如(PCA或t-SNE)一定会损失语义信息。最理想的降维方法是使用mlp或Autoencoders，重新微调训练，压缩维度。但是没有训练数据，所以无法实现。
- 因此，最稳妥的方法是直接找到维度小的embedding模型使用。




##  2. embedding模型

经过查找，下面的embedding模型满足要求：

| 名称               | 链接                                                                                  | 维度           | 优点                 | 缺点             |
|--------------------|---------------------------------------------------------------------------------------|----------------|----------------------|------------------|
| GloVe Twitter      | [Kaggle - GloVe Twitter](https://www.kaggle.com/datasets/robertyoung/glove-twitter-pickles-27b-25d-50d-100d-200d) | 25, 50, 100, 200 | 维度最小25           | 无中文版本     |
| NNLM (Chinese)     | [Kaggle - NNLM](https://www.kaggle.com/models/google/nnlm)                             | 50, 128         | 有中文版本           | 效果相对较差     |
| ColBERTv2.0        | [Hugging Face - ColBERTv2.0](https://huggingface.co/colbert-ir/colbertv2.0)            | 128            | 理论上效果最好             | 无中文版本       |

- 结论：建议使用NNLM (Chinese)，应该对这个任务够用了。





























