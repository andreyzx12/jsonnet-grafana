local grafana = import 'grafonnet/grafana.libsonnet';
local graphite = grafana.graphite;
local singlestat = grafana.singlestat;
local barGaugePanel = import 'grafonnet-lib/grafonnet/bar_gauge_panel.libsonnet';
local dashboard = grafana.dashboard;
local gauge = import 'libs/gauge.libsonnet';
local graphPanel = grafana.graphPanel;
local statPanel = import 'libs/stat_panel.libsonnet';
local zabbix = import 'libs/zabbix.libsonnet';
local row = grafana.row;
local singlestat = grafana.singlestat;
local prometheus = grafana.prometheus;
local template = grafana.template;
local config = std.parseYaml(importstr "config.yaml");
local clickhouse = import 'libs/clickhouse.libsonnet';
local table = import 'libs/table.libsonnet';
local timeseries = import 'libs/timeseries.libsonnet';

dashboard.new(
  config.AppName,
  editable=true,
  schemaVersion=16,
  tags=['PiedPiper'],
)
.addTemplate(
    template.constant(
        'hostClickhouse',
        '',
        config.Hosts.Clickhouse,
        config.Hosts.Clickhouse,
    )
)
.addTemplate(
    template.constant(
        'hostK8sDm',
        '',
        config.Hosts.K8s,
        config.Hosts.K8s,
    )
)
.addTemplate(
    template.constant(
        'hostPgShare',
        '',
        config.Hosts.PgShared,
        config.Hosts.PgShared,
    )
)
.addTemplate(
    template.constant(
        'hostFSSO',
        '',
        config.Hosts.FSSO,
        config.Hosts.FSSO,
    )
)
.addTemplate(
    template.constant(
        'hostApiGW',
        '',
        config.Hosts.APIGW,
        config.Hosts.APIGW,
    )
)
.addTemplate(
    template.constant(
        'Prod',
        '',
        config.Hosts.ProdClusterK8S,
        config.Hosts.ProdClusterK8S,
    )
)
.addTemplate(
    template.constant(
        'appName',
        '',
        config.AppName,
        config.AppName,
    )
)
.addTemplate(
    template.constant(
        'hostZookeeper',
        '',
        config.Hosts.Zookeeper,
        config.Hosts.Zookeeper,
    )
)
.addTemplate(
    template.constant(
        'hostNeo4j',
        '',
        config.Hosts.Neo4j,
        config.Hosts.Neo4j,
    )
)
.addTemplate(
    template.constant(
        'hostTigergraph',
        '',
        config.Hosts.TigerGraph,
        config.Hosts.TigerGraph,
    )
)
.addTemplate(
    template.constant(
        'clusterName',
        '',
        config.ClusterPgShared,
        config.ClusterPgShared,
    )
)
.addTemplate(
    template.constant(
        'database',
        '',
        config.DatabasePgShared,
        config.DatabasePgShared,
    )
)
.addTemplate(
    template.constant(
        'namespace',
        '',
        config.NameSpace,
        config.NameSpace,
    )
)
.addTemplate(
    template.custom(
        'zone',
        'msk-p1-dm-gen|msk-p1-kb-gen|msk-p1-tp-gen,vlg-t2-dc-l,vlg-t2-dc-n',
        'msk-p1-dm-gen|msk-p1-kb-gen|msk-p1-tp-gen'
    )
)
.addPanel(
    row.new('Depend On Services'),
    gridPos={
    h: 1,
    w: 24,
    x: 0,
    y: 0,
  }
)
.addPanel(
gauge.new(
    'Node resources',
    datasource='-- Mixed --',
    unit='percent',
    displaymode='lcd',
    orientation='horizontal',
    max=50,
    mode='continuous-GrYlRd',
    textsize=12,
)
.addTarget(
    graphite.target(
        "alias(averageSeries(exclude(collectd.{$hostClickhouse}.{df-data,df-home,df-opt,df-boot,df-root,df-var,df-data-log,df-tmp}.percent_bytes-used, 'data-docker|var-lib-kubelet|var-lib-rancher')), 'Clickhouse Storage')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(groupByNode(collectd.{$hostClickhouse}.cpu.percent-{user,system,interrupt,wait,softirq,nice,steal}, 1, 'sum')), 'Clickhouse CPU')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(collectd.{$hostClickhouse}.memory.percent-used), 'Clickhouse RAM')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(exclude(collectd.{$hostClickhouse}.{df-data,df-home,df-opt,df-boot,df-root,df-var,df-data-log,df-tmp}.percent_bytes-used, 'data-docker|var-lib-kubelet|var-lib-rancher')), 'Kubernetes Storage')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(groupByNode(collectd.{$hostK8sDm}.cpu.percent-{user,system,interrupt,wait,softirq,nice,steal}, 1, 'sum')), 'Kubernetes CPU')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(collectd.{$hostK8sDm}.memory.percent-used), 'Kubernetes RAM')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(exclude(collectd.{$hostPgShare}.{df-data,df-home,df-opt,df-boot,df-root,df-var,df-data-log,df-tmp}.percent_bytes-used, 'data-docker|var-lib-kubelet|var-lib-rancher')), 'Pg-eapi Storage')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(groupByNode(collectd.{$hostPgShare}.cpu.percent-{user,system,interrupt,wait,softirq,nice,steal}, 1, 'sum')), 'Pg-eapi CPU')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(collectd.{$hostPgShare}.memory.percent-used), 'Pg-eapi RAM')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(exclude(collectd.{$hostFSSO}.{df-data,df-home,df-opt,df-boot,df-root,df-var,df-data-log,df-tmp}.percent_bytes-used, 'data-docker|var-lib-kubelet|var-lib-rancher')), 'Keycloak Storage')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(groupByNode(collectd.{$hostFSSO}.cpu.percent-{user,system,interrupt,wait,softirq,nice,steal}, 1, 'sum')), 'Keycloak CPU')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(collectd.{$hostFSSO}.memory.percent-used), 'Keycloak RAM')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(exclude(collectd.{$hostApiGW}.{df-data,df-home,df-opt,df-boot,df-root,df-var,df-data-log,df-tmp}.percent_bytes-used, 'data-docker|var-lib-kubelet|var-lib-rancher')), 'APIGW Storage')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(groupByNode(collectd.{$hostApiGW}.cpu.percent-{user,system,interrupt,wait,softirq,nice,steal}, 1, 'sum')), 'APIGW CPU')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(collectd.{$hostApiGW}.memory.percent-used), 'APIGW RAM')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(exclude(collectd.{$hostZookeeper}.{df-data,df-home,df-opt,df-boot,df-root,df-var,df-data-log,df-tmp}.percent_bytes-used, 'data-docker|var-lib-kubelet|var-lib-rancher')), 'Zookeeper Storage')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(groupByNode(collectd.{$hostZookeeper}.cpu.percent-{user,system,interrupt,wait,softirq,nice,steal}, 1, 'sum')), 'Zookeeper CPU')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(collectd.{$hostZookeeper}.memory.percent-used), 'Zookeeper RAM')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(exclude(collectd.{$hostNeo4j}.{df-data,df-home,df-opt,df-boot,df-root,df-var,df-data-log,df-tmp}.percent_bytes-used, 'data-docker|var-lib-kubelet|var-lib-rancher')), 'Neo4j Storage')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(groupByNode(collectd.{$hostNeo4j}.cpu.percent-{user,system,interrupt,wait,softirq,nice,steal}, 1, 'sum')), 'Neo4j CPU')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(collectd.{$hostNeo4j}.memory.percent-used), 'Neo4j RAM')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(exclude(collectd.{$hostTigergraph}.{df-data,df-home,df-opt,df-boot,df-root,df-var,df-data-log,df-tmp}.percent_bytes-used, 'data-docker|var-lib-kubelet|var-lib-rancher')), 'Tigergraph Storage')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(groupByNode(collectd.{$hostTigergraph}.cpu.percent-{user,system,interrupt,wait,softirq,nice,steal}, 1, 'sum')), 'Tigergraph CPU')",
        datasource='Graphite (unix dashboard)',
    )
)
.addTarget(
    graphite.target(
        "alias(averageSeries(collectd.{$hostTigergraph}.memory.percent-used), 'Tigergraph RAM')",
        datasource='Graphite (unix dashboard)',
    )
),
gridPos={
    h: 13,
    w: 12,
    x: 0,
    y: 1,
}
)
.addPanel(
    statPanel.new(
        'Status cluster $clusterName',
        datasource='-- Mixed --',
    )
    .addTarget(
        zabbix.target(
            groupFilter='BSS-EXT PostgreSQL',
            hostFilter='$clusterName',
            itemFilter='PostgreSQL | BSS-EXT | Status cluster',
            datasource='Zabbix Prom',

        )
),
gridPos={
    h: 4,
    w: 6,
    x: 12,
    y: 1,
}
)
.addPanel(
    statPanel.new(
        'Status cluster APIGW',
        datasource='-- Mixed --',
    )
    .addTarget(
        prometheus.target(
            'sum(procstat_lookup_running{stand=\"GF\",appl_id=\"9156\",host=~\"msk-apigw-app.*\"}) / 15',
            datasource='Prometheus (prod)',
            interval='',
            instant='true',
        )
    ),
gridPos={
    h: 4,
    w: 6,
    x: 12,
    y: 5,
}
)
.addPanel(
    statPanel.new(
        'Status cluster Keycloak',
        datasource='-- Mixed --',
    )
    .addTarget(
        prometheus.target(
            'count(http_response_result_code{host=~\"msk-fsso-app*.*\"}) / 24',
            datasource='Prometheus (prod)',
            interval='',
            instant='true',
        )
    ),
gridPos={
    h: 4,
    w: 6,
    x: 18,
    y: 5,
}
)
.addPanel(
    statPanel.new(
        'Connections to $database',
        datasource='-- Mixed --',
    )
    .addTarget(
        zabbix.target(
            groupFilter='BSS-EXT PostgreSQL',
            hostFilter='$clusterName',
            itemFilter='/.*percent connection on  DB $database/',
            datasource='Zabbix Prom',

        )
),
gridPos={
    h: 4,
    w: 6,
    x: 18,
    y: 2,
}
)
.addPanel(
    row.new('Business requests'),
    gridPos={
    h: 1,
    w: 24,
    x: 0,
    y: 14,
  }
)
.addPanel(
    graphPanel.new(
        'Sucsess requests k8s count',
    )
    .addTarget(
        prometheus.target(
            'sum by(cluster)(idelta(http_server_requests_seconds_count{service=~\"$appName.*\",status=~\"2.*\",uri!~\".*/manage.*\", cluster=~\"($zone)\"}[5m]))',
            datasource='Prometheus (bss)',
            intervalFactor=1,
            interval='',
            instant=false,
        )
),
gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 15,
}
)
.addPanel(
    graphPanel.new(
        'Bad requests k8s count',
    )
    .addTarget(
        prometheus.target(
            'sum by(cluster)(idelta(http_server_requests_seconds_count{cluster=~"($zone)", uri!~".*/manage.*", status=~"(5|4).*", service=~"$appName.*"}[5m]))',
            datasource='Prometheus (bss)',
            intervalFactor=1,
            interval='',
            instant=false,
        )
),
gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 15,
}
)
.addPanel(
    graphPanel.new(
        'Sucsess requests k8s duration',
    )
    .addTarget(
        prometheus.target(
            'sum(increase(http_server_requests_seconds_sum{service=~"$appName.*",status=~"2.*",uri!~".*/manage.*", cluster=~"($zone)"}[5m]))/sum(increase(http_server_requests_seconds_count{service=~"$appName.*",status=~"2.*",uri!~".*/manage.*", cluster=~"($zone)"}[5m]))',
            datasource='Prometheus (bss)',
            intervalFactor=1,
            interval='',
            instant=false,
        )
),
gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 23,
}
)
.addPanel(
    graphPanel.new(
        'Bad requests k8s duration',
    )
    .addTarget(
        prometheus.target(
            'sum(increase(http_server_requests_seconds_sum{service=~"$appName.*",status=~"(5|4).*",uri!~".*/manage.*", cluster=~"($zone)"}[5m]))/sum(increase(http_server_requests_seconds_count{service=~"$appName.*",status=~"(5|4).*",uri!~".*/manage.*", cluster=~"($zone)"}[5m]))',
            datasource='Prometheus (bss)',
            intervalFactor=1,
            interval='',
            instant=false,
        )
),
gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 23,
}
)
.addPanel(
    graphPanel.new(
        'Sucsess requests apigw',
        datasource='dark-ch(fed)'
    )
    .addTarget(
        clickhouse.target(
            database='dark_kqi',
            dateTimeType='DATETIME',
            format='time_series',
            formattedQuery='SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t',
            intervalFactor=1,
            query="\nSELECT\n (intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n masked_uri AS Back_NAME,\n SUM(upstream_response_time) / Count(*) \nFROM dark_logs_m.apigw_gf\n\nWHERE\n timestamp > $from\n and timestamp <= $to\n and status in (200)\n and masked_uri LIKE (if(empty('$appName'), '%', '%$appName%'))\n\nGROUP BY\n t,\n Back_NAME\nORDER BY t ,Back_NAME \n \n",
            rawQuery="SELECT\n (intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n masked_uri AS Back_NAME,\n SUM(upstream_response_time) / Count(*) \nFROM dark_logs_m.apigw_gf\n\nWHERE\n timestamp > 1647601807\n and timestamp <= 1647612607\n and status in (200)\n and masked_uri LIKE (if(empty('ivr-alarms-api'), '%', '%ivr-alarms-api%'))\n\nGROUP BY\n t,\n Back_NAME\nORDER BY t ,Back_NAME",
        )
),
gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 31,
}
)
.addPanel(
    graphPanel.new(
        'Bad requests apigw',
        datasource='dark-ch(fed)'
    )
    .addTarget(
        clickhouse.target(
            database='dark_kqi',
            dateTimeType='DATETIME',
            format='time_series',
            formattedQuery='SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t',
            intervalFactor=1,
            query="\nSELECT\n \t(intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n concat(masked_uri, ' (Code:', Cast(status, 'String'), ')') AS Status,\n COUNT(*) AS Quontity\nFROM dark_logs_m.apigw_gf\nWHERE\n timestamp > $from\n and timestamp <= $to\n and concat(masked_uri,cast(status,'String')) NOT LIKE '%productOfferings%422%'\n and status NOT in (101,200,201,202,204,206,404,444)\n and masked_uri LIKE '%$appName%'\n\nGROUP BY Status, t\n\nORDER BY t DESC\n",
            rawQuery="SELECT\n \t(intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n concat(masked_uri, ' (Code:', Cast(status, 'String'), ')') AS Status,\n COUNT(*) AS Quontity\nFROM dark_logs_m.apigw_gf\nWHERE\n timestamp > 1649669419\n and timestamp <= 1649673019\n and concat(masked_uri,cast(status,'String')) NOT LIKE '%productOfferings%422%'\n and status NOT in (101,200,201,202,204,206,404,444)\n and masked_uri LIKE '%ivr-alarms-api%'\n\nGROUP BY Status, t\n\nORDER BY t DESC",
        )
),
gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 31,
}
)
.addPanel(
    graphPanel.new(
        'Sucsess requests apigw durations',
        datasource='dark-ch(fed)'
    )
    .addTarget(
        clickhouse.target(
            database='dark_kqi',
            dateTimeType='DATETIME',
            format='time_series',
            formattedQuery='SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t',
            intervalFactor=1,
            query="\nSELECT\n (intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n masked_uri AS Back_NAME,\n SUM(upstream_response_time) / Count(*) \nFROM dark_logs_m.apigw_gf\n\nWHERE\n timestamp > $from\n and timestamp <= $to\n and status in (200)\n and masked_uri LIKE (if(empty('$appName'), '%', '%$appName%'))\n\nGROUP BY\n t,\n Back_NAME\nORDER BY t ,Back_NAME \n \n",
            rawQuery="SELECT\n (intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n masked_uri AS Back_NAME,\n SUM(upstream_response_time) / Count(*) \nFROM dark_logs_m.apigw_gf\n\nWHERE\n timestamp > 1647601807\n and timestamp <= 1647612607\n and status in (200)\n and masked_uri LIKE (if(empty('ivr-alarms-api'), '%', '%ivr-alarms-api%'))\n\nGROUP BY\n t,\n Back_NAME\nORDER BY t ,Back_NAME",
        )
),
gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 39,
}
)
.addPanel(
    graphPanel.new(
        'Bad requests apigw durations',
        datasource='dark-ch(fed)'
    )
    .addTarget(
        clickhouse.target(
            database='dark_kqi',
            dateTimeType='DATETIME',
            format='time_series',
            formattedQuery='SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t',
            intervalFactor=1,
            query="\nSELECT\n (intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n masked_uri AS Back_NAME,\n SUM(upstream_response_time) / Count(*) \nFROM dark_logs_m.apigw_gf\n\nWHERE\n timestamp > $from\n and timestamp <= $to\n and status NOT in (101,200,201,202,204,206,404,444)\n and masked_uri LIKE (if(empty('$appName'), '%', '%$appName%'))\n\nGROUP BY\n t,\n Back_NAME\nORDER BY t ,Back_NAME \n \n",
            rawQuery="SELECT\n (intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n masked_uri AS Back_NAME,\n SUM(upstream_response_time) / Count(*) \nFROM dark_logs_m.apigw_gf\n\nWHERE\n timestamp > 1647601904\n and timestamp <= 1647612704\n and status NOT in (101,200,201,202,204,206,404,444)\n and masked_uri LIKE (if(empty('ivr-alarms-api'), '%', '%ivr-alarms-api%'))\n\nGROUP BY\n t,\n Back_NAME\nORDER BY t ,Back_NAME",
        )
),
gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 39,
}
)
.addPanel(
    row.new('Infrastructure'),
    gridPos={
    h: 1,
    w: 24,
    x: 0,
    y: 47,
  }
)
.addPanel(
    table.new(
        'App container status',
        datasource='Prometheus (bss)',
        transformations=[
            {
                id: 'organize',
                options: {
                    excludeByName: {
                        "Time": true
                    },
                    indexByName:{},
                    renameByName:{},
                },
            },
        ],
        mappings=[
            {
                options: {
                    '0':{
                        color: 'dark-red',
                        index: 2,
                        text: 'Down'
                    },
                    '1':{
                        color: 'orange',
                        index: 1,
                        text: 'Running'
                    },
                    '2':{
                        color: 'green',
                        index: 0,
                        text: 'Running'
                    },
                },
                type: 'value'
            },
        ],
    )
    .addTarget(
        prometheus.target(
            'sum(max_over_time(kube_pod_container_status_running{namespace=~\"$namespace.*\", pod=~\"$appName.*\", cluster=~\"($zone)\", container=\"$appName\"})[10s])by(cluster)',
            format='table',
            intervalFactor=1,
            interval='10s',
            instant=true,
        )
),
gridPos={
    h: 8,
    w: 4,
    x: 0,
    y: 48,
}
)
.addPanel(
    table.new(
        'Istio-proxy containers status',
        datasource='Prometheus (bss)',
        transformations=[
            {
                id: 'organize',
                options: {
                    excludeByName: {
                        "Time": true
                    },
                    indexByName:{},
                    renameByName:{},
                },
            },
        ],
        mappings=[
            {
                options: {
                    '0':{
                        color: 'dark-red',
                        index: 2,
                        text: 'Down'
                    },
                    '1':{
                        color: 'orange',
                        index: 1,
                        text: 'Running'
                    },
                    '2':{
                        color: 'green',
                        index: 0,
                        text: 'Running'
                    },
                },
                type: 'value'
            },
        ],
    )
    .addTarget(
        prometheus.target(
            'sum(kube_pod_container_status_running{namespace=~\"$namespace.*\", cluster=~\"($zone)\", container=~\"istio-proxy.*\", pod=~\"$appName.*\"})by(cluster)',
            format='table',
            intervalFactor=1,
            interval='10s',
            instant=true,
        )
),
gridPos={
    h: 8,
    w: 4,
    x: 4,
    y: 48,
}
)
.addPanel(
    table.new(
        'Pods',
        datasource='Prometheus (bss)',
        transformations=[
            {
                id: 'organize',
                options: {
                    excludeByName: {
                        "Time": true
                    },
                    indexByName:{},
                    renameByName:{},
                },
            },
        ],
        mappings=[
            {
                options: {
                    '0':{
                        color: 'dark-red',
                        index: 2,
                    },
                    '1':{
                        color: 'orange',
                        index: 1,
                    },
                    '2':{
                        color: 'green',
                        index: 0,
                    },
                },
                type: 'value'
            },
        ],
    )
    .addTarget(
        prometheus.target(
            'sum(kube_pod_status_phase{namespace=~\"$namespace.*\", phase=\"Running\", pod=~\"$appName.*\", cluster=~\"($zone)\"}) by(cluster)',
            format='table',
            intervalFactor=1,
            interval='10s',
            instant=true,
        )
),
gridPos={
    h: 8,
    w: 4,
    x: 8,
    y: 48,
}
)
.addPanel(
    timeseries.new(
        'CPU',
        datasource='Prometheus (bss)',
    )
    .addTarget(
        prometheus.target(
            'sum(kube_pod_container_resource_limits{namespace=~\"$namespace.*\", cluster=~\"($zone)\", container=~\"(istio-proxy.*|$appName)\",resource=\"cpu\", pod=~\"$appName.*\"}) by (pod, container, cluster) * 1000',
            format='time_series',
            instant=false,
            intervalFactor=1,
            legendFormat='{{cluster}} {{container}}'
        )
    )
    .addTarget(
        prometheus.target(
            'sum(rate(container_cpu_usage_seconds_total{namespace=~\"$namespace.*\", cluster=~\"($zone)\", container=~\"(istio-proxy.*|$appName)\", pod=~\"$appName.*\"}[1m])*1000)by(container,pod,cluster)',
            format='time_series',
            instant=false,
            intervalFactor=1,
        )
),
gridPos={
    h: 16,
    w: 6,
    x: 12,
    y: 48,
}
)
.addPanel(
    timeseries.new(
        'RAM',
        datasource='Prometheus (bss)',
        unit='bytes',
    )
    .addTarget(
        prometheus.target(
            'sum(kube_pod_container_resource_limits{namespace=~\"$namespace.*\", cluster=~\"($zone)\", container=~\"(istio-proxy|$appName)\",resource=\"memory\", pod=~\"$appName.*\"}) by (pod, container, cluster)',
            format='time_series',
            instant=false,
            intervalFactor=1,
            legendFormat='{{cluster}} {{container}}'
        )
    )
    .addTarget(
        prometheus.target(
            'sum(container_memory_working_set_bytes{container_name!=\"POD\",namespace=~\"$namespace.*\", cluster=~\"($zone)\", pod=~\"$appName.*\", pod=~\"$appName.*\", container=~\"(istio-proxy.*|$appName.*)\"}) by (pod, container, cluster)',
            format='time_series',
            instant=false,
            intervalFactor=1,
            legendFormat='{{cluster}} {{container}}'
        )
),
gridPos={
    h: 16,
    w: 6,
    x: 18,
    y: 48,
}
)
.addPanel(
    table.new(
        'App containers restarts',
        datasource='Prometheus (bss)',
        transformations=[
            {
                id: 'organize',
                options: {
                    excludeByName: {
                        "Time": true
                    },
                    indexByName:{},
                    renameByName:{},
                },
            },
        ],
        mappings=[
            {
                options: {
                    '0':{
                        color: 'green',
                        index: 0,
                    },
                },
                type: 'value'
            },
            {
                options:{
                    from: 1,
                    result:{
                        color: 'red',
                        index: 1
                    },
                    to: 1000
                },
                type: 'range'
            },
        ],
    )
    .addTarget(
        prometheus.target(
            'sum(max_over_time(kube_pod_container_status_restarts_total{namespace=~\"$namespace.*\", pod=~\"$appName.*\", cluster=~\"($Prod)\", container=\"$appName\"})[10s])by(cluster)',
            format='table',
            intervalFactor=1,
            interval='10s',
            instant=true,
        )
),
gridPos={
    h: 8,
    w: 4,
    x: 0,
    y: 56,
}
)
.addPanel(
    table.new(
        'istio-proxy containers restarts',
        datasource='Prometheus (bss)',
        transformations=[
            {
                id: 'organize',
                options: {
                    excludeByName: {
                        "Time": true
                    },
                    indexByName:{},
                    renameByName:{},
                },
            },
        ],
        mappings=[
            {
                options: {
                    '0':{
                        color: 'green',
                        index: 0,
                    },
                },
                type: 'value'
            },
            {
                options:{
                    from: 1,
                    result:{
                        color: 'red',
                        index: 1
                    },
                    to: 1000
                },
                type: 'range'
            },
        ],
    )
    .addTarget(
        prometheus.target(
            'sum(max_over_time(kube_pod_container_status_restarts_total{namespace=~\"$namespace.*\", pod=~\"$appName.*\", cluster=~\"($Prod)\", container=\"istio-proxy\"})[10s])by(cluster)',
            format='table',
            intervalFactor=1,
            interval='10s',
            instant=true,
        )
),
gridPos={
    h: 8,
    w: 4,
    x: 4,
    y: 56,
}
)
.addPanel(
    row.new('Standart app metrics'),
    gridPos={
    h: 1,
    w: 24,
    x: 0,
    y: 64,
  }
)
.addPanel(
    timeseries.new(
        'Sucsess incoming requests count',
        datasource='Prometheus (bss)',
    )
    .addTarget(
        prometheus.target(
            'sum(http_incoming_request_count{status=~\"2.*\", namespace=\"$namespace\", uri!~\".*/manage.*\", pod=~\"$appName.*\", cluster=~\"$zone\", method=~\".*\",pod=~\"$appName.*\"})by(cluster,method,status,uri,pod)',
            format='time_series',
            instant=false,
            intervalFactor=1,
        )
    ),
gridPos={
    h: 6,
    w: 12,
    x: 0,
    y: 65,
}
)
.addPanel(
    timeseries.new(
        'Bad incoming requests count',
        datasource='Prometheus (bss)',
    )
    .addTarget(
        prometheus.target(
            'sum(http_incoming_request_count{status=~\"(4.*|5.*)\", namespace=\"$namespace\", uri!~\".*/manage.*\", pod=~\"$appName.*\", cluster=~\"$zone\", method=~\".*\",pod=~\"$appName.*\"})by(cluster,method,status,uri,pod)',
            format='time_series',
            instant=false,
            intervalFactor=1,
        )
    ),
gridPos={
    h: 6,
    w: 12,
    x: 12,
    y: 65,
}
)
.addPanel(
    timeseries.new(
        'Sucsess incoming requests duration',
        datasource='Prometheus (bss)',
    )
    .addTarget(
        prometheus.target(
            'sum(http_incoming_request_duration{status=~\"2.*\", namespace=\"$namespace\", uri!~\".*/manage.*\", pod=~\"$appName.*\", cluster=~\"$zone\", method=~\".*\",pod=~\"$appName.*\"})by(cluster,method,status,uri,pod)',
            format='time_series',
            instant=false,
            intervalFactor=1,
        )
    ),
gridPos={
    h: 6,
    w: 12,
    x: 0,
    y: 71,
}
)
.addPanel(
    timeseries.new(
        'Bad incoming requests duration',
        datasource='Prometheus (bss)',
    )
    .addTarget(
        prometheus.target(
            'sum(http_incoming_request_duration{status=~\"(4.*|5.*)\", namespace=\"$namespace\", uri!~\".*/manage.*\", pod=~\"$appName.*\", cluster=~\"$zone\", method=~\".*\",pod=~\"$appName.*\"})by(cluster,method,status,uri,pod)',
            format='time_series',
            instant=false,
            intervalFactor=1,
        )
    ),
gridPos={
    h: 6,
    w: 12,
    x: 12,
    y: 71,
}
)
.addPanel(
    table.new(
        'db queries',
        datasource='Prometheus (bss)',
        transformations=[
            {
                id: 'merge',
                options: {},
            },
            {
                id: 'organize',
                options: {
                    excludeByName: {
                        "Time": true
                    },
                    indexByName:{
                        'Value #A': 6,
                        'Value #B': 7,
                        'Value #C': 8,
                        'cluster': 1,
                        'connName': 3,
                        'pod': 2,
                        'queryId': 4,
                        'status': 5
                    },
                    renameByName:{
                        'Value #A': 'db_query_count',
                        'Value #B': 'db_query_duration',
                        'Value C': 'db_query_result_count'
                    },
                },
            },
        ],
    )
    .addTarget(
        prometheus.target(
            'sum(db_query_count{connName=~\".*\", namespace=\"$namespace\", pod=~\"$appName.*\", cluster=~\"$zone\", queryId=~\".*\", status=~\".*\",pod=~\"$appName.*\"})by(cluster,connName, queryId,status,pod)',
            format='table',
            intervalFactor=1,
            interval='10s',
            instant=true,
        )
)
    .addTarget(
        prometheus.target(
            'sum(db_query_duration{connName=~\".*\", namespace=\"$namespace\", pod=~\"$appName.*\", cluster=~\"$zone\", queryId=~\".*\",pod=~\"$appName.*\",status=~\".*\"})by(cluster,connName, queryId,status,pod)',
            format='table',
            intervalFactor=1,
            interval='10s',
            instant=true,
        )
)
    .addTarget(
        prometheus.target(
            'sum(db_query_result_count{connName=~\".*\", namespace=\"$namespace\", pod=~\"$appName.*\", cluster=~\"$zone\", queryId=~\".*\", status=~\".*\",pod=~\"$appName.*\"})by(cluster,connName, queryId,status,pod)',
            format='table',
            intervalFactor=1,
            interval='10s',
            instant=true,
        )
),
gridPos={
    h: 6,
    w: 12,
    x: 0,
    y: 77,
}
)
.addPanel(
    table.new(
        'http incoming requests histogram',
        datasource='Prometheus (bss)',
        transformations=[
            {
                id: 'organize',
                options: {
                    excludeByName: {
                        "Time": true
                    },
                    indexByName:{
                        'Value': 7,
                        'cluster': 1,
                        'le': 6,
                        'method': 4,
                        'pod': 2,
                        'status': 5,
                        'uri': 3
                    },
                },
            },
        ],
    )
    .addTarget(
        prometheus.target(
            'sum(http_incoming_request_duration_histogram_bucket{status=~\".*\", namespace=\"$namespace\", uri!~\".*/manage.*\", pod=~\"$appName.*\", cluster=~\"$zone\", method=~\".*\", le=~\".*\"})by(cluster,uri,status,le,pod,method)',
            format='table',
            intervalFactor=1,
            interval='10s',
            instant=true,
        )
),
gridPos={
    h: 6,
    w: 12,
    x: 12,
    y: 77,
}
)
.addPanel(
    row.new('Business app metrics'),
    gridPos={
    h: 1,
    w: 24,
    x: 0,
    y: 83,
  }
)
.addPanel(
    table.new(
        'business metrics gaugevec',
        datasource='Prometheus (bss)',
        transformations=[
            {
                id: 'organize',
                options: {
                    excludeByName: {
                        "Time": true
                    },
                    indexByName:{
                        'Value': 6,
                        'cluster': 1,
                        'metric_name': 3,
                        'parameter': 4,
                        'pod': 2,
                        'status': 5,
                    },
                },
            },
        ],
    )
    .addTarget(
        prometheus.target(
            'sum(business_metric_gaugevec{status=~\".*\", namespace=\"$namespace\",pod=~\"$appName.*\", cluster=~\"$zone\", metric_name=~\".*\", parameter=~\".*\",type=~\".*\"})by(cluster,pod,metric_name,parameter,status)',
            format='table',
            intervalFactor=1,
            interval='10s',
            instant=true,
        )
),
gridPos={
    h: 5,
    w: 12,
    x: 0,
    y: 84,
}
)
