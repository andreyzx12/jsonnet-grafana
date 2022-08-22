local grafana = import 'grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local table = import 'libs/table.libsonnet';

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
}