[1]: https://www.terraform.io/ "Hashicorp terraform"
[2]: http://docs.aws.amazon.com/cli/latest/reference "use aws apis from cmd line"
[3]: https://github.com/fugue/credstash "credstash - store and retrieve secrets in aws"
[4]: https://github.com/opsgang/alpine_build_scripts/blob/master/install_essentials.sh "common GNU tools useful for automation"
# docker\_aws\_terraform

_... alpine container with common tools to use Hashicorp's terraform on or for aws_

> For terraform >=0.10.0, this image also supports a plugins cache dir
> and is preinstalled with some popular ones to reduce download dependencies
> at run-time.

## featuring ...

* [hashicorp's terraform] [1]

* [aws cli] [2]

* [credstash] [3] (for managing secrets in aws)

* bash, curl, git, make, jq, openssh client [and friends] [4]

## docker tags

[![Run Status](https://api.shippable.com/projects/589913a86ee43c0f00b47cb6/badge?branch=master)](https://app.shippable.com/projects/589913a86ee43c0f00b47cb6)

**tags on master are built at shippable.com and available from dockerhub**

* terraform-_terraform\_version_ e.g. terraform-0.9.4
    - for your own sake, this is the safest form to use.

* terraform-_terraform\_minor\_version_ e.g. terraform-0.10
    - will pull you the latest 0.10.x that we've built.

* _github tag_ - reference versions for opsgang peeps.

* _build timestamp_ - distinct for each image we've successfully pushed.
    - Of no use to anyone else.

Newer versions will also include more recent versions of alpine and tools.

## building

```bash
git clone https://github.com/opsgang/docker_aws_terraform.git
cd docker_aws_terraform
git clone https://github.com/opsgang/alpine_build_scripts
./build.sh # adds custom labels to image
./test.sh
```

## installing

```bash
docker pull opsgang/aws_terraform:stable # or use the tag you prefer
```

## running

```bash
# To use terraform >0.11.0 with preinstalled plugins cache dir
# against your own terraform (in /my/tf/dir)
#
docker run -i --rm -v /my/tf/dir:/workspace -w /workspace \
    opsgang/aws_terraform:stable <some cmds to run>

# To use a plugins cache dir on the host (if terraform version >=0.10.7)
# mount it to /tf_plugins_cache_dir and set TF_PLUGIN_CACHE_DIR var:
#
docker run -i --rm -v /my/tf/dir:/workspace -w /workspace \
    -v /my/cache/dir:/tf_plugins_cache_dir \
    -e TF_PLUGIN_CACHE_DIR=/tf_plugins_cache_dir \
    opsgang/aws_terraform:stable <some cmds to run>
```

```bash
# To use a version of terraform not built in to an available opsgang container:
#
# Set env var TERRAFORM_VERSION, and the container will install and use this version.
# e.g. to use 0.9.8
#
docker run --rm -e TERRAFORM_VERSION=0.9.8 -i opsgang/aws_terraform:stable <some cmds to run>
```

```bash
# To run /path/to/script.sh which calls terraform, aws cli, curl, jq blah ...
docker run --rm -i -v /path/to/script.sh:/script.sh:ro opsgang/aws_terraform:stable /script.sh
```

```bash
# To make my aws creds available and run /some/python/script.py
export AWS_ACCESS_KEY_ID="i'll-never-tell" # replace glibness with your access key
export AWS_SECRET_ACCESS_KEY="that's-for-me-to-know" # amend as necessary

docker run --rm -i                      \ # ... run interactive to see stdout / stderr
    -v /some/python/script.py:/my.py:ro \ # ... assume the file is executable
    --env AWS_ACCESS_KEY_ID             \ # ... will read it from your env
    --env AWS_SECRET_ACCESS_KEY         \ # ... will read it from your env
    --env AWS_DEFAULT_REGION=eu-west-2  \ # ... adjust geography to taste
    opsgang/aws_terraform:stable /my.py      # script can access these env vars
```

```bash
# let me treat the container like a dev workspace and try stuff out.
# Oh look! vim is preinstalled. How cool! And gratuitous.
docker run -it --name my_workspace opsgang/aws_terraform:stable /bin/bash
```
