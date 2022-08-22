{
  new(
    title,
    datasource=null,
    mappings=[],
    transformations=[],
    unit='',
  ):: {
    type: 'timeseries',
    title: title,
    [if datasource != null then 'datasource']: datasource,
    fieldConfig: {
        defaults: {
            color: {
                mode: 'palette-classic'
            },
            custom: {
              axisLabel: '',
              axisPlacement: '',
              barAligment: 1,
              drawStyle: 'line',
              fillOpacity: 0,
              gradientMode: 'none',
            },
            mappings: mappings,
            thresholds: {},
            unit: unit,
        overrides:[],
        },
    },
    targets: [],
    transformations: transformations,
    _nextTarget:: 0,
    addTarget(target):: self {
      local nextTarget = super._nextTarget,
      _nextTarget: nextTarget + 1,
      targets+: [target { refId: std.char(std.codepoint('A') + nextTarget) }],
    },
    addTargets(targets):: std.foldl(function(p, t) p.addTarget(t), targets, self),
    addColumn(field, style):: self {
      local style_ = style { pattern: field },
      local column_ = { text: field, value: field },
      styles+: [style_],
      columns+: [column_],
    },
    hideColumn(field):: self {
      styles+: [{
        alias: field,
        pattern: field,
        type: 'hidden',
      }],
    },
  },
}
