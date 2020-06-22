RongCloud ContactCard Framework
融云名片framework的使用

说明：
RongContactCard.framework是IMKit的扩展模块，需要依赖于`IMKit`，只支持单聊，群聊

编译参数：`-ObjC`


具体使用：

1，将RongContactCard.framework添加到项目中

2，添加编译参数

3，设置RCContactCardKit的RCCCContactsDataSource代理和RCCCGroupDataSource代理，并实现其代理方法(具体可以参考sealtalk源码中`AppDelegate中的代理设置`和`RCDRCIMDataSource的代理实现`)，建议在单例类中实现代理方法，保证整个app的声明周期内都能正常的使用名片功能

4，名片消息的点击事件处理，需要在RCConversationviewController的子类中重写

```
- (void)didTapMessageCell:(RCMessageModel *)model
```
方法，并对model里面的消息体进行判断处理
例如：

```
- (void)didTapMessageCell:(RCMessageModel *)model {
  [super didTapMessageCell:model];
  if ([model.content isKindOfClass:[RCContactCardMessage class]]) {
    //do something
  }
}
```


`常见问题：`
名片消息的头像为默认的蓝色头像，或者名片消息的用户名称为user<****>的样式:

先检查一下消息体内部的数据是不是有效的;
另外调用RCIM的getUserInfoCache方法从SDK缓存中获取该用户的信息，看看SDK内部缓存中的该用户信息是不是有效的