#!/bin/sh

BASE_DIR=docs

write_md () {
  FILE=$1
  TITLE=$2
  PURPOSE=$3
  SCOPE=$4

  mkdir -p "$(dirname "$FILE")"
  cat <<EOF > "$FILE"
# $TITLE

## 目的
$PURPOSE

## ここに書くこと
$SCOPE

## TBD
TBD

EOF
}

################################
# root
################################
write_md "$BASE_DIR/index.md" \
"ドキュメント一覧" \
"本プロジェクトのドキュメントの入口です" \
"開発ガイド 要求仕様 運用操作 リファレンスへの導線をまとめます"

################################
# dev-guide
################################
write_md "$BASE_DIR/dev-guide/index.md" \
"開発ガイド" \
"開発に関わるエンジニア向けのガイドです" \
"開発環境 構成方針 実装ルール 設計判断 開発者が触る運用知識をまとめます"

write_md "$BASE_DIR/dev-guide/overview/architecture.md" \
"アーキテクチャ概要" \
"システムの全体像を共有するための資料です" \
"構成要素の関係 データの流れ 責務分割 設計の意図を記載します"

write_md "$BASE_DIR/dev-guide/overview/glossary.md" \
"用語集" \
"プロジェクト固有の用語を統一するための資料です" \
"略語 名称 定義 使い分けを記載します"

write_md "$BASE_DIR/dev-guide/setup/prerequisites.md" \
"前提条件" \
"開発開始に必要な前提を揃えるための資料です" \
"OS ツール 言語 バージョン 権限 事前準備を記載します"

write_md "$BASE_DIR/dev-guide/setup/local-dev.md" \
"ローカル開発環境" \
"ローカルで動作確認できる状態を作るための資料です" \
"セットアップ手順 起動方法 動作確認方法 よくある失敗を記載します"

write_md "$BASE_DIR/dev-guide/setup/env-vars.md" \
"環境変数" \
"環境変数の役割を共有するための資料です" \
"環境変数名 意味 必須かどうか 既定値の考え方を記載します"

write_md "$BASE_DIR/dev-guide/coding/directory-structure.md" \
"ディレクトリ構成" \
"ソース構造の意図を共有するための資料です" \
"各ディレクトリの責務 依存方向 追加時のルールを記載します"

write_md "$BASE_DIR/dev-guide/coding/style.md" \
"コーディング規約" \
"実装のばらつきを抑えるための資料です" \
"命名 例外 ログ 型 コメント フォーマット 主要なルールを記載します"

write_md "$BASE_DIR/dev-guide/coding/testing.md" \
"テスト方針" \
"テストの狙いと範囲を揃えるための資料です" \
"ユニット 結合 E2E の対象 基準 書き方 実行方法を記載します"

write_md "$BASE_DIR/dev-guide/api/overview.md" \
"API 設計方針" \
"API の設計思想を共有するための資料です" \
"責務分割 リソース設計 方針 命名 認可 互換性を記載します"

write_md "$BASE_DIR/dev-guide/api/openapi.md" \
"OpenAPI 運用" \
"OpenAPI 定義の管理方法を統一するための資料です" \
"生成 更新 レビュー 公開 バージョニングのルールを記載します"

write_md "$BASE_DIR/dev-guide/api/error-handling.md" \
"エラーハンドリング" \
"エラー設計を統一するための資料です" \
"ステータスコード エラー形式 エラーコード リトライ方針を記載します"

write_md "$BASE_DIR/dev-guide/db/schema.md" \
"スキーマ設計" \
"データ設計の方針を共有するための資料です" \
"命名 主キー 外部キー 制約 インデックス 変更方針を記載します"

write_md "$BASE_DIR/dev-guide/db/migration.md" \
"マイグレーション運用" \
"スキーマ変更の運用を安定させるための資料です" \
"追加 変更 削除の手順 ロールバック 互換性 デプロイ順序を記載します"

write_md "$BASE_DIR/dev-guide/ops-for-dev/build.md" \
"ビルド" \
"ビルド方法を共有するための資料です" \
"ローカルビルド CI ビルド 成果物の扱い 失敗時の確認を記載します"

write_md "$BASE_DIR/dev-guide/ops-for-dev/ci-cd.md" \
"CI CD" \
"CI CD の構成と意図を共有するための資料です" \
"パイプラインの流れ 主要ジョブ 環境 失敗時対応を記載します"

write_md "$BASE_DIR/dev-guide/ops-for-dev/release.md" \
"リリース" \
"リリースの進め方を共有するための資料です" \
"リリース前確認 リリース手順の概要 ロールバック方針を記載します"

