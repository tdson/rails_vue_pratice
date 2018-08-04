# Vue.js in Rails todo app tutorial

![Vue](https://raw.githubusercontent.com/tdson/rails_vue_pratice/docs/assets/img/cover.jpg "The Progressive JavaScript Framework")

## Install rails project
Đầu tiên tạo một rails app để viết API cho app front-end. Chạy lệnh bên dưới
```sh
rails new todo --webpack=vue --skip-turbolinks --skip-coffee
```
  - `--webpack=vue`: Thêm gem webpack và cài đặt các dependencies của Vue.
  - `--skip-turbolinks`: Skip turbolinks gem
  - `--skip-coffee`: Không dùng CoffeeScript, app này chúng ta viết bằng JS ES6 ngon hơn nhiều.

Sau khi chạy lệnh trên rails tự chạy `bundle` luôn.

Nếu các bạn chưa biết webpack là gì thì có thể đọc [ở đây](#) trước.

Bài viết sẽ focus vào Vue nên mình sẽ không đi sâu vào việc viết API cho app. Các bạn có thể dùng bất cứ một server nào khác miễn cảm thấy thân quen là được. Mình đã chuẩn bị sẵn một vài API ở nhánh [`delvelop`](https://github.com/tdson/rails_vue_pratice/tree/develop), các bạn chỉ cần clone về chạy migrate và làm tiếp các bước bên dưới.
```sh
rails db:setup
```

Đây là hình ảnh demo sau khi làm
![Todo_Demo](https://raw.githubusercontent.com/tdson/rails_vue_pratice/docs/assets/img/demo.gif "A demo of todo app")

## Một số bước chuẩn bị
### Foreman
Trong quá trình dev mình sẽ chạy `webpack` bằng webpacker riêng biệt với Rails. Các bước tiếp theo đây mình sẽ hướng dẫn các bạn cấu hình `foreman` để trình duyệt tự động refresh mỗi khi có thay đổi code ở `app/javascript/*`.

```diff
diff --git a/Gemfile b/Gemfile
index 506b795..4fcca63 100644
--- a/Gemfile
+++ b/Gemfile
@@ -26,6 +26,8 @@ gem 'jbuilder', '~> 2.5'

 # Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
 # gem 'rack-cors'
+gem 'foreman'
```
Sau khi chạy lại bundle, thêm 2 file sau:
  - `bin/server`: Thực thi lệnh trong file `Procfile.dev`
  - `Procfile.dev`: Chạy `rails s` và `bin/webpack-dev-server`.


  - `bin/server`
```
#!/bin/bash -i
bundle install
bundle exec foreman start -f Procfile.dev
```

  - Procfile.dev
```
web: bundle exec rails s
# watcher: ./bin/webpack-watcher
webpacker: ./bin/webpack-dev-server
```

Ngoài ra, cần phải thay đổi quyền của access của file `bin/server`

```sh
sudo chmod 777 bin/server
```

Bây giờ các bạn có thể vọc qua 1 tí bằng cách tạo ra một controller để thử trên một trang.
```sh
rails g controller home index
```
Sửa lại file routes một chút:
```diff
diff --git a/config/routes.rb b/config/routes.rb
index 97e5420..d7e4ee7 100644
--- a/config/routes.rb
+++ b/config/routes.rb
@@ -1,4 +1,6 @@
 Rails.application.routes.draw do
+  root 'home#index'
```
Mặc định ở thư mục `app/javascript/packs` có một file `hello_vue.js`, đó là một app hello world mẫu. Tạm dùng nó để vọc đã.

Tiếp theo là views, sửa view của trang home lại như sau:

```diff
diff --git a/app/views/home/index.html.erb b/app/views/home/index.html.erb
index 2085730..faaadde 100644
--- a/app/views/home/index.html.erb
+++ b/app/views/home/index.html.erb
@@ -1,2 +1 @@
-<h1>Home#index</h1>
-<p>Find me in app/views/home/index.html.erb</p>
+<%= javascript_pack_tag 'hello_vue' %>
```

`javascript_pack_tag 'hello_vue'` sẽ load file js ở đường dẫn `app/javascript/packs/hello_vue.js` vào trang home của chúng ta.

Bây giờ chạy `bin/server` để start server, sau đó truy cập [`localhost:5000`](localhost:5000), vâng! cổng `5000`, ko nhầm đâu.

Bạn sẽ thấy một thứ đại loại như là:
> Hello Vue!

Thử sửa một tí trong file `app/javascript/app.vue` và lưu lại.

```diff
-message: "Hello Vue!"
+message: "Hello Vue! I'm here!"
```

Bây giờ xem lại trên trình duyệt trang đã được tải lại chưa nhé ;)

Mình giải thích qua một chút ở cái file `hello_vue.js`
```js
import Vue from 'vue' // import vue vào
import App from '../app.vue'  // Import component app vào

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('hello')) // Tạo một div mới để chứa app vue
  const app = new Vue({ // Khởi tạo một instance của Vue (app Vue)
    el, // cách viết khác của `el: el`. Khai báo app vue sẽ được render vào element này.
    render: h => h(App) // render component app lên view.
  })
})
```

## Chuẩn bị "bộ mặt" cho app
Đầu tiên là thêm thư viện `materialize` và `material_icon`, để dùng được các thư viện này thì phải có cả `jquery`. Sửa file `Gemfile` lại như sau rồi chạy lại `bundle install`.

```diff
diff --git a/Gemfile b/Gemfile
index 0f63e9c..d98a19b 100644
--- a/Gemfile
+++ b/Gemfile
@@ -31,6 +31,10 @@ gem 'jbuilder', '~> 2.5'
 # Use Capistrano for deployment
 # gem 'capistrano-rails', group: :development
 gem 'foreman'
+gem 'jquery-rails'
+# gem 'jquery-turbolinks' # use this gem if you are using turbolinks
+gem 'materialize-sass'
+gem 'material_icons'
```

Tiếp theo load CSS của materialize vào file __scss__, require js  vào `application.js`.

```diff
diff --git a/app/assets/stylesheets/application.scss b/app/assets/stylesheets/application.scss
index d05ea0f..5e9347c 100644
--- a/app/assets/stylesheets/application.scss
+++ b/app/assets/stylesheets/application.scss
@@ -13,3 +13,10 @@
  *= require_tree .
  *= require_self
  */
+
+/* Materialize */
+@import "materialize/components/color";
+$primary-color: color("orange ", "accent-4") !default;
+$secondary-color: color("orange ", "accent-1") !default;
+@import 'materialize';
+@import 'material_icons';
```

```diff
diff --git a/app/assets/javascripts/application.js b/app/assets/javascripts/application.js
index 504211e..3ed003c 100644
--- a/app/assets/javascripts/application.js
+++ b/app/assets/javascripts/application.js
@@ -10,5 +10,7 @@
 // Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
 // about supported directives.
 //
+//= require jquery
+//= require materialize
 //= require rails-ujs
 //= require_tree .
```

## Tạo components
Một cái nhìn sơ qua về các thành phần của app, sẽ bao gồm 2 phần như hình

![Components](https://raw.githubusercontent.com/tdson/rails_vue_pratice/docs/assets/img/components.jpg)

Phần main conent, hầu hết sự thay đổi khi bấm vào các link, chuyển trang... sẽ chỉ thay đổi ở component này, còn phần navigation bar sẽ là cố định giữa các trang.

Tương ứng, chúng ta sẽ có 2 components là `navbar` và `main`. Component `navbar` như bên dưới:

- app/javascript/packs/components/navbar.vue
```vue
<template>
  <div>
    <ul id="dropdown" class="dropdown-content">
      <li><a href="/">Top</a></li>
      <li><a href="/about">About</a></li>
      <li><a href="/contact">Contact</a></li>
    </ul>
    <nav>
      <div class="nav-wrapper container">
        <a href="/" class="brand-logo left">Home</a>
        <ul class="right hide-on-med-and-down">
          <li><a href="/">Top</a></li>
          <li><a href="/about">About</a></li>
          <li><a href="/contact">Contact</a></li>
        </ul>
        <ul class="right hide-on-large-only">
          <li>
            <a href="#!" class="dropdown-button" data-activates="dropdown">
              Menu <i class="material-icons right">arrow_drop_down</i>
            </a>
          </li>
        </ul>
      </div>
    </nav>
  </div>
</template>
```

Về phần main content, đây là sẽ một vùng động để render các trang khác nhau, ở đây chúng ta sẽ có 3 trang là `/` ('hay `/home`'), `/about` và `/contact`.
Các component chính của 3 trang này sẽ nằm trong thư mục `pages`.
- `app/javascript/packs/pages/about.vue`
```vue
<template>
  <div>
    <h1>About</h1>
    <p>This is a sample of TODO application with Vue.js and Ruby on Rails.</p>
  </div>
</template>
```

- `app/javascript/packs/pages/contact.vue`
```vue
<template>
  <div>
    <h1>Contact</h1>
    <p>Contact me via tran.dai.son@framgia.com.</p>
  </div>
</template>
```

- `app/javascript/packs/pages/home.vue`
```vue
<template>
  <div>
    <h1>Index</h1>
  </div>
</template>
```

Để đem được app lên views, trước hết cần tạo một app vue và load source js ra view.

Tạo file `app/javascript/packs/todo.js`
```js
import Vue from 'vue/dist/vue.esm'
import Navbar from './components/navbar'

var app = new Vue({
  el: '#app',
  components: {
    Navbar
  }
})
```
Ở đây trong options `components` chúng ta sẽ khai báo có 1 component tên là `Navbar` sau đó ở view chúng ta có thể sử dụng tag `<navbar></navbar>` như một tag HTML bình thường. Vue sẽ nhận ra đó là 1 component vì ở đây đã khai báo nó rồi.

Chỉnh sửa lại file view `app/views/home/index.html.erb`
```diff
diff --git a/app/views/home/index.html.erb b/app/views/home/index.html.erb
index faaadde..1c740e1 100644
--- a/app/views/home/index.html.erb
+++ b/app/views/home/index.html.erb
@@ -1 +1,5 @@
-<%= javascript_pack_tag 'hello_vue' %>
+<div id="app">
+  <navbar></navbar>
+</div>
+
+<%= javascript_pack_tag 'todo' %>
```
Chú ý ở đây chúng ta có 1 div với id là `app`, id này phải khớp với id được đăng ký trong options `el` ở file `app/javascript/packs/todo.js`.
Bên trong div này là component `navbar`.

Bây giờ khởi động lại server và vào lại localhost:5000 bạn đã thấy thanh navbar như hình dưới

![Navbar](https://raw.githubusercontent.com/tdson/rails_vue_pratice/docs/assets/img/navbar.png)

Tiếp theo là phần content động giữa các trang, phần này sẽ nằm ngay dưới `navbar`. Đến đây mình xin giới thiệu với các bạn một package đầu tiên mà chúng ta sẽ dùng là `vue-router`. Dùng để tạo routes cho Vue app.

Cài đặt `vue-router` bằng yarn:
```sh
yarn add vue-router -S
```
Sau đó tạo file `app/javascript/packs/router/router.js`

```js
import Vue from 'vue/dist/vue.esm.js'
import VueRouter from 'vue-router'

import Home from '../pages/home.vue'
import About from '../pages/about.vue'
import Contact from '../pages/contact.vue'

Vue.use(VueRouter)

export default new VueRouter({
  mode: 'history',
  routes: [
    { path: '/', component: Home },
    { path: '/about', component: About },
    { path: '/contact', component: Contact },
  ],
})
```

Cái file khá đơn giản, chắc các bạn nhìn vào cũng hiểu rồi nhỉ?

Import các module cần thiết vào, bao gồm Vue, VueRouter là 2 module bắt buộc. Sau đó là các modules nằm trong thư mục `pages` đã tạo lúc trước.

Ngoài ra cần chú ý `mode: 'history'`. Mặc định, `vue-router` dùng _hash mode_ - Nó sử dụng URL hash để mô phỏng URL đầy đủ, nên trang sẽ ko bị tải lại khi URL bị thay đổi.

Để bỏ hash ra, chúng ta có thể dùng _history mode_. Các bạn đọc thêm [ở đây](https://router.vuejs.org/guide/essentials/history-mode.html).

Sửa một tí ở file `todo.js`
```diff
diff --git a/app/javascript/packs/todo.js b/app/javascript/packs/todo.js
index af5c791..557341b 100644
--- a/app/javascript/packs/todo.js
+++ b/app/javascript/packs/todo.js
@@ -1,8 +1,10 @@
 import Vue from 'vue/dist/vue.esm'
+import Router from './router/router'
 import Navbar from './components/navbar'

 var app = new Vue({
   el: '#app',
+  router: Router,
   components: {
     Navbar
   }
```
Sửa luôn cả file erb
```diff
diff --git a/app/views/home/index.html.erb b/app/views/home/index.html.erb
index 1c740e1..714b4cf 100644
--- a/app/views/home/index.html.erb
+++ b/app/views/home/index.html.erb
@@ -1,5 +1,8 @@
 <div id="app">
   <navbar></navbar>
+  <div class="container">
+    <router-view></router-view>
+  </div>
 </div>
```

Cuối cùng là file `navbar.vue`
```diff
diff --git a/app/javascript/packs/components/navbar.vue b/app/javascript/packs/components/navbar.vue
index 7a6a746..a52af98 100644
--- a/app/javascript/packs/components/navbar.vue
+++ b/app/javascript/packs/components/navbar.vue
@@ -1,17 +1,17 @@
 <template>
   <div>
     <ul id="dropdown" class="dropdown-content">
-      <li><a href="/">Top</a></li>
-      <li><a href="/about">About</a></li>
-      <li><a href="/contact">Contact</a></li>
+      <li><router-link to="/">Top</router-link></li>
+      <li><router-link to="/about">About</router-link></li>
+      <li><router-link to="/contact">Contact</router-link></li>
     </ul>
     <nav>
       <div class="nav-wrapper container">
-        <a href="/" class="brand-logo left">Home</a>
+        <router-link to="/" class="brand-logo left">Home</router-link>
         <ul class="right hide-on-med-and-down">
-          <li><a href="/">Top</a></li>
-          <li><a href="/about">About</a></li>
-          <li><a href="/contact">Contact</a></li>
+          <li><router-link to="/">Top</router-link></li>
+          <li><router-link to="/about">About</router-link></li>
+          <li><router-link to="/contact">Contact</router-link></li>
         </ul>
         <ul class="right hide-on-large-only">
           <li>
```
Thử tắt server và khởi động lại, sau đó check lại ở browser, bạn đã có thể chuyển trang mà không bị reload page. :+1:
![Router](https://raw.githubusercontent.com/tdson/rails_vue_pratice/docs/assets/img/router.gif)
