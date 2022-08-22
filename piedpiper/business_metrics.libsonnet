local grafana = import 'grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local table = import 'libs/table.libsonnet';

local vars(
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
                    'Value': 6,
                    'cluster': 1,
                    'metric_name': 3,
                    'parameter': 4,
                    'pod': 2,
                    'status': 5,
                },
            },
        },
    ]
).addTarget(
    prometheus.target(
    'sum(business_metric_gaugevec{status=~\".*\", namespace=\"$namespace\",pod=~\"$appName.*\", cluster=~\"$zone\", metric_name=~\".*\", parameter=~\".*\",type=~\".*\"})by(cluster,pod,metric_name,parameter,status)',
    format='table',
    intervalFactor=1,
    interval='10s',
    instant=true,
)
);

{
    business_metrics(
        title='business metrics gaugevec',
        datasource='Prometheus (bss)',
    ):: vars(
        title=title,
        datasource=datasource,
    ),
}