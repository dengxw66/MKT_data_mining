
# 准确率计算

结论：
1. 曝光不足的视频(<2s的视频) 总平均准确率是0.4321，大致43%
2. 曝光充足的视频(>2s的视频) 总平均准确率是 0.1999，大致20%


# 1. 数据格式

<p align="center">
    <img src="category.png" width="600"/>
    <br>
    <strong>分类标准 main category和sub category</strong>
</p>

## 1.1. llm
有文件：[`DatafromLLM.xlsx`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/accuracy/DatafromLLM.xlsx)，其中的格式是


<p align="center">
    <img src="LLM.png" width="600"/>
    <br>
    <strong>LLM格式：UserID,	Video,	Topic,	Description,	Time
    </strong>
</p>

## 1.2 human
有文件：[`DatafromRA.xlsx`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/accuracy/DatafromRA.xlsx)，其中的格式是
 
<p align="center">
    <img src="RA.png" width="600"/>
    <br>
    <strong>human格式：UserID,	Video,	Clip,	是否有效曝光	, Main Category,	Sub Category
    </strong>
</p>


# 2. 匹配规则


1. 曝光不足的视频(<2s的视频)：
    - 方法：检测每个用户此类视频的个数。
    - 备注：因为human文件中"是否有效曝光"没有具体主题，所以只能匹配个数。
2. 曝光充足的视频(>2s的视频)：
    - 方法：按次序逐个匹配，检测每个视频的主题是否一致。
    - 备注：因为human文件中没有每段视频时长，所以只能匹配主题次序和类型。

具体匹配步骤：见 [`data.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/accuracy/data.ipynb)




# 3. 结果展示


## 3.1 曝光不足的视频(<2s的视频)

### 1.1 文件：
每一项具体结果见 [`MatchedData_2.csv`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/accuracy/MatchedData_2.csv)，
匹配统计结果见：[`accuracy_results_2.txt`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/accuracy/accuracy_results_2.txt)


### 3.2.2 结果：
准确率 Average Match Rate for Each UserID:

| UserID | 1     | 3     | 4     | 6     | 8     | 9     | 10    | 11    | 13    | 14    | 15    | 16    | 17    | 18    |
|--------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|
| Rate   | 0.227 | 0.452 | 0.267 | 0.520 | 0.544 | 0.336 | 0.577 | 0.385 | 0.452 | 0.535 | 0.311 | 0.504 | 0.371 | 0.572 |

| UserID | 20    | 21    | 23    | 24    | 25    | 26    | 28    | 29    | 31    | 33    | 34    | 35    | 36    | 37    |
|--------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|
| Rate   | 0.555 | 0.338 | 0.746 | 0.505 | 0.588 | 0.389 | 0.233 | 0.417 | 0.502 | 0.324 | 0.393 | 0.561 | 0.303 | 0.175 |

- (计算公式：每个video的准确率平均值，即 (准确率1+准确率2+准确率3+...准确率n)/n): 
- 总准确率是：0.4321


### 3.1.3 问题：
1. 发现llm小于2s的数量太多：
    - 原因：有些视帧间变化过大(甚至有黑屏)，模型无法有效识别为同一类。
    - 后续解决方法：加大history的阈值，之前是读取前1次的chat为histroy，后续应该要提高阈值，读取前3次的chat为history。保证前3帧中只要出现了相似内容，也可以尽量分为同一类，减少clip片段



## 3.2 曝光充足的视频(>2s的视频)

### 3.2.1 文件：
每一项具体结果见 [`MatchedData_CategorySequences.csv`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/accuracy/MatchedData_CategorySequences.csv)，
匹配统计结果见：[`accuracy_results.txt`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/accuracy/accuracy_results.txt)


### 3.2.2 结果：
Average Match Rate for Each UserID:

| UserID | 1     | 3     | 4     | 6     | 8     | 9     | 10    | 11    | 13    | 14    | 15    | 16    | 17    | 18    |
|--------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|
| Rate   | 0.127 | 0.298 | 0.272 | 0.113 | 0.049 | 0.159 | 0.210 | 0.131 | 0.128 | 0.180 | 0.243 | 0.099 | 0.473 | 0.151 |

| UserID | 20    | 21    | 23    | 24    | 25    | 26    | 28    | 29    | 31    | 33    | 34    | 35    | 36    | 37    |
|--------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|
| Rate   | 0.292 | 0.160 | 0.151 | 0.114 | 0.181 | 0.205 | 0.234 | 0.148 | 0.293 | 0.058 | 0.246 | 0.124 | 0.439 | 0.173 |
- (计算公式：每个video的准确率平均值，即 (准确率1+准确率2+准确率3+...准确率n)/n): 
- 总准确率是：0.19996


### 3.2.3 问题：
1. llm和human得到的clip数目不一致：
    - 原因：因为有些错误分割的情况，导致同一个视频片段可能被分为了多个clip和topic
    - 处理方法：保证先后顺序即可。即 只计算 符合先后出现顺序的clip，中间如果有杂项输入则忽略。具体计算规则见4.附录。
2. 同一个视频的分类topic不一致：
    - 原因：llm的输出主题一般有多个，而human只统计了一个主题。因此先前步骤，在topic计算的时候llm的多个topic输出，通过word-embedding向量相似度，选取了最具有代表性topic的作为这个片段的topic。(值得一提的是，实际上一个视频可以归于多个主题，感觉是make sense的)
    - 处理方法：大类匹配，不考虑sub category，如果属于同一个大类就算匹配。



# 4. 附录(具体顺序匹配规则)

具体顺序匹配规则是，只统计符合先后顺序的项，中间有其他杂项插入则忽略。

- 例，比如有:
    - m=[a,b,c,d,e,f,g,h,k],
    - n=[a,c,b,c,f,d,e,f,h,g,h,a,k],
    - q=[a,c,b,c ,f,h,g,h,a,k]
1. m和n匹配的数量为9，因为n可以分为：a,(c),b,c,(f),d,e,f,(h),g,h,(a),k。去掉不匹配的c,f,h,a，其余的a,b,c,d,e,f,g,h,k和m中的a,b,c,d,e,f,g,h,k次序一致。
2. m和q匹配的数量为7，因为q可以分为a,(c),b,c, f,(h),g,h,(a),k。其中a,b,c,f,g,h,k是按照m的顺序出现的（尽管中间有中断d和e，但是没有关系，其余是按照顺序出现即可）