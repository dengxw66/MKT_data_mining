
# 准确率计算


## 1. 数据格式

### 1.1. llm
有文件：[`DatafromLLM.xlsx`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/accuracy/DatafromLLM.xlsx)，其中的格式是
UserID	Video	Topic	Description	Time
1	1	Workplace/Interpersonal Relationships	 POV/First Person Narratives;  Workplace/Interpersonal Communication;  Workplace/Interpersonal Dynamics;  Social Media/Viral Videos;  Fashionable Cat;  Office Humor;  Social Media;  Workplace/Interpersonal Conflicts;  Workplace/Interpersonal Conflict Resolution	16
1	1	Education and Campus	 Campus Life	2
1	1	Social and Political News	 Entertainment and Leisure;  Media and Social Media	2

### 1.2 human
有文件：[`DatafromRA.xlsx`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/accuracy/DatafromRA.xlsx)，其中的格式是
UserID	Video	Clip	是否有效曝光	Main Category	Sub Category
1	1	1	是	Leisure and Comedy	Creative Editing/Dubbing
1	1	2	是	Plot Type	Short Skits
1	1	3	是	Appearance	Music
1	1	4	是	Leisure and Comedy	Landscape Photography
1	1	5	是	Life Sharing	Vlog/Insights Sharing

## 2. 匹配规则

目标： 
1. 少于2s的视频，检测每个用户每个视频的个数。
    - 因为human文件中没有类型，所以只能匹配个数。
2. 长期浏览的视频的逐个匹配，检测每个视频的主题是否一致。
    - 因为human文件中没有每段时长，所以只能检测主题类型。

具体匹配步骤：见 [`data.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/accuracy/data.ipynb)




## 3. 结果展示


### 3.1 小于2s的视频


结果见 [`MatchedData_2.csv`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/accuracy/MatchedData_2.csv)

问题：发现llm小于2s的数量太多，



### 3.2 长期浏览的视频


结果见 [`MatchedData_CategorySequences.csv`](https://github.com/dengxw66/MKT_data_mining/tree/master/Multimodal/image2text/accuracy/MatchedData_CategorySequences.csv)

问题：
数目不一致：保证先后顺序即可。
类型不一致：可以用大类来做。



## 4. 下一步计划
















































