local grafana = import 'grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local table = import 'libs/table.libsonnet';
local timeseries = import 'libs/timeseries.libsonnet';

local sucsess_incoming_requests_count_vars(
    title,
    datasource,
) = timeseries.new(
        title=title,
        datasource=datasource,
).addTarget(
    prometheus.target(
        'sum(http_incoming_request_count{status=~\"2.*\", namespace=\"$namespace\", uri!~\".*/manage.*\", pod=~\"$appName.*\", cluster=~\"$zone\", method=~\".*\",pod=~\"$appName.*\"})by(cluster,method,status,uri,pod)',
        format='time_series',
        instant=false,
        intervalFactor=1,
    )
);

local bad_incoming_requests_count_vars(
    title,
    datasource,
) = timeseries.new(
        title=title,
        datasource=datasource,
).addTarget(
    prometheus.target(
        'sum(http_incoming_request_count{status=~\"(4.*|5.*)\", namespace=\"$namespace\", uri!~\".*/manage.*\", pod=~\"$appName.*\", cluster=~\"$zone\", method=~\".*\",pod=~\"$appName.*\"})by(cluster,method,status,uri,pod)',
        format='time_series',
        instant=false,
        intervalFactor=1,
    )
);

local sucsess_incoming_requests_duration_vars(
    title,
    datasource,
) = timeseries.new(
        title=title,
        datasource=datasource,
).addTarget(
    prometheus.target(
        'sum(http_incoming_request_duration{status=~\"2.*\", namespace=\"$namespace\", uri!~\".*/manage.*\", pod=~\"$appName.*\", cluster=~\"$zone\", method=~\".*\",pod=~\"$appName.*\"})by(cluster,method,status,uri,pod)',
        format='time_series',
        instant=false,
        intervalFactor=1,
    )
);

local bad_incoming_requests_duration_vars(
    title,
    datasource,
) = timeseries.new(
        title=title,
        datasource=datasource,
).addTarget(
    prometheus.target(
        'sum(http_incoming_request_duration{status=~\"(4.*|5.*)\", namespace=\"$namespace\", uri!~\".*/manage.*\", pod=~\"$appName.*\", cluster=~\"$zone\", method=~\".*\",pod=~\"$appName.*\"})by(cluster,method,status,uri,pod)',
        format='time_series',
        instant=false,
        intervalFactor=1,
    )
);

local db_queries_vars(
    title,
    datasource,
) = table.new(
        title=title,
        datasource=datasource,
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
        ]
).addTarget(
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
);

local duration_histogram_vars(
    title,
    datasource,
) = table.new(
        title=title,
        datasource=datasource,
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
        ]
).addTarget(
    prometheus.target(
        'sum(http_incoming_request_duration_histogram_bucket{status=~\".*\", namespace=\"$namespace\", uri!~\".*/manage.*\", pod=~\"$appName.*\", cluster=~\"$zone\", method=~\".*\", le=~\".*\"})by(cluster,uri,status,le,pod,method)',
        format='table',
        intervalFactor=1,
        interval='10s',
        instant=true,
)
);

{
    incoming_request_duration_histogram(
        title='http incoming requests histogram',
        datasource='Prometheus (bss)',
    ):: duration_histogram_vars(
            title=title,
            datasource=datasource,
    ),
    db_queries(
        title='db queries',
        datasource='Prometheus (bss)',
    ):: db_queries_vars(
            title=title,
            datasource=datasource,
    ),
    bad_incoming_requests_duration(
        title='Bad incoming requests duration',
        datasource='Prometheus (bss)',
    ):: bad_incoming_requests_duration_vars(
            title=title,
            datasource=datasource,
    ),
    sucsess_incoming_requests_duration(
        title='Bad incoming requests duration',
        datasource='Prometheus (bss)',
    ):: sucsess_incoming_requests_duration_vars(
            title=title,
            datasource=datasource,
    ),
    sucsess_incoming_requests_count(
        title='Bad incoming requests duration',
        datasource='Prometheus (bss)',
    ):: sucsess_incoming_requests_count_vars(
            title=title,
            datasource=datasource,
    ),
    bad_incoming_requests_count(
        title='Bad incoming requests duration',
        datasource='Prometheus (bss)',
    ):: bad_incoming_requests_count_vars(
            title=title,
            datasource=datasource,
    )
}
