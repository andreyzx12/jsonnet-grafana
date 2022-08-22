local grafana = import 'grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local table = import 'libs/table.libsonnet';
local timeseries = import 'libs/timeseries.libsonnet';

local app_container_status_vars(
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
        ]
).addTarget(
    prometheus.target(
        'sum(max_over_time(kube_pod_container_status_running{namespace=~\"$namespace.*\", pod=~\"$appName.*\", cluster=~\"($zone)\", container=\"$appName\"})[10s])by(cluster)',
        format='table',
        intervalFactor=1,
        interval='10s',
        instant=true,
)
);

local istio_proxy_containers_status_vars(
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
        ]
).addTarget(
    prometheus.target(
        'sum(kube_pod_container_status_running{namespace=~\"$namespace.*\", cluster=~\"($zone)\", container=~\"istio-proxy.*\", pod=~\"$appName.*\"})by(cluster)',
        format='table',
        intervalFactor=1,
        interval='10s',
        instant=true,
)
);
local pods_vars(
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
        ]
).addTarget(
    prometheus.target(
        'sum(kube_pod_status_phase{namespace=~\"$namespace.*\", phase=\"Running\", pod=~\"$appName.*\", cluster=~\"($zone)\"}) by(cluster)',
        format='table',
        intervalFactor=1,
        interval='10s',
        instant=true,
    )
);

local cpu_vars(
    title,
    datasource,
) = timeseries.new(
        title=title,
        datasource=datasource,
).addTarget(
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
    );

local ram_vars(
    title,
    datasource,
    unit,
) = timeseries.new(
        title=title,
        datasource=datasource,
        unit=unit,
).addTarget(
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
    );

local app_containers_restarts_vars(
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
        ]
).addTarget(
    prometheus.target(
        'sum(max_over_time(kube_pod_container_status_restarts_total{namespace=~\"$namespace.*\", pod=~\"$appName.*\", cluster=~\"($Prod)\", container=\"$appName\"})[10s])by(cluster)',
        format='table',
        intervalFactor=1,
        interval='10s',
        instant=true,
)
);

local istio_proxy_containers_restarts_vars(
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
        ]
).addTarget(
    prometheus.target(
        'sum(max_over_time(kube_pod_container_status_restarts_total{namespace=~\"$namespace.*\", pod=~\"$appName.*\", cluster=~\"($Prod)\", container=\"istio-proxy\"})[10s])by(cluster)',
        format='table',
        intervalFactor=1,
        interval='10s',
        instant=true,
)
);

{
    app_container_status(
        title='App container status',
        datasource='Prometheus (bss)',
    ):: app_container_status_vars(
        title=title,
        datasource=datasource,
    ),
    istio_proxy_containers_status(
        title='Istio-proxy containers status',
        datasource='Prometheus (bss)',
    ):: istio_proxy_containers_status_vars(
        title=title,
        datasource=datasource,
    ),
    pods(
        title='Pods',
        datasource='Prometheus (bss)',
    ):: pods_vars(
        title=title,
        datasource=datasource,
    ),
    cpu(
        title='CPU',
        datasource='Prometheus (bss)',
    ):: cpu_vars(
        title=title,
        datasource=datasource,
    ),
    ram(
        title='RAM',
        datasource='Prometheus (bss)',
        unit='bytes',
    ):: ram_vars(
        title=title,
        datasource=datasource,
        unit=unit,
    ),
    app_containers_restarts(
        title='App containers restarts',
        datasource='Prometheus (bss)',
    ):: app_containers_restarts_vars(
        title=title,
        datasource=datasource,
    ),
    istio_proxy_containers_restarts(
        title='istio-proxy containers restarts',
        datasource='Prometheus (bss)',
    ):: istio_proxy_containers_restarts_vars(
        title=title,
        datasource=datasource,
    ),
}
