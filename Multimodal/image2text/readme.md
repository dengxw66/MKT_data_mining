

# 识别不同视频片段：
1）视频每隔3s裁剪为图片。2min47s的视频-->56张图片（见：[`input`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/input)）。同时因tiktok的每一帧图片布局相对固定，使用裁剪功能，得到title数据，画面数据，点赞量等数据截图。（见：[`data_seg.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/data_seg.ipynb)）

2）使用多模态大模型[`qwen-VL`](https://github.com/QwenLM/Qwen-VL)，对于每一帧图片进行caption提问（[`qwen.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/qwen.ipynb)），加入history日志功能，因此如果图片前后类似的话，容易得到非常类似几乎一致的描述。（分割结果：[`responses_caption.json`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/responses_caption.json)）

3）使用word2vec工具将文本转化为向量，度量前后文本向量相似度，就可以得到合适合适的分组（见[`data_cluster.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/data_cluster.ipynb)）。


# 多模态合并：
1）得到视频帧间的分组后，使用不同的模型将多模态数据统一转化为文本。（这里只做了[`qwen-VL`](https://github.com/QwenLM/Qwen-VL)转化图片和文本两个模态）

2）然后使用LLM+langchain（见[`GLM_RAG_summary.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/GLM_RAG_summary.ipynb)）合并同一组的多模态数据的内容。（分组结果见[`merged_captions.json`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/merged_captions.json)）。

3）再次使用LLM+langchain（见[`GLM_RAG_topic.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/GLM_RAG_topic.ipynb)）进一步总结分析主题分类等。（见[`summary_topic.json`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/summary_topic.json)）

