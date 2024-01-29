# 【SDXL】モデル試用
2023年7月26日にStable Diffusion XLがリリース。
解像度の追加やRefinerのパスの追加が主な変更点。  
2023年10月時点で派生モデルが充実し始めてきたため動作検証を行う。  

## 特性
- 1024 × 1024 での学習であるため、生成サイズもこれに合わせるべき
- Refinerが追加されている
- SD1.5向けのVAEやEmbeddingsやLoRAは正しく機能しない
    - 2023/10時点だと追加学習は途上にあるため、SD1.5ベースモデルも十分利用可能

## webuiでの導入
- webuiのバージョンを1.5以上にする
    - 更新する場合は、更新後に動かなくなるリスクがあるので、バックアップ作成したりプログラム実行時に表示されるhashを控えておき、衝突を対応しつつ git pull
- SDXL系のモデル等を追加して、WEBUI上で読み込む
    - [SD-XL 1.0](https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0)
    - [CounterfeitXL](https://civitai.com/models/118406/counterfeitxl)
    - [negativeXL](https://civitai.com/models/118418/negativexl)

## 生成例

### 結果1
![](02-benchmark-sdxl/20231006-122647-866191-4205748474.png)
```
1girl
Negative prompt: negativeXL
Steps: 20, Sampler: DPM++ 2S a Karras, CFG scale: 7, Seed: 4205748474, Size: 768x1024, Model hash: 9a0157cad2, Model: counterfeitxl_v10, VAE hash: 551eac7037, VAE: sdxl_vae.safetensors, Clip skip: 2, Version: v1.6.0
```
