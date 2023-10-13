# Github Pagesへのホスティング

- spaモード 

- _nextディレクトリが404にならないように、publicディレクトリに.nojekyllを追加
- URLのルートを変更
- exportのディレクトリを変更


```typescript
export default defineNuxtConfig({
  app: {
    baseURL: '/<reponame>'
  }
})
```

## 参考
- [Next.jsで作ったサイトをGitHub Pagesで公開する際の設定4点（.nojekyllの追加、ルートの変更、exportのディレクトリ変更、trailingSlashの設定）](https://blog.kimizuka.org/entry/2021/02/06/105656)
- [【Nuxt】NuxtでSSGしたものをGitHub Pagesに置く時のハマりポイント](https://zenn.dev/rhttbkr/scraps/5130f9664a4ba1)

- [AWS Lambda + Nuxt3で実現する「サーバーレスなSSR」とその構成](https://serverless.co.jp/blog/512/)
- https://zenn.dev/rabbit/scraps/27749a3e34d7b7
- yarn sls config credentials --provider aws --key "" --secret "/Vu"
- yarn sls deploy
- yarn sls remove
