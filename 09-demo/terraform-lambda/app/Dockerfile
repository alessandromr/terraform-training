FROM public.ecr.aws/lambda/provided:al2
ARG ARCH=amd64
ARG TERRAFORM_VERSION=1.3.9

RUN yum install -y unzip \
  && curl -fsSL -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip \
  && unzip -d /usr/local/bin /tmp/terraform.zip \
  && rm /tmp/terraform.zip

COPY *.tf ./
COPY entrypoint.sh ./

ENTRYPOINT [ "/bin/bash", "entrypoint.sh" ]