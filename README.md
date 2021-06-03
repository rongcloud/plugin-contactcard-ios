
`该仓库停止更新，最后版本为 5.1.0`，新仓库迁移至 [融云 IM UI SDK 集合](https://github.com/rongcloud/ios-ui-sdk-set)


## 说明一：4.* 及其以下版本

请切换到 `master` 分支，使用对应版本的 tag

## 说明二：5.0.0~5.1.0 版本

> framework 方式集成

如果使用了 IMKit framework，则需要使用名片 framework，可以使用该仓库编译出 framework ，建议您切换到 `master` 分支并编译名片 framework

注：`名片 framework 方式集成 5.1.0 以后不再支持，具体请参照说明三`

> 源码方式集成

从 5.0.0 开始 IMKit 支持源码集成，如果您已将名片源码直接放入 APP 项目，请把 APP 项目名片源码删除，并参考 [融云 IM UI SDK 集合](https://github.com/rongcloud/ios-ui-sdk-set) 将 IMKit 和名片全部转成源码

## 说明三：5.1.0 及其以上版本

5.1.0 及其以上版本只支持源码方式集成

> 源码方式集成

请参考 [融云 IM UI SDK 集合](https://github.com/rongcloud/ios-ui-sdk-set) 集成 IMKit 源码和 名片源码

## 其他说明

**1.名片和 IMKit 要么都是源码，要么都是 framework；不能出现混用的情况：如名片功能使用 framework，而 IMKit 使用源码的方式**

**2.该仓库不再维护，最终版本为 5.1.0**


