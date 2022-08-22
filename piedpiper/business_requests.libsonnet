local grafana = import 'grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;
local clickhouse = import 'libs/clickhouse.libsonnet';

local sucsess_requests_k8s_count_vars(
    title,
    datasource,
) = graphPanel.new(
    title=title,
    datasource=datasource,
).addTarget(
    prometheus.target(
        'sum by(cluster)(idelta(http_server_requests_seconds_count{service=~\"$appName.*\",status=~\"2.*\",uri!~\".*/manage.*\", cluster=~\"($zone)\"}[5m]))',
        intervalFactor=1,
        interval='',
        instant=false,
    )
);

local bad_requests_k8s_count_vars(
    title,
    datasource,
) = graphPanel.new(
    title=title,
    datasource=datasource,
).addTarget(
    prometheus.target(
        'sum by(cluster)(idelta(http_server_requests_seconds_count{service=~\"$appName.*\",status=~\"(5|4).*\",uri!~\".*/manage.*\", cluster=~\"($zone)\"}[5m]))',
        intervalFactor=1,
        interval='',
        instant=false,
    )
);

local sucsess_requests_k8s_duration_vars(
    title,
    datasource,
    formatY1,
) = graphPanel.new(
    title=title,
    datasource=datasource,
    formatY1=formatY1,
).addTarget(
    prometheus.target(
        'sum(increase(http_server_requests_seconds_sum{service=~\"$appName.*\",status=~\"2.*\",uri!~\".*/manage.*\", cluster=~\"($zone)\"}[5m]))/sum(increase(http_server_requests_seconds_count{service=~\"$appName.*\",status=~\"2.*\",uri!~\".*/manage.*\", cluster=~\"($zone)\"}[5m]))',
        intervalFactor=1,
        interval='',
        instant=false,
    )
);

local bad_requests_k8s_duration_vars(
    title,
    datasource,
    formatY1,
) = graphPanel.new(
    title=title,
    datasource=datasource,
    formatY1=formatY1,
).addTarget(
    prometheus.target(
        'sum(increase(http_server_requests_seconds_sum{service=~\"$appName.*\",status=~\"(5|4).*\",uri!~\".*/manage.*\", cluster=~\"($zone)\"}[5m]))/sum(increase(http_server_requests_seconds_count{service=~\"$appName.*\",status=~\"(5|4).*\",uri!~\".*/manage.*\", cluster=~\"($zone)\"}[5m]))',
        intervalFactor=1,
        interval='',
        instant=false,
    )
);

local sucsess_requests_apigw_vars(
    title,
    datasource,
) = graphPanel.new(
    title=title,
    datasource=datasource,
).addTarget(
    clickhouse.target(
        database='dark_kqi',
        dateTimeType='DATETIME',
        format='time_series',
        formattedQuery='SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t',
        intervalFactor=1,
        query="\nSELECT\n \t(intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n concat(masked_uri, ' (Code:', Cast(status, 'String'), ')') AS Status,\n COUNT(*) AS Quontity\nFROM dark_logs_m.apigw_gf\nWHERE\n timestamp > $from\n and timestamp <= $to\n and concat(masked_uri,cast(status,'String')) NOT LIKE '%productOfferings%422%'\n and status in (200)\n and masked_uri LIKE '%$appName%'\n\n\nGROUP BY Status, t\n\nORDER BY t DESC\n",
        rawQuery="SELECT\n \t(intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n concat(masked_uri, ' (Code:', Cast(status, 'String'), ')') AS Status,\n COUNT(*) AS Quontity\nFROM dark_logs_m.apigw_gf\nWHERE\n timestamp > 1649838462\n and timestamp <= 1650011262\n and concat(masked_uri,cast(status,'String')) NOT LIKE '%productOfferings%422%'\n and status in (200)\n and masked_uri LIKE '%ivr-alarms-api%'\n\n\nGROUP BY Status, t\n\nORDER BY t DESC",
    )
);

local bad_requests_apigw_vars(
    title,
    datasource,
) = graphPanel.new(
    title=title,
    datasource=datasource,
).addTarget(
    clickhouse.target(
        database='dark_kqi',
        dateTimeType='DATETIME',
        format='time_series',
        formattedQuery='SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t',
        intervalFactor=1,
        query="\nSELECT\n \t(intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n concat(masked_uri, ' (Code:', Cast(status, 'String'), ')') AS Status,\n COUNT(*) AS Quontity\nFROM dark_logs_m.apigw_gf\nWHERE\n timestamp > $from\n and timestamp <= $to\n and concat(masked_uri,cast(status,'String')) NOT LIKE '%productOfferings%422%'\n and status NOT in (101,200,201,202,204,206,404,444)\n and masked_uri LIKE '%$appName%'\n\nGROUP BY Status, t\n\nORDER BY t DESC\n",
        rawQuery="SELECT\n \t(intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n concat(masked_uri, ' (Code:', Cast(status, 'String'), ')') AS Status,\n COUNT(*) AS Quontity\nFROM dark_logs_m.apigw_gf\nWHERE\n timestamp > 1649669419\n and timestamp <= 1649673019\n and concat(masked_uri,cast(status,'String')) NOT LIKE '%productOfferings%422%'\n and status NOT in (101,200,201,202,204,206,404,444)\n and masked_uri LIKE '%ivr-alarms-api%'\n\nGROUP BY Status, t\n\nORDER BY t DESC",
    )
);

