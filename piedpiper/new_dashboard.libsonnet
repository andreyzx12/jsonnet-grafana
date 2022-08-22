local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local template = grafana.template;
local config = std.parseYaml(importstr "dashboard.yaml");
local business_requests = import 'piedpiper/business_requests.libsonnet';
local business = import 'piedpiper/business_metrics.libsonnet';
local http = import 'piedpiper/standart_metrics.libsonnet';
local infra = import 'piedpiper/infrastructure.libsonnet';
local depend = import 'piedpiper/depend_on_services.libsonnet';
#start block depend on services
local nodeResources = (
    depend.node_resources() + {gridPos:{h: 13,w: 12,x: 0,y: 1,}}
);
local statusClusterPg = (
    depend.status_cluster_pg() + {gridPos:{h: 4,w: 6,x: 12,y: 1,}}
);
local statusClusterApigw = (
    depend.status_cluster_apigw() + {gridPos:{h: 4,w: 6,x: 12,y: 5,}}
);
local statusClusterKeycloak = (
    depend.status_cluster_keycloak() + {gridPos:{h: 4,w: 6,x: 18,y: 5,}}
);
local connectionToDb = (
    depend.connections_to_db() + {gridPos:{h: 4,w: 6,x: 18,y: 2,}}
);
#end block depend on services
#start block Business requests
local sucsessK8sCount = (
    business_requests.sucsess_requests_k8s_count() + {gridPos:{h: 8,w: 12,x: 0,y: 15,}}
);
local badK8sCount = (
    business_requests.bad_requests_k8s_count() + {gridPos:{h: 8,w: 12,x: 12,y: 15,}}
);
local sucsessK8sDuration = (
    business_requests.sucsess_requests_k8s_duration() + {gridPos:{h: 8,w: 12,x: 0,y: 23,}}
);
local badK8sDuration = (
    business_requests.bad_requests_k8s_duration() + {gridPos:{h: 8,w: 12,x: 12,y: 23,}}
);
local sucsessApigwCount = (
    business_requests.sucsess_requests_apigw() + {gridPos:{h: 8,w: 12,x: 0,y: 31,}}
);
local badApigwCount = (
    business_requests.bad_requests_apigw() + {gridPos:{h: 8,w: 12,x: 12,y: 31,}}
);
local sucsessApigwDuration = (
    business_requests.sucsess_requests_apigw_durations() + {gridPos:{h: 8,w: 12,x: 0,y: 39,}}
);
local badApigwDuration = (
    business_requests.bad_requests_apigw_durations() + {gridPos:{h: 8,w: 12,x: 12,y: 39,}}
);
# end block business requests
# start block infrastructure
local appContainerStatus = (
    infra.app_container_status() + {gridPos:{h: 8,w: 4,x: 0,y: 48,}}
);
local istioContainerStatus = (
    infra.istio_proxy_containers_status() + {gridPos:{h: 8,w: 4,x: 4,y: 48,}}
);
local pods = (
    infra.pods() + {gridPos:{h: 8,w: 4,x: 8,y: 48,}}
);
local cpu = (
    infra.cpu() + {gridPos:{h: 16,w: 6,x: 12,y: 48,}}
);
local ram = (
    infra.ram() + {gridPos:{h: 16,w: 6,x: 18,y: 48,}}
);
local appContainerRestarts = (
    infra.app_containers_restarts() + {gridPos:{h: 8,w: 4,x: 0,y: 56,}}
);
local istioContainerRestarts = (
    infra.istio_proxy_containers_restarts() + {gridPos:{h: 8,w: 4,x: 4,y: 56,}}
);
# end block infrastructure
# start block standart metrics
local incomingRequestsDurationHistogram = (
    http.incoming_request_duration_histogram() + {gridPos:{h: 6,w: 12,x: 12,y: 77,}}
);
local dbQueries = (
    http.db_queries() + {gridPos:{h: 6,w: 12,x: 0,y: 77,}}
);
local badIncomingRequestsDuration = (
    http.bad_incoming_requests_duration() + {gridPos:{h: 6,w: 12,x: 12,y: 71,}}
);
local sucsessIncomingRequestsDuration = (
    http.sucsess_incoming_requests_duration() + {gridPos:{h: 6,w: 12,x: 0,y: 71,}}
);
local sucsessIncomingRequestsCount = (
    http.sucsess_incoming_requests_count() + {gridPos:{h: 6,w: 12,x: 0,y: 65,}}
);
local badIncomingRequestsCount = (
    http.bad_incoming_requests_count() + {gridPos:{h: 6,w: 12,x: 12,y: 65,}}
);
# end block standart metrics
# start block business metrics
local businessMetricsApp = (
    business.business_metrics() + {gridPos:{h: 5,w: 12,x: 0,y: 84,}}
);
# end block business metrics

dashboard.new(
  config.AppName,
  editable=true,
  schemaVersion=16,
  tags=['PiedPiper'],
)
.addPanel(
    row.new('Depend On Services'), gridPos={h: 1,w: 24,x: 0,y: 0,}
)

.addPanels([nodeResources,],)
.addPanels([statusClusterPg],)
.addPanels([statusClusterApigw,])
.addPanels([statusClusterKeycloak],)
.addPanels([connectionToDb],)

.addPanel(
    row.new('Business requests'), gridPos={h: 1,w: 24,x: 0,y: 14,}
)

.addPanels([sucsessK8sCount],)
.addPanels([badK8sCount],)
.addPanels([sucsessK8sDuration],)
.addPanels([badK8sDuration],)
.addPanels([sucsessApigwCount],)
.addPanels([badApigwCount],)
.addPanels([sucsessApigwDuration],)
.addPanels([badApigwDuration],)

.addPanel(
    row.new('Infrastructure'), gridPos={h: 1,w: 24,x: 0,y: 47,}
)

.addPanels([appContainerStatus],)
.addPanels([istioContainerStatus],)
.addPanels([pods],)
.addPanels([cpu],)
.addPanels([ram],)
.addPanels([appContainerRestarts],)
.addPanels([istioContainerRestarts],)

.addPanel(
    row.new('Standart app metrics'), gridPos={h: 1,w: 24,x: 0,y: 64,}
)

.addPanels([incomingRequestsDurationHistogram],)
.addPanels([dbQueries],)
.addPanels([badIncomingRequestsDuration],)
.addPanels([sucsessIncomingRequestsDuration],)
.addPanels([sucsessIncomingRequestsCount],)
.addPanels([badIncomingRequestsCount],)

.addPanel(
    row.new('Business app metrics'), gridPos={h: 1,w: 24,x: 0,y: 83,}
)

.addPanels([businessMetricsApp],)

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
