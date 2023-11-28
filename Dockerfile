FROM alpine:3.18.4

RUN apk update \
  && apk add curl patch bash make gcc gnupg gpg dirmngr procps musl-dev linux-headers zlib zlib-dev openssl openssl-dev libssl1.1

SHELL ["/bin/bash", "-c"]

# RUN wget -O rvm.zip https://github.com/rvm/rvm/archive/refs/heads/master.zip
COPY rvm.zip /

RUN unzip rvm.zip \
  && cd rvm-master \
  && echo 'export rvm_prefix="$HOME"' > ~/.rvmrc \
  && echo 'export rvm_path="$HOME/.rvm"' >> ~/.rvmrc \
  && ./install --auto-dotfiles --autolibs=0 \
  && cd ../ && rm -rf rvm.zip

ADD ["ruby_patches/io.c.patch", "ruby_patches/isinf.c.patch", "ruby_patches/isnan.c.patch", "/root/.rvm/patches/ruby/2.0.0/"]

RUN source ~/.rvm/scripts/rvm \
  && rvm install ruby-2.0.0 --patches ~/.rvm/patches/ruby/2.0.0/io.c.patch --patches ~/.rvm/patches/ruby/2.0.0/isinf.c.patch --patches ~/.rvm/patches/ruby/2.0.0/isnan.c.patch

ENV PATH="$PATH:/root/.rvm/rubies/ruby-2.0.0-p648/bin/"
