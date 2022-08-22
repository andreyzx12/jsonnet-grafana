{
  new(
    title,
    datasource=null,
    calc='mean',
    description='',
    height=null,
    width=null,
    transparent=null,
    max=100,
    min=0,
    thresholds=[],
    gauge_title=null,
    unit='percent',
    values=false,
    labels=false,
    markers=true,
    displaymode='lcd',
    orientation='auto',
    threshold_mode='absolute',
    mode='continuous-GrYlRd',
    textsize='12',
  ):: {
    [if description != '' then 'description']: description,
    gridPos: {
      h: height,
      w: width
    },
    [if transparent != null then 'transparent']: transparent,
    title: title,
    type: 'bargauge',
    pluginVersion: '6.6.0',
    datasource: datasource,
    options: {
      fieldOptions: {
        calcs: [
          calc,
        ],
        defaults: {
          mappings: [],
          color:{
            mode: mode,
          },
          max: max,
          min: min,
          thresholds: {
            mode: threshold_mode,
            steps: thresholds,
          },
          title: gauge_title,
          unit: unit
        },
        overrides: [],
        values: values,
      },
      displayMode: displaymode,
      orientation: orientation,
      showThresholdLabels: labels,
      showThresholdMarkers: markers,
      text: {
        valueSize: textsize,
      },
    },
    _nextTarget:: 0,
    addTarget(target):: self {
      local nextTarget = super._nextTarget,
      _nextTarget: nextTarget + 1,
      targets+: [target { refId: std.char(std.codepoint('A') + nextTarget) }],
    },
  },

  threshold(
    color,
    value=null
  ):: {
    color: color,
    value: value
  }

}
