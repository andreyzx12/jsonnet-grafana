{
  new(
    title,
    description=null,
    transparent=false,
    datasource=null,
    allValues=false,
    valueLimit=null,
    reducerFunction='mean',
    fields='',
    orientation='auto',
    colorMode='value',
    graphMode='area',
    textMode='auto',
    justifyMode='auto',
    unit='none',
    min=null,
    max=null,
    decimals=null,
    displayName=null,
    noValue=null,
    thresholdsMode='absolute',
    timeFrom=null,
    repeat=null,
    repeatDirection='h',
    maxPerRow=null,
    pluginVersion='7',
    colorThresholds='red',
    valueThresholds='0',
    colorThresholds1='green',
    valueThresholds1='1',
  ):: {

    type: 'stat',
    title: title,
    [if description != null then 'description']: description,
    transparent: transparent,
    datasource: datasource,
    targets: [],
    links: [],
    [if repeat != null then 'repeat']: repeat,
    [if repeat != null then 'repeatDirection']: repeatDirection,
    [if timeFrom != null then 'timeFrom']: timeFrom,
    [if repeat != null then 'maxPerRow']: maxPerRow,

    // targets
    _nextTarget:: 0,
    addTarget(target):: self {
      local nextTarget = super._nextTarget,
      _nextTarget: nextTarget + 1,
      targets+: [target { refId: std.char(std.codepoint('A') + nextTarget) }],
    },
    addTargets(targets):: std.foldl(function(p, t) p.addTarget(t), targets, self),

    // links
    addLink(link):: self {
      links+: [link],
    },
    addLinks(links):: std.foldl(function(p, l) p.addLink(l), links, self),

    pluginVersion: pluginVersion,
  } + (

    if pluginVersion >= '7' then {
      options: {
        reduceOptions: {
          values: allValues,
          [if allValues && valueLimit != null then 'limit']: valueLimit,
          calcs: [
            reducerFunction,
          ],
          fields: fields,
        },
        orientation: orientation,
        colorMode: colorMode,
        graphMode: graphMode,
        justifyMode: justifyMode,
        textMode: textMode,
      },
      fieldConfig: {
        defaults: {
          unit: unit,
          [if min != null then 'min']: min,
          [if max != null then 'max']: max,
          [if decimals != null then 'decimals']: decimals,
          [if displayName != null then 'displayName']: displayName,
          [if noValue != null then 'noValue']: noValue,
          thresholds: {
            mode: thresholdsMode,
            steps: [
              {
                color: colorThresholds,
                value: valueThresholds,
              },
              {
                color: colorThresholds1,
                value: valueThresholds1,
              },
            ],
          },
          mappings: [],
          links: [],
        },
      },

      // thresholds
      addThreshold(step):: self {
        fieldConfig+: { defaults+: { thresholds+: { steps+: [step] } } },
      },

      // mappings
      _nextMapping:: 0,
      addMapping(mapping):: self {
        local nextMapping = super._nextMapping,
        _nextMapping: nextMapping + 1,
        fieldConfig+: { defaults+: { mappings+: [mapping { id: nextMapping }] } },
      },

      // data links
      addDataLink(link):: self {
        fieldConfig+: { defaults+: { links+: [link] } },
      },

      // Overrides
      addOverride(
        matcher=null,
        properties=null,
      ):: self {
        fieldConfig+: {
          overrides+: [
            {
              [if matcher != null then 'matcher']: matcher,
              [if properties != null then 'properties']: properties,
            },
          ],
        },
      },
      addOverrides(overrides):: std.foldl(function(p, o) p.addOverride(o.matcher, o.properties), overrides, self),
    } else {
      options: {
        fieldOptions: {
          values: allValues,
          [if allValues && valueLimit != null then 'limit']: valueLimit,
          calcs: [
            reducerFunction,
          ],
          fields: fields,
          defaults: {
            unit: unit,
            [if min != null then 'min']: min,
            [if max != null then 'max']: max,
            [if decimals != null then 'decimals']: decimals,
            [if displayName != null then 'displayName']: displayName,
            [if noValue != null then 'noValue']: noValue,
            thresholds: {
              mode: thresholdsMode,
              steps: [],
            },
            mappings: [],
            links: [],
          },
        },
        orientation: orientation,
        colorMode: colorMode,
        graphMode: graphMode,
        justifyMode: justifyMode,
      },

      // thresholds
      addThreshold(step):: self {
        options+: { fieldOptions+: { defaults+: { thresholds+: { steps+: [step] } } } },
      },

      // mappings
      _nextMapping:: 0,
      addMapping(mapping):: self {
        local nextMapping = super._nextMapping,
        _nextMapping: nextMapping + 1,
        options+: { fieldOptions+: { defaults+: { mappings+: [mapping { id: nextMapping }] } } },
      },

      // data links
      addDataLink(link):: self {
        options+: { fieldOptions+: { defaults+: { links+: [link] } } },
      },
    }

  ) + {
    addThresholds(steps):: std.foldl(function(p, s) p.addThreshold(s), steps, self),
    addMappings(mappings):: std.foldl(function(p, m) p.addMapping(m), mappings, self),
    addDataLinks(links):: std.foldl(function(p, l) p.addDataLink(l), links, self),
  },
}
