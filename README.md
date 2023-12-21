# multicloud-cli

![banner](img/mcc-banner2.png)

Rule the Multi-cloud with this CLI over [apache-libcloud](https://libcloud.apache.org)


## Guiding Principles

  - this CLI is a pretty thin veneer over the apache-libcloud sdk

  - use agnostic and consistent field naming across providers such as (metro, location, flavor) instead 
        of (region, avaialability_zone, size)

  - pure python and KISS

  - start with `compute` support for `ec2` & `equinixmetal`


## What's next

- support for `projects` that allow us to define multi-cloud connections in our ~/.libcloud.conf

- a simple `cluster` definition json file that allows us to name & group multi-cloud nodes in a `project`

- add support for `openstack`, `gcp` and `azure`