write_md "$BASE_DIR/dev-guide/ops-for-dev/observability.md" \
"可観測性" \
"ログやメトリクスの見方を共有するための資料です" \
"ログ方針 主要メトリクス ダッシュボード アラートの考え方を記載します"

write_md "$BASE_DIR/dev-guide/decisions/adr-template.md" \
"ADR テンプレート" \
"設計判断を記録するためのテンプレートです" \
"背景 判断 選択肢 影響 代替案を記載するための枠を提供します"

write_md "$BASE_DIR/dev-guide/security/auth.md" \
"認証 認可" \
"認証 認可の設計を共有するための資料です" \
"方式 トークン 権限モデル エンドポイントの保護方針を記載します"

write_md "$BASE_DIR/dev-guide/security/secrets.md" \
"シークレット管理" \
"秘密情報の扱いを統一するための資料です" \
"保管方法 配布方法 ローテーション 禁止事項を記載します"

write_md "$BASE_DIR/dev-guide/performance/bottlenecks.md" \
"ボトルネック" \
"性能上の注意点を蓄積するための資料です" \
"既知の課題 兆候 回避策 計測方法を記載します"

write_md "$BASE_DIR/dev-guide/performance/load-test.md" \
"負荷試験" \
"負荷試験の進め方を揃えるための資料です" \
"シナリオ 作り方 実行方法 指標 合否基準を記載します"

################################
# requirements
################################
write_md "$BASE_DIR/requirements/index.md" \
"要求仕様" \
"要求仕様の全体像をまとめる入口です" \
"スコープ ペルソナ 機能要件 非機能要件 インターフェース 受入条件への導線をまとめます"

write_md "$BASE_DIR/requirements/scope/goals.md" \
"目的" \
"システムが達成する目的を定義する資料です" \
"背景 目的 成果 指標を記載します"

write_md "$BASE_DIR/requirements/scope/non-goals.md" \
"対象外" \
"扱わない範囲を明確にする資料です" \
"対象外とする理由 境界 将来検討を記載します"

write_md "$BASE_DIR/requirements/scope/assumptions.md" \
"前提条件" \
"要求仕様の前提を共有する資料です" \
"運用 組織 依存システム データ前提を記載します"

write_md "$BASE_DIR/requirements/scope/constraints.md" \
"制約条件" \
"制約を明確にする資料です" \
"技術 制度 期限 予算 セキュリティ等の制約を記載します"

write_md "$BASE_DIR/requirements/personas/users.md" \
"利用者" \
"利用者像を定義する資料です" \
"利用者種別 利用目的 主要行動 想定頻度を記載します"

write_md "$BASE_DIR/requirements/personas/roles-permissions.md" \
"ロール 権限" \
"権限制御の要求を定義する資料です" \
"ロール定義 できること できないこと 権限付与の流れを記載します"

write_md "$BASE_DIR/requirements/functional/use-cases/uc-001.md" \
"ユースケース 001" \
"ユースケースを一件単位で定義する資料です" \
"前提 主フロー 代替フロー 例外 結果を記載します"

write_md "$BASE_DIR/requirements/functional/features/feature-001.md" \
"機能 001" \
"機能単位の要求を定義する資料です" \
"機能概要 入力 出力 例外 制約 画面や API との関係を記載します"

write_md "$BASE_DIR/requirements/non-functional/performance.md" \
"パフォーマンス要件" \
"性能に関する要求を定義する資料です" \
"応答時間 同時実行 量 スループット 計測条件を記載します"

write_md "$BASE_DIR/requirements/non-functional/security.md" \
"セキュリティ要件" \
"セキュリティに関する要求を定義する資料です" \
"認証 認可 監査 ログ データ保護 脅威を記載します"

write_md "$BASE_DIR/requirements/non-functional/availability.md" \
"可用性要件" \
"可用性に関する要求を定義する資料です" \
"稼働率 目標 復旧目標 保守時間 許容停止を記載します"

write_md "$BASE_DIR/requirements/interfaces/api.md" \
"API 要求仕様" \
"API に求める仕様を定義する資料です" \
"エンドポイント 概要 入出力 要求レベルの制約を記載します"

write_md "$BASE_DIR/requirements/interfaces/ui.md" \
"UI 要求仕様" \
"UI に求める仕様を定義する資料です" \
"画面一覧 主要操作 権限制御 表示要件を記載します"

write_md "$BASE_DIR/requirements/interfaces/integrations.md" \
"外部連携" \
"外部システム連携の要求を定義する資料です" \
"連携先 データ形式 タイミング 障害時扱いを記載します"

write_md "$BASE_DIR/requirements/acceptance/definition-of-done.md" \
"完了定義" \
"完了の基準を明確にする資料です" \
"必須条件 テスト完了 ドキュメント 運用準備を記載します"

