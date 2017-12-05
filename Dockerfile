FROM haskell:8

# install some missing packages
RUN apt-get update && apt-get install -y make xz-utils

# make an unprivileged user
RUN adduser --disabled-password --gecos stack stack

# temporarily make root own the stack home folder
RUN chown -R root:root /home/stack

# enable stack tab-completion in bash
RUN echo 'eval "$(stack --bash-completion-script stack)"' >> /home/stack/.bashrc

# choose a project directory
RUN mkdir /home/stack/app
WORKDIR /home/stack/app

# override the stack root
ENV STACK_ROOT="/home/stack/.stack"

# install ghc
COPY stack.yaml .
RUN stack setup

# build dependencies
COPY *.cabal .
RUN stack build --only-dependencies --test --haddock --bench

# build the app
COPY . .
RUN stack build

# return ownership to stack
RUN chown -R stack:stack /home/stack
USER stack

CMD bash
