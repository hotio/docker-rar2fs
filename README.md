# rar2fs

![Logo](https://raw.githubusercontent.com/hotio/unraid-templates/master/hotio/img/rar2fs.png)  

[![GitHub](https://img.shields.io/badge/source-github-lightgrey)](https://github.com/hotio/docker-rar2fs)
[![Docker Pulls](https://img.shields.io/docker/pulls/hotio/rar2fs)](https://hub.docker.com/r/hotio/rar2fs)
[![Discord](https://img.shields.io/discord/610068305893523457?color=738ad6&label=discord&logo=discord&logoColor=white)](https://discord.gg/3SnkuKp)
[![Upstream](https://img.shields.io/badge/upstream-project-yellow)](https://github.com/hasse69/rar2fs)

## Starting the container

Just the basics to get the container running:

```shell
docker run --rm --name rar2fs -v /<host_folder_config>:/config -v /<host_folder_source>:/source -v /<host_folder_mountpoint>:/mountpoint:shared hotio/rar2fs
```

The environment variables below are all optional, the values you see are the defaults.

```shell
-e PUID=1000
-e PGID=1000
-e UMASK=002
-e TZ="Etc/UTC"
-e ARGS=""
-e SOURCE=/source
-e MOUNTPOINT=/mountpoint
```

## Tags

| Tag      | Description                    | Build Status                                                                                                                                          | Last Updated                                                                                                                                                  |
| ---------|--------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| latest   | The same as `stable`           |                                                                                                                                                       |                                                                                                                                                               |
| stable   | Stable version                 | [![Build Status](https://cloud.drone.io/api/badges/hotio/docker-rar2fs/status.svg?ref=refs/heads/stable)](https://cloud.drone.io/hotio/docker-rar2fs) | [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/hotio/docker-rar2fs/stable)](https://github.com/hotio/docker-rar2fs/commits/stable) |

You can also find tags that reference a commit or version number.

## Using the rar2fs mount on the host or in another container

By using the option `:shared` on your volume `/mountpoint`, you'll be able to access the rar2fs mount by going to the folder on the host. If you add `--volumes-from rar2fs` to another container's run command, you can go to the rar2fs mount from within that container.

## Extra docker privileges

In most cases you will need some or all of the following flags added to your command to get the required docker privileges when using a rar2fs mount.

```shell
--security-opt apparmor:unconfined --cap-add SYS_ADMIN --device /dev/fuse
```

## Executing your own scripts

If you have a need to do additional stuff when the container starts or stops, you can mount your script with `-v /docker/host/my-script.sh:/etc/cont-init.d/99-my-script` to execute your script on container start or `-v /docker/host/my-script.sh:/etc/cont-finish.d/99-my-script` to execute it when the container stops. An example script can be seen below.

```shell
#!/usr/bin/with-contenv bash

echo "Hello, this is me, your script."
```
