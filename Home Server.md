The following document describes the reasoning for building a home server machine. sometimes called "Home Lab". However I'm not going to use this term as it has been loaded with more concepts and expanded in scope. so I'll refer to what I want as a "Home Server". a machine that works 24/7 and support some use cases.

# Use Cases
This machine should support the following use cases
+ Holds backups for my VPS server. now backups are at 127GB for Who is popular today database over the past 11 days.
  + Auto backup VPS every day
+ Holds family documents and photos. (~57GB)
  + Phones should be able to push new photos to it
  + Family machines should be able to browse and download files and photos
+ Support VPS in administrative tasks
  + Works as logging server
  + Monitoring and alerting
 
# Constraints
+ Silent. spinning fans is not an option
+ Lowest power usage possible
+ Lowest temperature possible
+ Smallest size possible

# Consequences
+ Reduce the VPS server instance, reducing the cost per month. offloading this cost to the hardware cost, maintenance, power consumption.
+ Alerting/Monitoring which doesn't exist right now for my side projects
+ Should help me try some software like grafana, loki.
