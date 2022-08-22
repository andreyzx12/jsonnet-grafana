{
  target(
    database='',
    dateTimeType='',
    extrapolate=true,
    format='',
    formattedQuery='',
    intervalFactor=null,
    query='',
    rawQuery='',
  ):: {
    dateTimeType: dateTimeType,
    extrapolate: extrapolate,
    format: format,
    formattedQuery: formattedQuery,
    intervalFactor: intervalFactor,
    rawQuery: rawQuery,
    skip_comments: true,
    [if database != null then 'database']: database,
    [if query != null then 'query']: query,
  },
}