local sucsess_requests_apigw_durations_vars(
    title,
    datasource,
    formatY1,
) = graphPanel.new(
    title=title,
    datasource=datasource,
    formatY1=formatY1,
).addTarget(
    clickhouse.target(
        database='dark_kqi',
        dateTimeType='DATETIME',
        format='time_series',
        formattedQuery='SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t',
        intervalFactor=1,
        query="\nSELECT\n (intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n masked_uri AS Back_NAME,\n SUM(upstream_response_time) / Count(*) \nFROM dark_logs_m.apigw_gf\n\nWHERE\n timestamp > $from\n and timestamp <= $to\n and status in (200)\n and masked_uri LIKE (if(empty('$appName'), '%', '%$appName%'))\n\nGROUP BY\n t,\n Back_NAME\nORDER BY t ,Back_NAME \n \n",
        rawQuery="SELECT\n (intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n masked_uri AS Back_NAME,\n SUM(upstream_response_time) / Count(*) \nFROM dark_logs_m.apigw_gf\n\nWHERE\n timestamp > 1650008544\n and timestamp <= 1650030144\n and status in (200)\n and masked_uri LIKE (if(empty('ivr-alarms-api'), '%', '%ivr-alarms-api%'))\n\nGROUP BY\n t,\n Back_NAME\nORDER BY t ,Back_NAME",
    )
);

local bad_requests_apigw_durations_vars(
    title,
    datasource,
    formatY1,
) = graphPanel.new(
    title=title,
    datasource=datasource,
    formatY1=formatY1,
).addTarget(
    clickhouse.target(
        database='dark_kqi',
        dateTimeType='DATETIME',
        format='time_series',
        formattedQuery='SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t',
        intervalFactor=1,
        query="\nSELECT\n (intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n masked_uri AS Back_NAME,\n SUM(upstream_response_time) / Count(*) \nFROM dark_logs_m.apigw_gf\n\nWHERE\n timestamp > $from\n and timestamp <= $to\n and status NOT in (101,200,201,202,204,206,404,444)\n and masked_uri LIKE (if(empty('$appName'), '%', '%$appName%'))\n\nGROUP BY\n t,\n Back_NAME\nORDER BY t ,Back_NAME \n \n",
        rawQuery="SELECT\n (intDiv(toUInt32(`timestamp`), 300) * 300) * 1000 as t,\n masked_uri AS Back_NAME,\n SUM(upstream_response_time) / Count(*) \nFROM dark_logs_m.apigw_gf\n\nWHERE\n timestamp > 1647601904\n and timestamp <= 1647612704\n and status NOT in (101,200,201,202,204,206,404,444)\n and masked_uri LIKE (if(empty('ivr-alarms-api'), '%', '%ivr-alarms-api%'))\n\nGROUP BY\n t,\n Back_NAME\nORDER BY t ,Back_NAME",
    )
);

{
    sucsess_requests_k8s_count(
        title='Sucsess requests k8s count',
        datasource='Prometheus (bss)',
    ):: sucsess_requests_k8s_count_vars(
        title=title,
        datasource=datasource,
    ),
    bad_requests_k8s_count(
        title='Bad requests k8s count',
        datasource='Prometheus (bss)',
    ):: bad_requests_k8s_count_vars(
        title=title,
        datasource=datasource,
    ),
    sucsess_requests_k8s_duration(
        title='Sucsess requests k8s duration',
        datasource='Prometheus (bss)',
        formatY1='s',
    ):: sucsess_requests_k8s_duration_vars(
        title=title,
        datasource=datasource,
        formatY1=formatY1,
    ),
    bad_requests_k8s_duration(
        title='Bad requests k8s duration',
        datasource='Prometheus (bss)',
        formatY1='s',
    ):: bad_requests_k8s_duration_vars(
        title=title,
        datasource=datasource,
        formatY1=formatY1,
    ),
    sucsess_requests_apigw(
        title='Sucsess requests apigw',
        datasource='dark-ch(fed)',
    ):: sucsess_requests_apigw_vars(
        title=title,
        datasource=datasource,
    ),
    bad_requests_apigw(
        title='Bad requests apigw',
        datasource='dark-ch(fed)',
    ):: bad_requests_apigw_vars(
        title=title,
        datasource=datasource,
    ),
    sucsess_requests_apigw_durations(
        title='Sucsess requests apigw durations',
        datasource='dark-ch(fed)',
        formatY1='s',
    ):: sucsess_requests_apigw_durations_vars(
        title=title,
        datasource=datasource,
        formatY1=formatY1,
    ),
    bad_requests_apigw_durations(
        title='Bad requests apigw durations',
        datasource='dark-ch(fed)',
        formatY1='s',
    ):: bad_requests_apigw_durations_vars(
        title=title,
        datasource=datasource,
        formatY1=formatY1,
    ),
}
