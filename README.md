# 支持 RDP 的中文桌面容器

Debian + Xfce，主要面向轻量级用途，如管理文件、浏览网页。

> 对标 [linuxserver](https://github.com/linuxserver) 和 [kasmweb](https://github.com/kasmtech) 这两个使用 VNC 的。可代替他们的核心桌面和浏览网页（Firefox）等容器镜像，不知道为什么他们的镜像那么大。

## 镜像标签

- `latest`  
中文 Xfce 桌面，包含 Firefox (ESR)
- `linuxqq`  
`latest` + QQ

> ⚠️ 运行该桌面容器请保证至少有 300 MB 以上的可用内存，使用 Firefox 或 QQ 请保证至少有 1 GB 以上的可用内存。

> ⚠️ QQ 等 Electron/Chromium 应用，由于 Docker 的 user namespace 支持较差，需要将 QQ 的 `.desktop` 文件中启动命令后加上 `--no-sandbox`，或者在你新建容器时加上 `--privileged` 选项（不推荐）。Podman 没有问题，用户可直接使用。

## 用法样例

两个可定制的环境变量：

- `RDP_USER`  
RDP 的登陆用户，默认为 `user`
- `RDP_PASSEORD`  
RDP 的登陆密码，默认为 `password`

### 样例 1：默认用户

使用 `user` 用户登陆，密码是 `password`，端口为 3389。
> ⚠️ 建议仅供测试使用。

```sh
docker run -p 3389:3389 wcbing/remote-desktop:latest
```

### 样例2：自定义用户

使用 `test` 用户登陆，密码是 `test`，端口为 43389。

```sh
docker run -d -p 43389:3389 \
    -e RDP_USER=test \
    -e RDP_PASSWORD=test \
    --name remote-desktop \
    wcbing/remote-desktop:latest
```

### 样例3：自定义用户，挂载本地目录

使用 `test` 用户登陆，密码是 `test`，端口为 43389，挂载 `test` 用户主目录。
> ⚠️ 挂载敏感目录时请小心。

```sh
docker run -d -p 43389:3389 \
    -e RDP_USER=test \
    -e RDP_PASSWORD=test \
    -v /home/test/:/home/test/ \
    --name remote-desktop \
    wcbing/remote-desktop:latest
```

### 样例4：使用 compose.yaml

参考 `compose.yaml`，使用 compose 工具管理。
