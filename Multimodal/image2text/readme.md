
# social media 多模态转化

以tiktok为例子,35个用户，每个用户若干个视频数据实验。

目标：分割输入的视频，统计长视频和短视频。并且统计对应的主题识别。


## 结果展示

0）主题label分类标准如下：

<p align="center">
    <img src="category.png" width="300"/>
    <br>
    <strong>分类标准 main category和sub category</strong>
</p>

1）按照每个视频的自然播放顺序排列：35个用户的主题原始数据见[`all_statistic.csv`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/output/all_statistic.csv)。维度是：user,video,time,Topic,description

<p align="center">
    <img src="raw_data.png" width="900"/>
    <br>
    <strong>视频根据内容播放的先后顺序自然排列，time表示内容停留时长</strong>
</p>

2）统计每个用户的视频停留时长和主题分布：定量统计指标见[`user_time_topic_distribution.csv`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/output/user_time_topic_distribution.csv) 。维度是：User,Time,Topic,Count

<p align="center">
    <img src="user_time_topic_distribution.png" width="600"/>
    <br>
    <strong>根据停留时间time长短排序，找到用户最感兴趣的主题</strong>
</p>


3）可视化展示：
同一类主题用类似的颜色表示。

1. 35个用户的所有时间time，主题topic，计数count统计分布图，见文件夹：[`fig_alltime`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/output/fig_alltime) 

<p align="center">
    <img src="all_fig.png" width="600"/>
    <br>
    <strong>举例：某用户+27 726288507的所有视频全时段主题分布图</strong>
</p>

2. 因为用户停留的时间越多，说明这个topic越重要。为了更好的展示，我们统计了35个用户的大于20s的时间time，主题topic，计数count分布图。见文件夹：[`fig_over20`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/output/fig_over20) 

<p align="center">
    <img src="over_20.png" width="600"/>
    <br>
    <strong>举例：某用户+27 726288507的所有视频中长时间停留的主题分布图</strong>
</p>


## 技术路线

### 识别不同视频片段：
1）所有视频每隔2s裁剪为图片（例子见：[`input`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/input)）。同时因tiktok的每一帧图片布局相对固定，使用裁剪功能，得到title数据，画面数据，点赞量等数据截图。（例子：[`data_seg.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/data_seg.ipynb)）


<p align="center">
    <img src="shot.png" width="600"/>
    <br>
    <strong>输入视频的截图</strong>
</p>


2）使用多模态大模型[`qwen-VL`](https://github.com/QwenLM/Qwen-VL)，对于每一帧图片进行caption提问（[`qwen.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/qwen.ipynb)），加入history日志功能，因此如果图片前后类似的话，容易得到非常类似几乎一致的描述。（分割结果：[`responses_caption.json`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/responses_caption.json)）

3）使用word2vec工具将文本转化为向量，度量前后文本向量相似度，就可以得到合适合适的分组（见[`data_cluster.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/data_cluster.ipynb)）。


### 多模态合并：
1）得到视频帧间的分组后，使用不同的模型将多模态数据统一转化为文本。（这里只做了[`qwen-VL`](https://github.com/QwenLM/Qwen-VL)转化图片和文本两个模态）

2）然后使用LLM合并文本（见[`GLM_RAG_summary.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/GLM_RAG_summary.ipynb)）合并同一组的多模态数据的内容。（分组结果见[`merged_captions.json`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/merged_captions.json)）。

3）再次使用LLM提炼主题（见[`GLM_RAG_topic.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/GLM_RAG_topic.ipynb)）进一步总结分析主题分类等。（见[`summary_topic.json`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/summary_topic.json)）

<p align="center">
    <img src="comments.png" width="600"/>
    <br>
    <strong>最终输出包括：内容，评论，主题分析</strong>
</p>

