# psql操作に関するメモ

## 権限一覧
未精読

```SQL
SELECT
    r.rolname AS role_name,
	n.nspname AS schema_name,
    c.relname AS table_name,
    pg_get_userbyid(c.relowner) AS table_owner,
    has_table_privilege(r.rolname, c.oid, 'SELECT') AS select_privilege,
	has_table_privilege(r.rolname, c.oid, 'INSERT') AS insert_privilege,
    has_table_privilege(r.rolname, c.oid, 'UPDATE') AS update_privilege,
    has_table_privilege(r.rolname, c.oid, 'DELETE') AS delete_privilege
FROM
    pg_class c
JOIN
    pg_namespace n ON n.oid = c.relnamespace
CROSS JOIN
    pg_roles r
WHERE
    c.relkind = 'r' -- テーブルのみ
	AND n.nspname not in ('information_schema','hint_plan','pg_catalog')
	AND r.rolname NOT LIKE 'pg_%'
	AND r.rolname <> 'public'
	AND r.rolname <> 'replication'
	AND r.rolname not in ('sample', 'rds_superuser', 'rdsadmin')
	AND (
        has_table_privilege(r.oid, c.oid, 'SELECT') = true OR
        has_table_privilege(r.oid, c.oid, 'INSERT') = true OR
        has_table_privilege(r.oid, c.oid, 'UPDATE') = true OR
        has_table_privilege(r.oid, c.oid, 'DELETE') = true
    )
ORDER BY
     r.rolname, n.nspname, c.relname;
```

## ロジカルレプリケーション

- [内部構造から学ぶPostgreSQL 設計・運用計画の鉄則 ch10 (高可用化と負荷分散) (6/6)](https://wand-ta.hatenablog.com/entry/2020/02/15/214718)

### pub側
```SQL
-- パブリケーション作成
CREATE PUBLICATION pub_name FOR TABLE table_a, table_b;
-- パブリケーション削除
DROP PUBLICATION pub_name;
-- パブリケーション一覧
select * from pg_publication;
-- パブリケーションテーブル一覧？
select * from pg_publication_tables;
-- レプリケーションスロット一覧
select * from pg_replication_slots;
-- レプリケーションの状況を取得（遅延確認）
select * from pg_stat_replication;
```

### sub側
```SQL
-- サブスクリプション作成
CREATE SUBSCRIPTION sub_name
CONNECTION 'host=192.168.1.1 port=5432 user=foo dbname=foodb'
PUBLICATION pub_name_1, pub_name_2;

-- サブスクリプション削除
DROP SUBSCRIPTION sub_name;

-- subscription 一覧
select * from pg_subscription;
-- レプリケーションの状況を取得（遅延確認）
select * from pg_stat_subscription;
-- 削除
drop subscription {subscription_name};
```

<!---------------------------------------------------------------------------------------->

## pg_dump
sqlをdumpするコマンド。  
pg_restoreと連携するために、標準出力先をファイルにして使う場合が多い。  
標準出力になるので、エラーとかが発生した際はファイルの中に記録されることに注意する。  

### 実行例
```
pg_dump -s -h localhost -U sample_user -d sample_db > tmp_ddl.sql
```

### オプション
| オプション | 意味 |
| - | - |
| -s | スキーマのみダンプ |
| -a | データのみをダンプ |
| -h | 接続先ホスト |
| -d | 接続先DB |
| -U | 接続ユーザ |

## 部分的なテーブルダンプ
pg_dumpだとテーブルの一部はダンプできない模様。
変わりにCopy文が用いられる。

https://yuumi3.hatenablog.com/entry/20071213/1197535601

csv出力（select文で範囲指定）
```
\copy (select * from salestech_portal.t_merchandise_resource where t_merchandise_resource_extension='pdf') to t_merchandise_resource.csv WITH (FORMAT CSV, HEADER, DELIMITER ',');
```

## psql更新
サーバーとクライアントのバージョンが異なる場合は接続できないため、適切なバージョンに切り替えること。

```
# リスト更新
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update

# インストール可能なバージョンを調べる
sudo apt-cache search postgresql | grep ^postgresql

# インストール実行
sudo apt install postgresql-client-12
psql --version
```


[Ubuntuに任意のバージョンのPostgreSQLをインストールする方法](https://xblood.hatenablog.com/entry/install-postgresql-to-ubuntu)


## 未整理
[PostgreSQLの監視に便利なSQL一覧（随時更新中）](https://qiita.com/mkyz08/items/ff4474a5546a62adc580)