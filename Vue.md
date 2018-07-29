# Vue.js in Rails

![Vue](https://vuejs.org/images/logo.png "The Progressive JavaScript Framework")

### Who is using it?
- GitLab: https://about.gitlab.com/2016/10/20/why-we-chose-vue/
- Weex: https://weex.apache.org/guide/use-vue.html
- Baidu: https://www.baidu.com/
- Facebook, Netflix, Adobe, Xiaomi, Alibaba, Laracasts,...

# How it works?
![Graph](https://raw.githubusercontent.com/tdson/rails_vue_pratice/docs/assets/img/how-it-works.png "Reactivity")
- Lấy cảm hứng từ kiến trúc Model-view-viewmodel (MVVM).
- Sử dụng `Declarative rendering`.
- Tracking các properties bằng getter/setters.

# The vue instance

```js
var vm = new Vue({})
```
- `Vue` là hàm khởi tạo app.

# Instance Lifecycle Hooks

Khi được khởi tạo, một đối tượng Vue sẽ đi qua nhiều bước khác nhau - cài đặt quan sát dữ liệu (data observation), biên dịch template, gắn kết vào DOM, cập nhật DOM khi dữ liệu thay đổi v.v.

Trong suốt tiến trình này, nó cũng sẽ thực thi một số hàm gọi là lifecycle hook, giúp người dùng thêm code của mình vào các giai đoạn (stage) cụ thể trong vòng đời của đối tượng.

Dưới đây là sơ đồ vòng đời của một đối tượng Vue. Ngay lúc này thì bạn chưa cần hiểu mọi thứ trong đây, nhưng dần dần về sau khi bạn học và xây dựng thêm với Vue, sơ đồ này sẽ là một nguồn tham khảo rất hữu ích.
![lifecycle](https://raw.githubusercontent.com/tdson/rails_vue_pratice/docs/assets/img/lifecycle.png "Lifecycle Diagram")

# Directives

### v-bind
```html
<a v-bind:href="url"></a>
<!-- or shorthand -->
<a :href="url"></a>
```

### v-on
```html
<a v-on:click="doSomething"></a>
<!-- or shorthand -->
<a @click="doSomething"></a>
```
