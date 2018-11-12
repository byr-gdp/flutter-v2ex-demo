# v2ex demo

A Flutter demo project for V2EX.

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
