{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${db_instance_identifier}", { "stat": "Average" } ]
        ],
        "period": 300,
        "yAxis": { "left": { "min": 0, "max": 100 } },
        "title": "RDS CPU Utilization (%Average)",
        "region": "${region}"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "${db_instance_identifier}", { "stat": "Average" } ]
        ],
        "period": 300,
        "title": "RDS Freeable Memory (Bytes)",
        "region": "${region}"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "${db_instance_identifier}", { "stat": "Average" } ],
          [ ".", "ReadIOPS", ".", ".", { "stat": "Sum" } ],
          [ ".", "WriteIOPS", ".", ".", { "stat": "Sum" } ]
        ],
        "period": 300,
        "title": "RDS Connections / IOPS",
        "region": "${region}"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${alb_name}", { "stat": "Sum" } ]
        ],
        "period": 300,
        "title": "ALB Request Count",
        "region": "${region}"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 12,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", "${alb_name}", { "stat": "Sum" } ],
          [ "AWS/ApplicationELB", "HTTPCode_Target_4XX_Count", ".", ".", { "stat": "Sum" } ]
        ],
        "period": 300,
        "title": "ALB 5XX / 4XX Errors",
        "region": "${region}"
      }
    },
    {
      "type": "metric",
      "x": 8,
      "y": 12,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", "${alb_name}", { "stat": "Average" } ]
        ],
        "period": 300,
        "title": "ALB Target Response Time (Avg)",
        "region": "${region}"
      }
    },
    {
      "type": "metric",
      "x": 16,
      "y": 12,
      "width": 8,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", "${asg_name}", { "stat": "Average" } ],
          [ ".", "GroupDesiredCapacity", ".", ".", { "stat": "Average" } ]
        ],
        "period": 300,
        "title": "ASG InService / Desired Instances",
        "region": "${region}"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 18,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/RDS", "ReadLatency", "DBInstanceIdentifier", "${db_instance_identifier}", { "stat": "Average" } ],
          [ ".", "WriteLatency", ".", ".", { "stat": "Average" } ]
        ],
        "period": 300,
        "title": "RDS Read/Write Latency (ms)",
        "region": "${region}"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 18,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/ApplicationELB", "HealthyHostCount", "LoadBalancer", "${alb_name}", { "stat": "Average" } ],
          [ ".", "UnHealthyHostCount", ".", ".", { "stat": "Average" } ]
        ],
        "period": 300,
        "title": "ALB Healthy / Unhealthy Hosts",
        "region": "${region}"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 24,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/RDS", "NetworkReceiveThroughput", "DBInstanceIdentifier", "${db_instance_identifier}", { "stat": "Average" } ],
          [ ".", "NetworkTransmitThroughput", ".", ".", { "stat": "Average" } ]
        ],
        "period": 300,
        "title": "RDS Network Throughput",
        "region": "${region}"
      }
    }
  ]
}
