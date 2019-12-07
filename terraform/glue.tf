resource "aws_glue_catalog_database" "webperf-by-codebuild" {
  name = "webperf_by_codebuild_${random_id.webperf.hex}"
}

resource "aws_glue_catalog_table" "webperf-by-codebuild" {
  name          = "lighthouse"
  database_name = aws_glue_catalog_database.webperf-by-codebuild.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    classification = "json"
  }

  partition_keys {
    name = "domain"
    type = "string"
  }

  partition_keys {
    name = "device"
    type = "string"
  }

  partition_keys {
    name = "category"
    type = "string"
  }

  partition_keys {
    name = "year"
    type = "string"
  }

  partition_keys {
    name = "month"
    type = "string"
  }

  partition_keys {
    name = "day"
    type = "string"
  }

  partition_keys {
    name = "hour"
    type = "string"
  }

  partition_keys {
    name = "minute"
    type = "string"
  }

  storage_descriptor {
    columns {
      name = "useragent"
      type = "string"
    }

    columns {
      name = "environment"
      type = "struct<networkUserAgent:string,hostUserAgent:string,benchmarkIndex:int>"
    }

    columns {
      name = "lighthouseversion"
      type = "string"
    }

    columns {
      name = "fetchtime"
      type = "string"
    }

    columns {
      name = "requestedurl"
      type = "string"
    }

    columns {
      name = "finalurl"
      type = "string"
    }

    columns {
      name = "runwarnings"
      type = "array<string>"
    }

    columns {
      name = "configsettings"
      type = "struct<output:array<string>,maxWaitForFcp:int,maxWaitForLoad:int,throttlingMethod:string,throttling:struct<rttMs:int,throughputKbps:double,requestLatencyMs:double,downloadThroughputKbps:double,uploadThroughputKbps:int,cpuSlowdownMultiplier:int>,auditMode:boolean,gatherMode:boolean,disableStorageReset:boolean,emulatedFormFactor:string,channel:string,budgets:string,locale:string,blockedUrlPatterns:string,additionalTraceCategories:string,extraHeaders:string,precomputedLanternData:string,onlyAudits:string,onlyCategories:string,skipAudits:string>"
    }

    columns {
      name = "categories"
      type = "struct<performance:struct<title:string,auditRefs:array<struct<id:string,weight:int,group:string>>,id:string,score:double>,accessibility:struct<title:string,description:string,manualDescription:string,auditRefs:array<struct<id:string,weight:int,group:string>>,id:string,score:double>,best-practices:struct<title:string,auditRefs:array<struct<id:string,weight:int>>,id:string,score:double>,seo:struct<title:string,description:string,manualDescription:string,auditRefs:array<struct<id:string,weight:int,group:string>>,id:string,score:double>,pwa:struct<title:string,description:string,manualDescription:string,auditRefs:array<struct<id:string,weight:int,group:string>>,id:string,score:double>>"
    }

    columns {
      name = "categorygroups"
      type = "struct<metrics:struct<title:string>,load-opportunities:struct<title:string,description:string>,budgets:struct<title:string,description:string>,diagnostics:struct<title:string,description:string>,pwa-fast-reliable:struct<title:string>,pwa-installable:struct<title:string>,pwa-optimized:struct<title:string>,a11y-best-practices:struct<title:string,description:string>,a11y-color-contrast:struct<title:string,description:string>,a11y-names-labels:struct<title:string,description:string>,a11y-navigation:struct<title:string,description:string>,a11y-aria:struct<title:string,description:string>,a11y-language:struct<title:string,description:string>,a11y-audio-video:struct<title:string,description:string>,a11y-tables-lists:struct<title:string,description:string>,seo-mobile:struct<title:string,description:string>,seo-content:struct<title:string,description:string>,seo-crawl:struct<title:string,description:string>>"
    }

    columns {
      name = "timing"
      type = "struct<entries:array<struct<startTime:double,name:string,duration:double,entryType:string>>,total:double>"
    }

    columns {
      name = "stackpacks"
      type = "array<string>"
    }

    columns {
      name = "metrics"
      type = "struct<id:string,title:string,description:string,score:string,scoreDisplayMode:string,numericValue:double,details:struct<type:string,items:array<struct<firstContentfulPaint:int,firstMeaningfulPaint:int,firstCPUIdle:int,interactive:int,speedIndex:int,estimatedInputLatency:int,totalBlockingTime:int,observedNavigationStart:int,observedNavigationStartTs:int,observedFirstPaint:int,observedFirstPaintTs:int,observedFirstContentfulPaint:int,observedFirstContentfulPaintTs:int,observedFirstMeaningfulPaint:int,observedFirstMeaningfulPaintTs:int,observedTraceEnd:int,observedTraceEndTs:int,observedLoad:int,observedLoadTs:int,observedDomContentLoaded:int,observedDomContentLoadedTs:int,observedFirstVisualChange:int,observedFirstVisualChangeTs:int,observedLastVisualChange:int,observedLastVisualChangeTs:int,observedSpeedIndex:int,observedSpeedIndexTs:int,lcpInvalidated:boolean>>>>"
    }

    compressed        = "false"
    input_format      = "org.apache.hadoop.mapred.TextInputFormat"
    location          = "s3://${aws_s3_bucket.webperf-by-codebuild.bucket}/json/"
    number_of_buckets = "-1"
    output_format     = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      parameters = {
        paths = "categories,categoryGroups,configSettings,environment,fetchTime,finalUrl,lighthouseVersion,metrics,requestedUrl,runWarnings,stackPacks,timing,userAgent"
      }

      name                  = "OrcSerDe"
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    parameters = {
      classification = "json"
    }
  }
}
