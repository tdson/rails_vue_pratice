# Vue.js in Rails todo app tutorial

![Vue](https://raw.githubusercontent.com/tdson/rails_vue_pratice/docs/assets/img/cover.png "The Progressive JavaScript Framework")

## Install rails project
Đầu tiên tạo một rails app để viết API cho app front-end. Chạy lệnh bên dưới
```sh
rails new todo --webpack=vue --api --skip-turbolinks --skip-coffee
```
  - `--webpack=vue`: Thêm gem webpack và cài đặt các dependencies của Vue.
  - `--api`: Tự thiết lập trước một số việc nhỏ cho app API.
  - `--skip-turbolinks`: Skip turbolinks gem
  - `--skip-coffee`: Không dùng CoffeeScript, app này chúng ta viết bằng JS ES6 ngon hơn nhiều.

Sau khi chạy lệnh trên rails tự chạy `bundle` luôn.

Nếu các bạn chưa biết webpack là gì thì có thể đọc [ở đây](#) trước.

Bài viết sẽ focus vào Vue nên mình sẽ không đi sâu vào việc viết API cho app. Các bạn có thể dùng bất cứ một server nào khác miễn cảm thấy thân quen là được. Mình đã chuẩn bị sẵn một vài API ở nhánh [`delvelop`](https://github.com/tdson/rails_vue_pratice/tree/develop), các bạn chỉ cần clone về chạy migrate và làm tiếp các bước bên dưới.
```sh
rails db:setup
```

![Todo_Demo](https://raw.githubusercontent.com/tdson/rails_vue_pratice/docs/assets/img/demo.gif "A demo of todo app")

## Một số bước chuẩn bị
### Foreman
Trong quá trình dev mình sẽ chạy `webpack` bằng webpacker riêng biệt với Rails.

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

Thêm đoạn mã sau vào `Procfile`, nếu chưa có các bạn cứ tạo mới một file ở thư mục gốc của project rails.
```
rails: bundle exec rails server
webpack: ./bin/webpack-dev-server
```
Sau đó start foreman
```sh
foreman start
```
