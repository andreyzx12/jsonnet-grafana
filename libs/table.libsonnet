{
  new(
    title,
    description=null,
    span=null,
    min_span=null,
    height=null,
    width=null,
    datasource=null,
    mappings=[],
    transform=null,
    transformations=[],
    transparent=false,
    sort=null,
  ):: {
    type: 'table',
    title: title,
    [if span != null then 'span']: span,
    [if min_span != null then 'minSpan']: min_span,
    gridPos: {
      w: width,
      h: height,
    },
    [if height != null then 'height']: height,
    datasource: datasource,
    fieldConfig: {
        defaults: {
            color: {
                mode: 'fixed'
            },
            custom: {
                align: 'left',
                displayMode: 'color-background'
            },
            mappings: mappings,
            thresholds: {},
        overrides:[],
        },
    },
    pluginVersion: '8.1.5',
    targets: [],
    transformations: transformations,
    [if sort != null then 'sort']: sort,
    [if description != null then 'description']: description,
    [if transform != null then 'transform']: transform,
    [if transparent == true then 'transparent']: transparent,
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
