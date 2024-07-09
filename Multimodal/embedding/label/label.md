

# 聚类获得标签

## 聚类方法分析
使用Kmeans聚类，指定聚类的数量。得到各个类别。
- 替代方案为使用DBSCAN或OPTICS聚类，不指定具体聚类数量，指定类间距离阈值后，自适应分类出合理的数量。但是OPTICS方法经过实验聚类结果不大稳定，不如kmeans好。DBSCAN方法会有大量的噪声点直接舍弃，如果减少舍弃的点，最总的聚类效果会不理想。
- kmeans聚类的方法，超参数类别数量除了人工定义，还可以通过肘部法(Elbow Method)或轮廓系数法(Silhouette Method)，迭代出来最佳数量。某种意义上克服了人为预定超参数的问题。缺点是聚类时间长，因为这是一个迭代的方法，需要多次聚类确定最佳参数。

## image聚类

过程：
1. 图片预处理清洗：首先使用[`segment`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/segment/SemanticGuidedHumanMatting)分割的效果好于直接分类。
2. 经过实验，使用[`imagebind`](https://arxiv.org/abs/2305.05665)做encoder好于使用[`resnet`](https://github.com/KaimingHe/deep-residual-networks)。因此使用imagebind做embedding。
3. 使用Kmeans聚类，聚类的数量为200个。得到各个类别。见文件：[`output_img`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/embedding/label/output_img),聚类结果举例见下图。[`labels.json`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/embedding/label/output_img/labels.json)是具体全部类别结果。


<p align="center">
    <img src="img_cluster.png" width="400"/>
    <br>
    <strong>图片聚类结果举例</strong>
</p>

## text聚类


过程：
1. 使用特定词汇过滤出主题词。定义关键词列表
```
key_words = [
    "裙", "裙子", "项链", "配饰", "裤", "吊带", "风格", "饰品", "单品", "衬衫", "身材", "耳环", "主义", "混搭", 
    "手链", "元素", "绒", "肩", "鞋子", "瘦", "套装", "款", "毛", "吊坠", "造型", "型", "饰", "袜", 
    "马甲", "系", "夹克", "裳", "推荐", "服", "衣服", "靴", "款", "白t", "搭配", "恤", "大衣", "头", "风", 
    "毛衣", "服", "内搭", "靴子", "链", "套装", "头发", "背心", "毛衣", "外套", "帽", "发型", "包", "衣", 
    "戒指", "鞋", "衫", "袍", "手镯", "单品", "装", "镜", "帽子", "袖"
]
```
2. 读取['post_content', 'post_tag', 'post_comments']列中，以上述单词结尾的字符，每次截取前4个字符。得到相关风格词语表[`tags.txt`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/embedding/label/output_text/tags.txt)。
3. 统计出现各个风格的频率，得到频率表[`word_frequencies.txt`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/embedding/label/output_text/word_frequencies.txt)。
4. 使用paraphrase-multilingual-MiniLM-L12-v2得到embedding。使用Kmeans聚类，考虑各个分格出现频率为权重，进行有权重的聚类，聚类的数量人工定义为50个。结果见[`text_clusters.json`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/embedding/label/output_text/text_clusters.json)。得到各个关键词对应的类别，并重新分配回文件[`matched_categories_with_clusters.csv`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/embedding/label/output_text/matched_categories_with_clusters.csv)。
```
poster_id,post_id,nums_category_img,categories,num_category_text
574054be50c4b4473f712868,6625cd6e000000001c00a4d0,70,"谁还对脱毛, 私处脱毛",3
5bffd88e0000000008006d81,6598129100000000130379bb,34,"秋冬厚外套,  皮毛, 皮毛","10, 3"
62c72724000000000e00c085,65ae59f9000000000a0321b1,134,,
5afec6c94eacab2b432f52be,66041791000000001203d1d7,57," 小个子鞋, 小个子鞋子, 小个子鞋,  鞋子推荐,  小个子鞋子, 鞋子推荐",8
5f11b503000000000101ff53,65377f79000000002201e3d6,25,,
62c100820000000015015acf,6637276f000000001e022ca4,178,"瘦泳衣大推荐, 海岛度假风, 四件套的款, 显瘦, 显瘦泳衣, 件套的泳衣","0, 2, 16, 12"
58a03ed182ec397e60564cca,65a63a81000000002b00a2ce,158,,
5ace124a4eacab4cd94b6bc8,65ced82c000000000b00fb07,32,"美美的小裙,  老公镜头, 老公镜头, 老公镜, 美美的小裙子,  老公镜","9, 14, 12"
59124ed350c4b429bae8bee6,665c16fb000000001401a06c,29,"运动套装,  显瘦,  梨形身材, 显瘦,  运动套装, 梨形身材","4, 13, 2"
59124ed350c4b429bae8bee6,665c16fb000000001401a06c,29,"运动套装,  显瘦,  梨形身材, 显瘦,  运动套装, 梨形身材","4, 13, 2"
55ff8fd941a2b36aafc0d89d,660bbc43000000001a010158,157," 公主头, 公主头, 甜妹发型","3, 1"
```
- 问题：注意text聚类和图片不同，每个帖子得到的类型不唯一，可能同时存在多个风格。而有的帖子没有匹配的文本，所以无法聚类



## 最终结果

1. 首先使用image聚类，得到每个帖子的图片对应类别，见文件：[`labels.json`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/embedding/label/output_img/labels.json)
2. 再使用text聚类，得到每个帖子的文本对应类别，见文件：[`matched_categories_with_clusters.csv`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/embedding/label/output_text/matched_categories_with_clusters.csv)
3. 图片和文本交叉索引序号。图片为一级标签，文本为二级标签。找到每个图片聚类中，占比最高的文本。见文件：[`combined_clustered_matched_image_text.csv`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/embedding/label/output_all/combined_clustered_matched_image_text.csv)
4. 统计指标见[`category_ratios.csv`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/embedding/label/output_all/category_ratios.csv)，其中的ratio为比例/百分比。可以看到下图中category_img为70的类别中，category_text为3，4，7，17的占比最大
```
nums_category_img,num_category_text,ratio
70,3,0.13953488372093023
70,9,0.05813953488372093
70,12,0.2441860465116279
70,4,0.10465116279069768
70,7,0.19767441860465115
70,17,0.09302325581395349
70,1,0.046511627906976744
70,6,0.08139534883720931
70,14,0.023255813953488372
70,15,0.011627906976744186
34,10,0.1111111111111111
34,3,0.044444444444444446
34,4,0.1111111111111111
34,0,0.044444444444444446
34,17,0.044444444444444446
34,12,0.13333333333333333
34,8,0.044444444444444446
34,9,0.044444444444444446
34,6,0.08888888888888889
34,7,0.044444444444444446
34,1,0.06666666666666667
34,13,0.06666666666666667
34,2,0.1111111111111111
```

- 可视化结果，横坐标是图片类别一共200类。纵坐标(颜色方块)是文本类别一共20类。我们选取每个图片类别中的top3文本类别展示。详细结果见[`top3_categories.csv`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/embedding/label/output_all/top3_categories.csv)
<p align="center">
    <img src="./output_all/top3_categories_chart_part1.png" width="1000"/>
    <br>
    <strong>最终image-text聚类比例：0-66图片类</strong>
</p>

<p align="center">
    <img src="./output_all/top3_categories_chart_part2.png" width="1000"/>
    <br>
    <strong>最终image-text聚类比例：67-132图片类</strong>
</p>

<p align="center">
    <img src="./output_all/top3_categories_chart_part3.png" width="1000"/>
    <br>
    <strong>最终image-text聚类比例：133-199图片类</strong>
</p>















































