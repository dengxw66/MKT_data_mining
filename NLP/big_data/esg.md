

# ESG 事件检索匹配


重新优化embedding的类型：
1. TXT提取关键句子：过滤了TXT事件文本的几百个文本大段干扰信息，得到了更有代表性的句子集合。
2. 'cl_news_sp500_20240105.csv的['Summary']中的句子'和'tw_after_incident_0_10中的['incident_category']中的单词'进行逐一两两匹配：这样更加细腻度的匹配，得到的similarity权重差异性更大，方差更大，从而明显突出了代表性类别对应的事件。
3. 使用大模型确定匹配程度，要求每个category关键词都能找到对应的依据才算匹配。并且多次使用大模型反复迭代查找，防止偶然性。


过程代码：
1. 完整过程程序见：[`esg.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/NLP/big_data/esg.ipynb)
2. 大模型匹配检测见：[`GLM.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/NLP/big_data/GLM.ipynb)
3. 最终匹配结果见：[`final_match_llm_refine.csv`](https://github.com/dengxw66/MKT_data_mining/tree/master/NLP/big_data/final_match_llm_refine.csv)。一共308条高精度匹配文本（由大模型多次迭代反复确认）。

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

3. 执行上述算法。找到每个['incident_category']最匹配的top5的最终匹配的similarities，保存在文件中。完整过程程序见：[`esg.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/NLP/big_data/esg.ipynb)

## 第三步：大模型逐条匹配

1. 对于上述得到的similarities文件，选取top1的值明显大于top234的数据，一共1870条。2. 使用本地大模型GLM进行提问，逐条判断这些事件文本是否和主题类别匹配，大模型匹配检测见：[`GLM.ipynb`](https://github.com/dengxw66/MKT_data_mining/tree/master/NLP/big_data/GLM.ipynb)。根据匹配程度，由高到低，得分为3分，2分，1分。其中3分代表匹配程度最高。为了保证精度，使用大模型反复迭代检测，保证只有每次检测都被判断相似度为3分，才能保留，最后一共得到308条。
3. 结果见：[`final_match_llm_refine.csv`](https://github.com/dengxw66/MKT_data_mining/tree/master/NLP/big_data/final_match_llm_refine.csv)。其中的ll_analysis列代表大模型的分析，说明是否每个关键词都存在对应的内容印证。可解释性，提高精度。















