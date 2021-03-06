# vim: et sr sw=4 ts=4 smartindent syntax=dockerfile:
FROM opsgang/aws_env:stable

LABEL \
      name="opsgang/aws_terraform" \
      description="common tools to run terraform in or for aws"

ENV TERRAFORM_VERSION=0.11.3 \
    PREINSTALLED_PLUGINS=/tf_plugins_cache_dir \
    PROVIDER_VERSIONS=/provider.versions

COPY alpine_build_scripts/* /alpine_build_scripts/
COPY assets /var/tmp/assets

RUN cp -a /var/tmp/assets/. / \
    && chmod a+x /bootstrap.sh /alpine_build_scripts/* \
    && sh /alpine_build_scripts/install_terraform.sh \
    && bash /alpine_build_scripts/install_tf_providers.sh \
    && cp -a /alpine_build_scripts/install_terraform.sh \
        /usr/local/bin/terraform_version \
    && cp -a /alpine_build_scripts/install_tf_providers.sh \
        /usr/local/bin/terraform_providers \
    && sh /alpine_build_scripts/install_essentials.sh \
    && rm -rf /var/cache/apk/* /var/tmp/assets /alpine_build_scripts 2>/dev/null

ENTRYPOINT ["/bootstrap.sh"]

# built with additional labels:
#
# version
# opsgang.awscli_version
# opsgang.credstash_version
# opsgang.jq_version
# opsgang.terraform_version
# opsgang.terraform_provider_aws
# opsgang.terraform_provider_fastly
#
# opsgang.build_git_uri
# opsgang.build_git_sha
# opsgang.build_git_branch
# opsgang.build_git_tag
# opsgang.built_by
#
