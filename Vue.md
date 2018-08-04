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

Tiếp theo load CSS của materialize vào file css, require js  vào `application.js`.

```diff
diff --git a/app/assets/stylesheets/application.css b/app/assets/stylesheets/application.css
index d05ea0f..5e9347c 100644
--- a/app/assets/stylesheets/application.css
+++ b/app/assets/stylesheets/application.css
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
