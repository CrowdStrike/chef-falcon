# Testing the Cookbook

This document will be updated as new tests are written.

## Integration Testing

Integration testing is performed by Test Kitchen. Tests should be designed to
ensure that a recipe has accomplished its goal.

By default, we use the Dokken driver (Docker) due to the ease of passing in
environment variables to the containers. In order to use Test Kitchen with this
cookbook, you will need to export the following environment variables:

```bash
export FALCON_CLIENT_ID=<Your API Client ID>
export FALCON_CLIENT_SECRET=<Your API Client Secret>
export FALCON_CLOUD=<Your API Cloud URL (ie api.crowdstrike.com)>
export FALCON_CID=<Your Falcon CID>
```

### Using Dokken

> Refer to the [kitchen.yml](kitchen.yml) for more details

Run the following command to do a full test of all platforms:

```bash
kitchen test # optionally pass -c for parallel runs
```

To run only against Ubuntu and CentOS:

```bash
kitchen test ubuntu|centos
```

### Using Vagrant (coming soon)

> Refer to the [kitchen.vagrant.yml](kitchen.vagrant.yml) for more details.

:exclamation: Until we figure out a clean way to pass ENV variables, this will be
under construction :exclamation:
