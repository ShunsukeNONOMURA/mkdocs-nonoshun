# 初音ミクAIコスプレイヤ
イラスト系LoRAと実写系モデルを組み合わせることでAIコスプレイヤーを生成することができる。  
ここでは「初音ミク」を生成対象とし、要素を変えながらいくつか画像生成を行った結果を掲載する。  
なお、単にコスプレさせるのも面白くないので、前回作成したおっさんと組み合わせて、おっさんコスプレイヤを生成することにする。  

## 利用するもの一覧
- 描画対象
    - hatsunemiku
    - middle aged man
- モデル, VAE
    - chilled_remix_v1vae.safetensors
    - vae-ft-mse-840000-ema-pruned
- 追加学習（Textual Inversion）
    - EasyNegative
    - bad-hands-5
- 追加学習（LoRA）
    - hatsunemiku1

## 生成例

### 結果1
![](20231010-123806-363035-3593958495.png)

<!-- ![](20231010-123709-687031-3593958495.png) -->

```
japanese, (middle aged man:1.7), smirk, half open eyes, fat, (ugly:1.2), single, belly is hanging out, <lora:hatsunemiku1:1> (hatsunemiku:1.5)
Negative prompt: EasyNegative, bad-hands-5, woman, girl, suit
Steps: 30, Sampler: DPM++ 2M Karras, CFG scale: 7, Seed: 3593958495, Size: 512x768, Model hash: df5522b823, Model: chilled_remix_v1vae, VAE hash: 551eac7037, VAE: vae-ft-mse-840000-ema-pruned.ckpt, Denoising strength: 0.7, Clip skip: 2, ControlNet: "preprocessor: tile_resample, model: control_v11f1e_sd15_tile [a371b31b], weight: 1, starting/ending: (0, 1), resize mode: Crop and Resize, pixel perfect: False, control mode: Balanced, preprocessor params: (512, 1, 64)", Hires upscale: 2, Hires upscaler: R-ESRGAN 4x+, Lora hashes: "hatsunemiku1: 8ccb2b9adc0a", Version: v1.6.0
```

### 結果2
![](20231010-122702-291365-2161719691.png)

<!-- ![](20231010-122548-448958-2161719691.png) -->
```
japanese, (middle aged man:1.5), smirk, half open eyes, fat, (ugly:1.2), single, belly is hanging out, <lora:hatsunemiku1:1> (hatsunemiku:1.5)
Negative prompt: EasyNegative, bad-hands-5, woman, girl, suit
Steps: 30, Sampler: DPM++ 2M Karras, CFG scale: 7, Seed: 2161719691, Size: 512x768, Model hash: df5522b823, Model: chilled_remix_v1vae, VAE hash: 551eac7037, VAE: vae-ft-mse-840000-ema-pruned.ckpt, Denoising strength: 0.7, Clip skip: 2, ControlNet: "preprocessor: tile_resample, model: control_v11f1e_sd15_tile [a371b31b], weight: 1, starting/ending: (0, 1), resize mode: Crop and Resize, pixel perfect: False, control mode: Balanced, preprocessor params: (512, 1, 64)", Hires upscale: 2, Hires upscaler: R-ESRGAN 4x+, Lora hashes: "hatsunemiku1: 8ccb2b9adc0a", Version: v1.6.0
```

### 結果2
![](20231010-125947-326492-2349600192.png)

```
japanese, (middle aged man:1.7), smirk, half open eyes, (fat:1.5), (ugly:1.4), single, belly is hanging out, <lora:hatsunemiku1-000006:1> (hatsunemiku:1.5), (arms up behind:1.3)
Negative prompt: EasyNegative, bad-hands-5, woman, girl, suit
Steps: 30, Sampler: DPM++ 2M Karras, CFG scale: 7, Seed: 2349600192, Size: 512x768, Model hash: df5522b823, Model: chilled_remix_v1vae, VAE hash: 551eac7037, VAE: vae-ft-mse-840000-ema-pruned.ckpt, Denoising strength: 0.7, Clip skip: 2, ControlNet: "preprocessor: tile_resample, model: control_v11f1e_sd15_tile [a371b31b], weight: 1, starting/ending: (0, 1), resize mode: Crop and Resize, pixel perfect: False, control mode: Balanced, preprocessor params: (512, 1, 64)", Hires upscale: 2, Hires upscaler: R-ESRGAN 4x+, Lora hashes: "hatsunemiku1-000006: 8ccb2b9adc0a", Version: v1.6.0
```