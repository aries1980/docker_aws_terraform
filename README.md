[1]: https://www.terraform.io/ "Hashicorp terraform"
[2]: http://docs.aws.amazon.com/cli/latest/reference "use aws apis from cmd line"
[3]: https://github.com/fugue/credstash "credstash - store and retrieve secrets in aws"
[4]: https://github.com/opsgang/alpine_build_scripts/blob/master/install_essentials.sh "common GNU tools useful for automation"
# docker\_aws\_terraform

_... alpine container with common tools to use Hashicorp's terraform on or for aws_

## featuring ...

* [hashicorp's terraform] [1]

* [aws cli] [2]

* [credstash] [3] (for managing secrets in aws)

* bash, curl, git, make, jq, openssh client [and friends] [4]

## building

[![Run Status](https://api.shippable.com/projects/589913a86ee43c0f00b47cb6/badge?branch=master)](https://app.shippable.com/projects/589913a86ee43c0f00b47cb6)

**tags on master are built at shippable.com**

```bash
git clone https://github.com/opsgang/docker_aws_terraform.git
cd docker_aws_terraform
git clone https://github.com/opsgang/alpine_build_scripts
./build.sh # adds custom labels to image
```

## installing

```bash
docker pull opsgang/aws_terraform:stable # or use the tag you prefer
```

## running

```bash
# run /path/to/script.sh which calls terraform, aws cli, curl, jq blah ...
docker run --rm -i -v /path/to/script.sh:/script.sh:ro opsgang/aws_terraform:stable /script.sh
```

```bash
# make my aws creds available and run /some/python/script.py
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
docker run -it opsgang/aws_terraform:stable /bin/bash
```
