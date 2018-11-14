# v2ex demo

A Flutter demo project for V2EX.

## 已知问题

- 详情页内容渲染是通过 `flutter_html_view` 进行渲染，但 `@someone` 解析生成的 `href` 是没有 `host` 的，所以 `Could not launch xxx`。在 GitHub master 最新的提交中，增加了 `baseURL` 选项（尽管是针对图片设置的，对 `a` 标签没有处理），但最新的 0.5.8 并没有包含对应代码。于是通过 git 方式添加该依赖，但 `flutter_html_view` 的 `pubspec.yaml` 中将 `video_player` 注释了导致无法编译通过。

## Todo

### 页面

- [x] 列表页
- [x] 帖子详情页

  - [x] 解析 markdown 或者 html(flutter_html_view 不支持拦截请求，没有 host 的 href 无法吊起浏览器)
  - [x] 上滑加载更多回复（接口返回了所有回复，不需要额外实现）
  - [x] 样式调整，保证内容完整显示

- [x] 关于页面（通过 drawer 进入）

### 其他

- [x] 路由携带参数切换
- [x] 切换 Tab
- [ ] <del>登录（回帖、发帖、签到等）</del>
- [x] drawer
- [ ] <del>切换分区</del>(官方提供的 API 只能加载每个分区前10个主题，没有分页的接口)
- [ ] time format
- [ ] 主题列表抽出，为未来加载分区主题作准备
- [ ] 图片预览 gallery
- [ ] 链接跳转 webview

## Resource

- [JSON to Dart](https://javiercbk.github.io/json_to_dart/)：转换 JSON 生成 Dart Model Class
