# 【SDXL】矢吹風Loraモデル
2024年1月時点で、SDXLが利用可能になって暫く経ち、追加学習モデルがいくつか公開されるようになった。  
先日(24/1/24)、矢吹健太朗先生のSDXL用作風Loraモデルが公開されており、作風モデルについてレポートする題材としていくつか生成してみたいと思う。

## 主な利用モデル
- [Animagine XL V3](https://civitai.com/models/260267)
- [[XL] Yabuki Kentarou/矢吹健太朗 《To LOVE RU》/《To LOVEる -とらぶる-》/《出包王女》 - Artist Style](https://civitai.com/models/275386?modelVersionId=310389)
- [negativeXL](https://civitai.com/models/118418/negativexl)
- [Zundamon XL](https://civitai.com/images/5938238)
    - 作風を引き継いでずんだもんを描くのに利用
- [4x-Ultrasharp](https://civitai.com/models/116225/4x-ultrasharp)
    - .pt から .pth に要変換

## 生成方針
- civitaiのLoraモデルの生成例を参考にパラメータ設定する
    - 各画像ページのCopy Generation Dataからより詳細な設定情報を得ることができる
- 生成結果を見てこのあたり適当に微調整していく
    - Sampling steps : ステップ数
    - CFG Scale : プロントへの忠実度
    - hires. fix
        - Hires steps : 高解像度化する際のステップ数（0の時sampling stepsと同じになる）
        - Denoising strength : ノイズ除去強度
- Hires. fix をかけてFHDにupscaleする
    - ControlNet Tile の正式版モデルは執筆時点ではなさそう。アルファ版や代替は下記のリンク。軽く試した範囲だとまだ微妙なところだったので今後に期待。
    - https://huggingface.co/bdsqlsz/qinglong_controlnet-lllite/tree/main
    - https://huggingface.co/lllyasviel/sd_control_collection/tree/main

## 生成結果
- parameterについてはpngに埋め込んであるので、確認したい場合は画像から抜いてくること（基本的にはLoraのサンプルのコピペ）。

![](./04-benchmark-sdxl-to-love-ru/20240128-035037-845898-2873957537.png)

![](./04-benchmark-sdxl-to-love-ru/20240128-051322-047281-142081694.png)

![](./04-benchmark-sdxl-to-love-ru/20240128-213724-317868-3969892722.png)

![](./04-benchmark-sdxl-to-love-ru/20240128-214749-704665-4070261750.png)

![](./04-benchmark-sdxl-to-love-ru/20240128-054454-168911-2983341794.png)

## 所感
- SD1.5の世代に比べると画風再現度が高くなった印象を受ける。再現生成においてはNovelAIが優秀であるが、SDXLも十分選択肢に入るだろう。
- SD1.5 + 高解像度化 の世代に比べると高解像度前から画像の解像度が高いからか、指などが破綻しにくい傾向がある。SDXLにおけるFHD化の手段がもっと確立していき次第色々とまた試してみたいところ。
    - hires fix
        - 1.5倍以内ぐらいが結果が安定しやすい感触
            -  (960 × 1440) * 1.5 -> 1440 × 2160
- 1440 × 2160 に upscaleしているが、RTX4090のGPUメモリ利用率が23.5/23.6426 GB (99.4%)でかなりギリギリ
    - Xformersが機能していないかも？
- ずんだもんの触角？がよく消えてしまう。