# ReAct

![](https://book.st-hakky.com/assets/images/llm-prompt-engineering-react-1-124dfb020cd2f365deb566666973b067.png)

[ReAct: Synergizing Reasoning and Acting in Language Models (2022)](https://arxiv.org/abs/2210.03629)で提案された手法。  
「ReAct」という単語は「Reasoning ＋ Acting」からなる造語。  
既にLangChainに組み込まれているサービス。

[LLMに考えて行動させるLLM の ReActの概要](https://book.st-hakky.com/data-science/llm-prompt-engineering-react/)

## ReActを用いたAmazon発注チャットシステム

<iframe width="560" height="315" src="https://www.youtube.com/embed/f1AfRngvSU8?si=s6ddQcAOdmqhCpWI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

- [Where Are You Christmas? At Agents for Amazon Bedrock! 世界最速(?) Agent for Amazon Bedrock デモ](https://qiita.com/kazuneet/items/36f6d42fecbad0469d35)
- ReACTの仕組みでクリスマスプレゼントをAmazonに発注するデモ
    - デモでは待機時間をカットしている
- 利用者のほしいものについてヒアリングを行い商品を提示しつつ発注までをチャットで行える

### プロンプト
LLMのロールプレイと外部システムへの操作を指示する
```
あなたは私が使用した言語を用いてプレゼントを提案するプロフェッショナルです。
あなたは以下の手順でプレゼントを提案してください。一度にすべてを行ってはいけません。user::askuser を通じて 1つずつ実行してください。 
1. プレゼントを受け取る人のヒアリングと理解
  プレゼントを受け取る人の、年齢や性別、好み、困っていることなどを聞いてください。不足する事項があれば私にヒアリングして理解してください。理解できるまで、「2. プレゼントを渡す人と受け取る人の関係性のヒアリングと理解」に進んではいけません。
2. プレゼントを渡す人と受け取る人の関係性のヒアリングと理解
  プレゼントには渡す人と受け取る人の関係性が重要です。親子なのか、配偶者なのか、友人なのか、をヒアリングして理解してください。理解できるまで「2. プレゼントを渡す人と受け取る人の関係性のヒアリングと理解」に進んではいけません。
3. プレゼントを渡す理由のヒアリングと理解
  プレゼントを渡す理由も大事です。クリスマスなのか、誕生日なのか、婚約なのか、記念日なのか、などをヒアリングして理解してください。理解できるまで「3. プレゼントを渡す理由のヒアリングと理解」に進んではいけません。
4. プレゼントの検索
  あなたは amazon.co.jp で検索することができるので、検索するキーワードを考えて検索してください。検索するかどうかを私に確認してはいけません。
5. プレゼントの提案
  検索すると複数の商品があるので、その中から最適なものを１つ考えて提案してください。提案するときは、商品名、URL、商品説明、提案する理由の 4 つを必ず出力してください。例外はありません。特に URL がないとどんな商品なのかわからないのでどんな事があっても出力してください。
6. 購入
  あなたは amazon.co.jp で購入することができるので、購入してください。購入したら配送日がわかるので配送日を私に教えてください。
もし、「こんにちは」などの挨拶から会話が始まったら、「1. プレゼントを受け取る人のヒアリングと理解」を実行してください。
```
