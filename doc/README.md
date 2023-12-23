# multicloud-cli

![banner](img/mcc-banner2.png)

A CLI to Rule the Multi-cloud


## Guiding Principles

  - follow [apache-libcloud](https://libcloud.apache.org) sdk as 
    much as reasonable

  - use agnostic and consistent field naming across providers such as airport,
    metro (instead of 'region' or 'city'), & location (instead of availability_zone )

  - for all supported providers, u can specify the airport code instead of the metro

  - pure python and KISS

  - start with `compute` support for `ec2` & `equinixmetal`


## What's next

- `cluster` definition json file for grouping multi-cloud nodes

- support for `openstack`, `gcp` and `azure`

