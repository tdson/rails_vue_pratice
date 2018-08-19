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

## Vue instance
Một cái nhìn sơ qua về các thành phần của app, sẽ bao gồm 2 phần như hình

![Components](https://raw.githubusercontent.com/tdson/rails_vue_pratice/docs/assets/img/components.png)

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

## Single page application với Vue-Router

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

Tuy nhiên, hãy thử truy cập đường dẫn `locahost:5000/about` hoặc thử refresh trang ở trang About, bạn sẽ nhận được lỗi từ Rails rằng app không tồn tại route đó.

Để tránh tình trạng này, cần sửa một chút ở file `routes.rb`, trỏ tất cả các route có trên app Vue vào action `index` của controller `Home`

```diff
diff --git a/config/routes.rb b/config/routes.rb
index d7e4ee7..80ce398 100644
--- a/config/routes.rb
+++ b/config/routes.rb
@@ -1,5 +1,7 @@
 Rails.application.routes.draw do
   root 'home#index'
+  get '/about', to: 'home#index'
+  get '/contact', to: 'home#index'

   namespace :api, format: :json do
     resources :tasks, except: [:edit, :new]
```

Hoặc nếu bạn sử dụng app Vue để thay thế toàn bộ phần views của Rails thì chỉ cần đơn giản trỏ hết tất cả các path của Rails vào cùng 1 action:
```rb
path "*", to: "home#index"
```
Như vậy bạn  không cần phải quan tâm đến việc quản lý routes ở phía Rails nữa, `Vue-Router` sẽ lo tất cả.

## Giao tiếp API bằng Axios
[Axios](https://github.com/mzabriskie/axios) là một thư viện ajax rất nổi tiếng, có  lẽ mọi người đã quá quen thuộc với jQuery Ajax, nhưng hãy cứ thử thay đổi một chút xem những gì axios có thể làm được, và tại sao nó có gần 46k stars trên github.

Đầu tiên cài đặt axios bằng yarn
```sh
yarn add axios -S
```
Chúng ta sẽ dùng axios để lấy list các task về và render lên component `home.vue`.

Trước tiên, cùng nhìn qua cái template của trang home trước đã. Thêm đoạn HTML tạm bợ này vào file `home.vue`
```diff
diff --git a/app/javascript/packs/pages/home.vue b/app/javascript/packs/pages/home.vue
index 97f372e..44674d0 100644
--- a/app/javascript/packs/pages/home.vue
+++ b/app/javascript/packs/pages/home.vue
@@ -1,5 +1,33 @@
 <template>
   <div>
-    <h1>Index</h1>
+    <div>
+      <ul class="collection">
+        <li id="row_task_1" class="collection-item">
+          <input type="checkbox" id="task_1" />
+          <label for="task_1">Sample Task</label>
+        </li>
+        <li id="row_task_2" class="collection-item">
+          <input type="checkbox" id="task_2" />
+          <label for="task_2">Sample Task</label>
+        </li>
+        <li id="row_task_3" class="collection-item">
+          <input type="checkbox" id="task_3" />
+          <label for="task_3">Sample Task</label>
+        </li>
+      </ul>
+    </div>
+    <div class="btn">Display finished tasks</div>
+    <div id="finished-tasks" class="display_none">
+      <ul class="collection">
+        <li id="row_task_4" class="collection-item">
+          <input type="checkbox" id="'task_4" checked="checked" />
+          <label v-bind:for="task_4" class="line-through">Done Task</label>
+        </li>
+        <li id="row_task_5" class="collection-item">
+          <input type="checkbox" id="'task_5" checked="checked" />
+          <label v-bind:for="task_5" class="line-through">Done Task</label>
+        </li>
+      </ul>
+    </div>
   </div>
 </template>
```

Đây là kết quả:

![Index template](https://raw.githubusercontent.com/tdson/rails_vue_pratice/docs/assets/img/template.png)

Bây giờ công việc sẽ là tạo ra cái list kia một cách tự động bằng dữ liệu thật.

Thêm đoạn script sau vào cuối file `home.vue`

```html
<script>
import axios from 'axios'

export default {
  data: function () {
    return {
      tasks: []
    }
  },

  mounted: function () {
    this.fetchTasks()
  },

  methods: {
    fetchTasks: function () {
      axios.get('/api/tasks').then(
        response => { this.tasks = this.data.tasks },
        error => alert(error)
      )
    }
  }
}
</script>
```
Dừng lại 1 chút, mình sẽ giải thích những cái cần chú ý.
- `data`, chỗ đầu tiên các bạn nên nhìn vào chắc là đây. `data` là một hàm, hàm này sẽ return về những biến local của component đó, những biến này được dùng xuyên suốt trong nội bộ component đó và có thể truyền sang cho các component con. Cú pháp như trên nghĩa là component này sẽ có 1 biến `tasks`, là một mảng các task sẽ được gán giá trị sau khi gọi API. Để sử dụng biến này thì dùng `this.$data.tasks` hoặc cú pháp đơn giản hơn là `this.tasks`.
- `mounted`, cũng là một hàm, mã bên trong hàm này sẽ được chạy sau khi component này được render xong, nếu so sánh với jQuery thì chỗ này giống `$(document).ready()`. Ở đây khi render xong sẽ gọi hàm `fetchTasks()` để lấy dữ liệu về từ API.
- `methods`, đây là một object, object này sẽ chứa các hàm được khai báo để dùng trong component này. Ví dụ ở đây là hàm `fetchTasks`. Tất cả các hàm đều nằm trong object `methods` này. Để gọi hàm thì chỉ đơn giản là `this.fetchTasks()`.
-  `axios.get`, tạo một request với method get bằng axios. Thông tin thêm vui lòng xem ở github của [axios](https://github.com/mzabriskie/axios). Để sử dụng axios thì bên trên nhớ import module của nó vào. Axios trả về một promise, `.then()` để resolve promise đó, và có thể handle error bằng cách như trên hoặc dùng catch.

## Computed
Quay trở lại việc render list, ở đây mình muốn render 2 list, một cái là tasks chưa hoàn thành, và 1 cái là tasks đã hoàn thành.

Trên ý tưởng là mình có thể dùng 2 biến ở `data`, để chứa 2 list riêng biệt, ví dụ:
```js
data () {
  return {
    finishedTasks: [],
    unfinishedTasks: []
  }
}
```
Hoặc cách khác là viết 2 hàm để lấy danh được 2 danh sách tương ứng, ví dụ:
```js
methods: {
  finishedTasks: function () {
    return this.tasks.filter(task => task.is_done)
  },
  unfinishedTasks: function () {
    return this.tasks.filter(task => !task.is_done)
  }
}
```
Tuy nhiên Vue cung cấp một thứ hay hơn, lai giữa `data` và `method` đó là `computed`. Trên lý thuyết computed cũng là thuộc tính của component như data, nhưng thường nó là thuộc tính chỉ đọc, hay nói cách khác nó như là một getter, cho phép lấy data nhưng có một vài thao tác xử lý lọc/tính toán trước.

Về cách viết nó hoàn toàn giống như method, thêm computed vào trong file `home.vue`

```diff
diff --git a/app/javascript/packs/pages/home.vue b/app/javascript/packs/pages/home.vue
index af545de..bfe2cf0 100644
--- a/app/javascript/packs/pages/home.vue
+++ b/app/javascript/packs/pages/home.vue
@@ -42,6 +42,16 @@ export default {
     }
   },

+  computed: {
+    finishedTasks: function () {
+      return this.tasks.filter(task => task.is_done)
+    },
+
+    unfinishedTasks: function () {
+      return this.tasks.filter(task => !task.is_done)
+    }
+  },
+
   mounted: function () {
     this.fetchTasks()
   },
```

Bây giờ có thể dùng `this.finishedTasks` và `this.unfinishedTasks` như data, chỉ là không dùng được phép gán (thật ra là được nhưng nó sẽ nằm ở một bài viết khác).

## Vòng lặp với v-for

Để in ra danh sách các task, Vue cung cấp một cú pháp vòng lặp hết sức mạnh mẽ `v-for`

Đầu tiên hãy xoá hết các thẻ `li` trong component `home` đi và thay thế vòng lặp như bên dưới.

```diff
diff --git a/app/javascript/packs/pages/home.vue b/app/javascript/packs/pages/home.vue
index bfe2cf0..3199376 100644
--- a/app/javascript/packs/pages/home.vue
+++ b/app/javascript/packs/pages/home.vue
@@ -2,30 +2,18 @@
   <div>
     <div>
       <ul class="collection">
-        <li id="row_task_1" class="collection-item">
-          <input type="checkbox" id="task_1" />
-          <label for="task_1">Sample Task</label>
-        </li>
-        <li id="row_task_2" class="collection-item">
-          <input type="checkbox" id="task_2" />
-          <label for="task_2">Sample Task</label>
-        </li>
-        <li id="row_task_3" class="collection-item">
-          <input type="checkbox" id="task_3" />
-          <label for="task_3">Sample Task</label>
+        <li v-for="task in unfinishedTasks" :key="task.id" class="collection-item">
+          <input type="checkbox" :id="`task-${task.id}`"/>
+          <label for="`task-${task.id}`">{{ task.title }}</label>
         </li>
       </ul>
     </div>
     <div class="btn">Display finished tasks</div>
     <div id="finished-tasks" class="display_none">
       <ul class="collection">
-        <li id="row_task_4" class="collection-item">
-          <input type="checkbox" id="'task_4" checked="checked" />
-          <label v-bind:for="task_4" class="line-through">Done Task</label>
-        </li>
-        <li id="row_task_5" class="collection-item">
-          <input type="checkbox" id="'task_5" checked="checked" />
-          <label v-bind:for="task_5" class="line-through">Done Task</label>
+        <li v-for="task in finishedTasks" :key="task.id" class="collection-item">
+          <input type="checkbox" :id="`task-${task.id}`" :checked="true"/>
+          <label for="`task-${task.id}`">{{ task.title }}</label>
         </li>
       </ul>
     </div>
```

Bạn để ý kỹ cú pháp `v-for` sẽ yêu cầu binding thêm 1 prop là `key` (`:key="task.id"`). Bạn cần truyền vào một giá trị không trùng vào prop này để Vue có thể tracking chính xác và render lại khi có sự thay đổi.

Bạn có thể xem thêm [tại đây](https://vuejs.org/v2/guide/list.html#key).

Còn lại về cơ bản cú pháp `v-for` tương tự với vòng lặp `for` của javascript dành cho object.
`v-for="task in finishedTasks"` sẽ lặp xuyên suốt mảng `finishedTasks`, gán giá trị ở mỗi lần lặp vào biến task, và sau đó bạn hoàn toàn có thể thao tác với biến `task`.

Như vậy là chúng ta đã render được list các task động thông qua việc gọi API và dùng vòng lặp để render tự động.

## Tách các component con
Trong thực tế, trên một trang thường chứa rất nhiều components, component cùng cấp cũng có mà lồng nhau cũng rất nhiều.

Việc phân tách thành các component con giúp việc quản lý code hiệu quả hơn, tránh làm một component phình ra quá to khi có quá nhiều logic phải xử lý.

Trong practice này khối lượng code ở component `home` không quá nhiều để đến mức phải đem tách ra các component con, tuy nhiên để giới thiệu và thực hành, mình sẽ tiến hành tách các task thành từng component.

Đầu tiên bạn tạo file `app/javascript/packs/components/task.vue` và move toàn bộ nội dung của thẻ `li` bên ở vòng `v-for` vào template.

```html
<template lang="html">
  <li class="collection-item">
    <input type="checkbox" :id="`task-${task.id}`"/>
    <label :for="`task-${task.id}`" v-text="task.title" :checked="task.is_done"/>
  </li>
</template>

<script>
export default {
  props: ['task']
}
</script>
```

Một số chỗ các bạn cần lưu lý:

- `props: ['task']`: Tại component `home` sẽ bind 1 biến `task` sang bên này, để khai báo rằng component `task.vue` sẽ nhận 1 biến từ component cha chúng ta sẽ khai báo biến đó dưới dạng `props`. prop `task` các bạn cứ xem nó giống như `data` của component này vậy, nhưng __không được làm thay đổi giá trị của nó__ (chỉ đọc).

- Cú pháp `v-text`, cú pháp này sẽ đưa toàn bộ string ở biến truyền vào thẻ html của bạn. Mình thường xuyên sử dụng cú pháp này thay thế cú pháp nội suy `{{ }}` nếu thẻ đó chỉ có 1 nội suy, code trông sẽ sáng sủa hơn nhiều, và mình cũng có thể bỏ luôn thẻ đóng của html. (Bạn nhìn lại xem thẻ label ko có thẻ đóng, mà mình đóng luôn ngay ở cuối thẻ `/>`).

- `:checked="task.is_done"` Component này sẽ dùng chung cho cả 2 list là DS đã hoàn thành và DS task chưa hoàn thành, do dậy cần binding thuộc tính `checked` một cách động.


Tiếp theo cần khai báo component này ở `home` và sử dụng thay thế thẻ `li`.

```diff
diff --git a/app/javascript/packs/pages/home.vue b/app/javascript/packs/pages/home.vue
index 3199376..9bd37b3 100644
--- a/app/javascript/packs/pages/home.vue
+++ b/app/javascript/packs/pages/home.vue
@@ -2,19 +2,13 @@
   <div>
     <div>
       <ul class="collection">
-        <li v-for="task in unfinishedTasks" :key="task.id" class="collection-item">
-          <input type="checkbox" :id="`task-${task.id}`"/>
-          <label for="`task-${task.id}`">{{ task.title }}</label>
-        </li>
+        <task v-for="task in unfinishedTasks" :key="task.id" :task="task"/>
       </ul>
     </div>
     <div class="btn">Display finished tasks</div>
     <div id="finished-tasks" class="display_none">
       <ul class="collection">
-        <li v-for="task in finishedTasks" :key="task.id" class="collection-item">
-          <input type="checkbox" :id="`task-${task.id}`" :checked="true"/>
-          <label for="`task-${task.id}`">{{ task.title }}</label>
-        </li>
+        <task v-for="task in finishedTasks" :key="task.id" :task="task"/>
       </ul>
     </div>
   </div>
@@ -22,6 +16,7 @@

 <script>
 import axios from 'axios'
 +import Task from '../components/task'

  export default {
    data: function () {
 @@ -30,6 +25,10 @@ export default {
      }
    },

 +  components: {
 +    Task
 +  },
 +
    computed: {
      finishedTasks: function () {
        return this.tasks.filter(task => task.is_done)
```

Rất đơn giản đúng không?
- Đầu tiên là import component vào.
- Sau đó khai báo thêm `component` `Task` ở chỗ export component (`export default` ấy).
- Sửa lại thẻ HTML, sử dụng component `<task>` thay cho thẻ `li`, code đã gọn đi rất nhiều.

Tải lại trình duyệt và bạn có một kết quả không có gì thay đổi :joy:

## Làm việc với event bằng v-on và $emit

Bây giờ mình muốn bắt sự kiện khi check vào các checkbox ở mỗi task để đánh dấu task đã done thì phải nàm thao?

Theo "old fashioned way" thì cứ gắn class cho nó rồi `document.addEventListener` :joy:

Thôi, Vue có cách dễ thương hơn đó là dùng `v-on`.

```diff
diff --git a/app/javascript/packs/components/task.vue b/app/javascript/packs/components/task.vue
index 55547de..578c804 100644
--- a/app/javascript/packs/components/task.vue
+++ b/app/javascript/packs/components/task.vue
@@ -1,6 +1,6 @@
 <template lang="html">
   <li class="collection-item">
-    <input type="checkbox" :id="`task-${task.id}`" :checked="task.is_done"/>
+    <input type="checkbox" :id="`task-${task.id}`" :checked="task.is_done" v-on:change="toggleFinish"/>
     <label :for="`task-${task.id}`" v-text="task.title"/>
   </li>
 </template>
@@ -10,8 +10,8 @@ export default {
   props: ['task'],

+  methods: {
+    toggleFinish (e) {
+      console.log('checked?', e.target.checked)
+    }
+  }
 }
```

Cú pháp của `v-on` là `v-on:<event_name>="<handler>"`. Trong đó `event_name` thì chắc các bạn đã quá quen thuộc rồi, như là `click`, `change`, `submit`, `type`, `keyup`,... rất rất nhiều, và `handler` chính là function handle event đó, function này có một đối số là object event chứa một số thông tin của event.

`v-on` còn được viết gọn thành `@`, vậy là chỉ cần viết `@click="handler"` là vue có thể hiểu được ngon lành rồi, ko cần ghi dài dòng `v-on`.

Bạn xem thêm tài liệu về [event handling tại đây](https://vuejs.org/v2/guide/events.html).

Trở lại với đoạn code trên. Mình vừa thêm một sự kiện `change` cho checkbox, khi check/uncheck, function `toggleFinish` sẽ được gọi, tham số `e` ở handler đó chính là event object mà mình đã nhắc tới. Có thể bạn sẽ muốn chạy thử và xem qua trên console.

Tiếp theo mình sẽ update lại cái `task` khi check/uncheck cái checkbox này. Nếu task đã done mình sẽ đưa nó về lại list unfinished, và ngược lại.

Để làm việc này, mình sẽ chỉ muốn gọi API duy nhất 1 lần, code chung 1 hàm thay vì có 2 handler cho việc mark finish và mark unfinish, do đó việc gọi API các thứ mình sẽ đặt ở component cha (`home.vue`). Vậy là có 1 phương thức nào đó để giao tiếp chiều ngược lại từ component con sang component cha? :thinking_face:
Mình xin giới thiệu `$emit`.

Đầu tiên là code mẫu.
```diff
diff --git a/app/javascript/packs/components/task.vue b/app/javascript/packs/components/task.vue
index 578c804..11df505 100644
--- a/app/javascript/packs/components/task.vue
+++ b/app/javascript/packs/components/task.vue
@@ -11,7 +11,7 @@ export default {

   methods: {
     toggleFinish (e) {
-      console.log('e', e)
+      const payload = {
+        task: this.task,
+        value: e.target.checked
+      }
+      this.$emit('toggleFinish', payload)
     }
   }
 }
diff --git a/app/javascript/packs/pages/home.vue b/app/javascript/packs/pages/home.vue
index 9bd37b3..e8ab8a3 100644
--- a/app/javascript/packs/pages/home.vue
+++ b/app/javascript/packs/pages/home.vue
@@ -2,13 +2,13 @@
   <div>
     <div>
       <ul class="collection">
-        <task v-for="task in unfinishedTasks" :key="task.id" :task="task"/>
+        <task v-for="task in unfinishedTasks" :key="task.id" :task="task" @toggleFinish="updateTask"/>
       </ul>
     </div>
     <div class="btn">Display finished tasks</div>
     <div id="finished-tasks" class="display_none">
       <ul class="collection">
-        <task v-for="task in finishedTasks" :key="task.id" :task="task"/>
+        <task v-for="task in finishedTasks" :key="task.id" :task="task" @toggleFinish="updateTask"/>
       </ul>
     </div>
   </div>
```

Đầu tiên, mình `$emit` một sự kiện tên là `toggleFinish` và truyền sang 1 object. Mặc định hàm emit chỉ cho phép pass 2 arguments là tên sự kiện và 1 object, nên để truyền nhiều args hơn chúng ta có thể gói nó bên trong 1 object hoặc 1 mảng.

Tiếp đến ở component cha, mình "lắng nghe" sự kiện đó `@toggleFinish` (hoặc `v-on:toggleFinish`) và gọi hàm `updateTask` để xử lý.

Đây là hàm `updateTask` ở component `home.vue`

```js
updateTask: function ({task, value}) {
  const data = {
    task: { is_done: value }
  }
  axios.put(`/api/tasks/${task.id}`, data).then(
    response => {
      const index = this.tasks.indexOf(task)
      this.tasks.splice(index, 1, response.data.task)
    },
    error => alert(error)
  )
}
```
- 2 đối số `task` và `value` của hàm chính là 2 đối tượng trong payload lúc nãy truyền vào.
- Gọi API bằng `axios` để update task.
- Sau khi update thành công, mình cập nhật lại list bằng cách thay thế object task cũ bằng object mới ở response. Hoặc đơn giản hơn bạn chỉ cần set thẳng `task.is_done = true`, nhưng ở đây mình muốn làm một cách tổng quát :joy:

Bây giờ hãy thử một chút trên trình duyệt xem thế nào nhé.

> Nhiệm vụ của bạn là gắn thêm event cho button `Display finished task` và thêm button destroy task.
