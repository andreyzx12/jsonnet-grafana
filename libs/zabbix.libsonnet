{
  target(
    datasource=null,
    functions=[],
    groupFilter=null,
    hostFilter=null,
    itemFilter=null,
    disableDataAlignment=false,
    showDisabledItems=false,
    skipEmptyValues=false,
    useZabbixValueMapping=false,
  ):: {
    application: {
        filter: ''
    },
    functions: [],
    group: {
        filter: groupFilter
    },
    host: {
        filter: hostFilter
    },
    item: {
        filter: itemFilter 
    },
    options:{
        disableDataAlignment: disableDataAlignment,
        showDisabledItems: showDisabledItems,
        skipEmptyValues: skipEmptyValues,
        useZabbixValueMapping: useZabbixValueMapping
    },
    [if datasource != null then 'datasource']: datasource,
  },
}
