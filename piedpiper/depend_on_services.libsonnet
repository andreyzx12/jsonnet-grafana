local grafana = import 'grafonnet/grafana.libsonnet';
local gauge = import 'libs/gauge.libsonnet';
local graphite = grafana.graphite;
local statPanel = import 'libs/stat_panel.libsonnet';
local zabbix = import 'libs/zabbix.libsonnet';
local prometheus = grafana.prometheus;

local node_resources_vars(
    title,
    datasource,
    unit,
    displaymode,
    orientation,
    max,
    mode,
    textsize,
) = gauge.new(
    title=title,
    datasource=datasource,
    unit=unit,
    displaymode=displaymode,
    orientation=orientation,
    max=max,
    mode=mode,
    textsize=textsize,
).addTarget(
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
);

local status_cluster_pg_vars(
    title,
    datasource,
) = statPanel.new(
    title=title,
    datasource=datasource,
).addTarget(
    zabbix.target(
        groupFilter='BSS-EXT PostgreSQL',
        hostFilter='$clusterName',
        itemFilter='PostgreSQL | BSS-EXT | Status cluster',
        datasource='Zabbix Prom',
    )
);

local status_cluster_apigw_vars(
    title,
    datasource,
) = statPanel.new(
    title=title,
    datasource=datasource,
).addTarget(
    prometheus.target(
        'sum(procstat_lookup_running{stand=\"GF\",appl_id=\"9156\",host=~\"msk-apigw-app.*\"}) / 15',
        instant='true',
    )
);

local status_cluster_keycloak_vars(
    title,
    datasource,
) = statPanel.new(
    title=title,
    datasource=datasource,
).addTarget(
    prometheus.target(
        'sum(procstat_lookup_running{stand=\"GF\",appl_id=\"9156\",host=~\"msk-apigw-app.*\"}) / 15',
        instant='true',
    )
);

local connections_to_db_vars(
    title,
    datasource,
) = statPanel.new(
    title=title,
    datasource=datasource,
).addTarget(
    zabbix.target(
        groupFilter='BSS-EXT PostgreSQL',
        hostFilter='$clusterName',
        itemFilter='/.*percent connection on  DB $database/',
        datasource='Zabbix Prom',
    )
);

{
    node_resources(
        title='Node resources',
        datasource='-- Mixed --',
        unit='percent',
        displaymode='lcd',
        orientation='horizontal',
        max=50,
        mode='continuous-GrYlRd',
        textsize=12,
    ):: node_resources_vars(
            title=title,
            datasource=datasource,
            unit=unit,
            displaymode=displaymode,
            orientation=orientation,
            max=max,
            mode=mode,
            textsize=textsize,
    ),
    status_cluster_pg(
        title='Status cluster $clusterName',
        datasource='-- Mixed --',
    ):: status_cluster_pg_vars(
            title=title,
            datasource=datasource,
    ),
    status_cluster_apigw(
        title='Status cluster APIGW',
        datasource='Prometheus (prod)',
    ):: status_cluster_apigw_vars(
            title=title,
            datasource=datasource,
    ),
    status_cluster_keycloak(
        title='Status cluster Keycloak',
        datasource='Prometheus (prod)',
    ):: status_cluster_keycloak_vars(
            title=title,
            datasource=datasource,
    ),
    connections_to_db(
        title='Connections to $database',
        datasource='-- Mixed --',
    ):: connections_to_db_vars(
            title=title,
            datasource=datasource,
    ),
}
