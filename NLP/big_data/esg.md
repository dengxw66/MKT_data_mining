

# ESG 事件检索匹配


重新优化embedding的类型：
1. TXT提取关键句子：过滤了TXT事件文本的几百个文本大段干扰信息，得到了更有代表性的句子集合。
2. 'cl_news_sp500_20240105.csv的['Summary']中的句子'和'tw_after_incident_0_10中的['incident_category']中的单词'进行逐一两两匹配：这样更加细腻度的匹配，得到的similarity权重差异性更大，方差更大，从而明显突出了代表性类别对应的事件。


完整过程程序见：[`esg.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/NLP/big_data/esg.ipynb)

## 第一步：TXT文本提取

1. 首先数据清洗cl_news_sp500_20240105.csv中['HD']，使用stopwords_en.txt过滤语气词
2. 使用目前最优的summa.summarizer库进行文本摘要，将['TXT']的几百个字，提炼出最具有代表性的几句话。并和['HD']合并。一起作为['Summary']，表示最代表这个事件的核心句子集合。


## 第二步：细腻度两两匹配

1. 以tw_after_incident_0_10中的所有事件为目标。匹配cl_news_sp500_20240105.csv匹配['company_ticker', 'incident_date']，找到符合每个公司和日期的子类
- 首先找到相同的公司ticker代码，初步过滤。
- 然后匹配日期，选择在tw_after_incident_0_10的incident_date发生后15天以内为界限，进一步过滤数据。

2. 对于过滤后得到的各个子类的进行匹配：'cl_news_sp500_20240105.csv的['Summary']中的句子'和'tw_after_incident_0_10中的['incident_category']中的单词'进行逐一两两匹配。
- 首先['Summary']中的每句话都和incident_category所有单词匹配一遍，得到该句子和各个categories单词的similarity，从而排序找到该句子最匹配top1的类别category，并将这个category对应值作为代表这句话的similarity。
- 然后计算['Summary']中所有句子的总和similarity，作为最终匹配的similarities。

3. 执行上述算法。找到每个['incident_category']最匹配的top5的最终匹配的similarities，保存在文件中。


## 存在问题: 
1. 经过实验，google和llm检索不准确，ravenpack数据实在太大，检索太慢，暂时放弃。目前仍然是使用cl_news_sp500_20240105.csv和tw_after_incident_0_10进行匹配。此外，细腻度的两两匹配算法非常慢，运行一次需要一整天。
2. 得到的最终结果tw_after_incident_0_10_origin_highest_with_matches_update-all3.xlsx，有很多无法匹配的空缺项。考虑扩大日期范围进行匹配，同时使用完整tw_after_incident_0_10进行检索（之前只选取了每5个中的top1，所以可能存在遗漏），下一步得到完整结果。













