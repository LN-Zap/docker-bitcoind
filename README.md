# bitcoind for Docker

Docker image that runs bitcoind in a container for easy deployment.

The image contains the latest [bitcoind](https://github.com/bitcoin/bitcoin) daemon.

## Quick Start

1.  Create a `bitcoind-data` volume to persist the bitcoind blockchain data, should exit immediately. The `bitcoind-data` container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):

        docker volume create --name=bitcoind-data
        docker run -v bitcoind-data:/bitcoin --name=bitcoind-node -d \
            -p 8333:8333 \
            -p 127.0.0.1:8332:8332 \
            lnzap/bitcoind

2.  Verify that the container is running and bitcoind node is downloading the blockchain

        $ docker ps
        CONTAINER ID        IMAGE                         COMMAND             CREATED             STATUS              PORTS                                              NAMES
        d0e1076b2dca        lnzap/bitcoind:latest            "bitcoind_oneshot"       2 seconds ago       Up 1 seconds        127.0.0.1:8332->8332/tcp, 0.0.0.0:8333->8333/tcp   bitcoind-node

3.  You can then access the daemon's output thanks to the [docker logs command](https://docs.docker.com/reference/commandline/cli/#logs)

        docker logs -f bitcoind-node

4.  Install optional init scripts for upstart and systemd are in the `init` directory.

## Documentation

- Additional documentation in the [docs folder](docs).
