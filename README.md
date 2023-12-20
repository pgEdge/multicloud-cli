# libcloud-cli

A command line interface (cli) for [apache-libcloud](https://libcloud.apache.org) (alc) that works well for working with public
&/or private cloud (hybrid multi-cloud)


## Guiding Priciples

  - make it a friendly CLI that is a pretty thin veneer over the apache-libcloud sdk

  - agnostic field naming across providers such as (metro, location, flavor) instead 
        of (region, avaialability_zone, size)

  - cloud provider specific names will also be provided in the JSON output in case you want to access it that way

  - pure python and KISS

  - start with `compute` support for `ec2`, `equinixmetal`, & `openstack`


## What's next

- support for `projects`

- support for `gcp` and `azure`


