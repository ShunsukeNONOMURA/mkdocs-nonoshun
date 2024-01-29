# OpensearchのDocker構築
Dockerを用いたローカル構築についての記述

## dockerでのローカル環境構築  
- [github repository](https://github.com/ShunsukeNONOMURA/opensearch-master)にdocker一式を配置。
- git clone後にdocker compose upで稼働可能。
- 起動後に5601ポートでopensearch dashboardsにアクセスできる
    - 初期認証：admin, admin
- [参考：OpenSearch でいろいろやってみる ～インストール編～](https://qiita.com/hwatry/items/cf92a44f48f4dbb54d9d)

### Dockerfile
日本語検索できるようにkuromoji等のプラグインをインストールしている。

```Dockerfile
FROM opensearchproject/opensearch:latest
RUN bin/opensearch-plugin install analysis-kuromoji analysis-icu
```

### docker-compose.yml
2ノード、1ビューアの構成で起動

```yaml
version: '3'
services:
  opensearch-node1:
    build: .
    container_name: opensearch-node1
    environment:
      - cluster.name=opensearch-cluster
      - node.name=opensearch-node1
      - discovery.seed_hosts=opensearch-node1,opensearch-node2
      - cluster.initial_cluster_manager_nodes=opensearch-node1,opensearch-node2
      - bootstrap.memory_lock=true # along with the memlock settings below, disables swapping
      - "OPENSEARCH_JAVA_OPTS=-Xms512m -Xmx512m" # minimum and maximum Java heap size, recommend setting both to 50% of system RAM
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536 # maximum number of open files for the OpenSearch user, set to at least 65536 on modern systems
        hard: 65536
    volumes:
      - opensearch-data1:/usr/share/opensearch/data
    ports:
      - 9200:9200
      - 9600:9600 # required for Performance Analyzer
    networks:
      - opensearch-net
  opensearch-node2:
    build: .
    container_name: opensearch-node2
    environment:
      - cluster.name=opensearch-cluster
      - node.name=opensearch-node2
      - discovery.seed_hosts=opensearch-node1,opensearch-node2
      - cluster.initial_cluster_manager_nodes=opensearch-node1,opensearch-node2
      - bootstrap.memory_lock=true
      - "OPENSEARCH_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536
        hard: 65536
    volumes:
      - opensearch-data2:/usr/share/opensearch/data
    networks:
      - opensearch-net
  opensearch-dashboards:
    image: opensearchproject/opensearch-dashboards:latest
    container_name: opensearch-dashboards
    ports:
      - 5601:5601
    expose:
      - "5601"
    environment:
      OPENSEARCH_HOSTS: '["https://opensearch-node1:9200","https://opensearch-node2:9200"]'
    networks:
      - opensearch-net

volumes:
  opensearch-data1:
  opensearch-data2:

networks:
  opensearch-net:
```

## 起動しない場合：max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
下記のコマンドでvm.max_map_countの数値を引き上げるとよい。
```
sudo sysctl -w vm.max_map_count=262144
```