write_md "$BASE_DIR/requirements/acceptance/test-scenarios.md" \
"テストシナリオ" \
"受入観点を整理する資料です" \
"シナリオ 期待結果 前提データ 判定方法を記載します"

write_md "$BASE_DIR/requirements/changelog.md" \
"変更履歴" \
"要求仕様の変更を追跡する資料です" \
"変更日 変更内容 影響範囲 変更理由を記載します"

################################
# operations
################################
write_md "$BASE_DIR/operations/index.md" \
"運用操作" \
"運用ドキュメントの入口です" \
"日常運用 障害対応 メンテナンス 管理画面の資料への導線をまとめます"

write_md "$BASE_DIR/operations/quickstart.md" \
"クイックスタート" \
"最短で運用を開始するための資料です" \
"初期確認 必須設定 日次確認 連絡先を記載します"

write_md "$BASE_DIR/operations/runbooks/monitoring.md" \
"監視" \
"監視の見方と判断基準をまとめる資料です" \
"見るべき指標 アラート対応 初動確認を記載します"

write_md "$BASE_DIR/operations/runbooks/incident-response.md" \
"障害対応" \
"障害発生時の対応を標準化する資料です" \
"検知 影響判断 一次対応 エスカレーション 復旧 事後対応を記載します"

write_md "$BASE_DIR/operations/runbooks/backup-restore.md" \
"バックアップとリストア" \
"バックアップと復旧を確実にする資料です" \
"取得対象 取得頻度 保存先 復旧手順 検証方法を記載します"

write_md "$BASE_DIR/operations/runbooks/scaling.md" \
"スケーリング" \
"負荷増減への対応手順をまとめる資料です" \
"判断基準 変更手順 影響確認 ロールバックを記載します"

write_md "$BASE_DIR/operations/runbooks/maintenance-window.md" \
"メンテナンス" \
"計画停止を含む作業を標準化する資料です" \
"事前告知 手順 確認事項 事後報告を記載します"

write_md "$BASE_DIR/operations/procedures/user-management.md" \
"ユーザー管理" \
"ユーザー運用の手順をまとめる資料です" \
"追加 変更 無効化 権限付与 監査確認を記載します"

write_md "$BASE_DIR/operations/procedures/content-management.md" \
"コンテンツ管理" \
"コンテンツ運用の手順をまとめる資料です" \
"登録 更新 削除 公開 範囲設定を記載します"

write_md "$BASE_DIR/operations/procedures/job-operations.md" \
"ジョブ操作" \
"バッチやジョブ運用の手順をまとめる資料です" \
"実行 監視 再実行 停止 失敗時対応を記載します"

write_md "$BASE_DIR/operations/admin-console/screens.md" \
"管理画面 画面一覧" \
"管理画面の全体像を共有する資料です" \
"画面一覧 目的 入り口 主な機能を記載します"

write_md "$BASE_DIR/operations/admin-console/common-errors.md" \
"管理画面 よくあるエラー" \
"管理画面での代表的なエラー対応をまとめる資料です" \
"症状 原因 対処 回避策を記載します"

write_md "$BASE_DIR/operations/faq.md" \
"よくある質問" \
"運用で頻出の疑問を集約する資料です" \
"質問 回答 関連リンクを記載します"

################################
# reference
################################
write_md "$BASE_DIR/reference/index.md" \
"リファレンス" \
"横断的に参照される資料の入口です" \
"用語 外部リンク テンプレートをまとめます"

write_md "$BASE_DIR/reference/glossary.md" \
"全体用語集" \
"システム全体で共通の用語を統一する資料です" \
"用語 定義 備考を記載します"

write_md "$BASE_DIR/reference/links.md" \
"外部リンク集" \
"参照先を集約する資料です" \
"仕様 書式 運用ツール リポジトリなどのリンクを記載します"

write_md "$BASE_DIR/reference/templates/page-template.md" \
"ページテンプレート" \
"一般ページの記載形式を揃えるためのテンプレートです" \
"目的 背景 決定事項 詳細 参照の枠を提供します"

write_md "$BASE_DIR/reference/templates/runbook-template.md" \
"ランブックテンプレート" \
"運用ランブックの記載形式を揃えるためのテンプレートです" \
"目的 前提 手順 確認 ロールバック 連絡先の枠を提供します"

write_md "$BASE_DIR/reference/templates/adr-template.md" \
"ADR テンプレート" \
"設計判断を記録するためのテンプレートです" \
"背景 判断 選択肢 影響 代替案の枠を提供します"

echo "docs initialized with templates and TBD"