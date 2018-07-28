# Webpack
> Webpack is a module bundler. webpack takes modules with dependencie and generates static assets representing those modules.

![Webpack](https://raw.githubusercontent.com/tdson/rails_vue_pratice/docs/assets/img/webpack.png "Bundle your script, images, styles, assets")

Ở thời điểm hiện tại việc đưa phần lớn các logic xử lý cho phần _front-end_ gánh vác giúp giảm tải cho _back-end_ đã quá quen thuộc. Điều này đồng nghĩa với sự lên ngôi của Javascript, một sự lên ngôi đã được dự đoán từ lâu.

Từ đó việc code font-end bây giờ phứt tạp hơn rất nhiều, không chỉ đơn giản là vài dòng _vanilla-js_ hay _jQuery_ nữa, code phình to hơn rất nhiều, điều này gây khó khăn không chỉ cho việc code mà còn khó cho cả quản lý code lẫn bảo trì. Đó là lý do ra đời của _module bundler_ (_module loader_).

## Why Webpack?
Hiện nay có rất nhiều sự lựa chọn khác như Gulp, Browserify, NPM scripts, Grunt... Vậy tại sao lại chọn Webpack?

#### Ưu điểm:
- Kiểm soát nhiều hơn các `dependencies` thông qua việc `import`, chỉ import và sử dụng những scripts cần thiết.
- Sử dụng modern JavaScript (các tính năng của ES 6).
- Webpack có thể phân tích code khi compile, điều này có thể cung cấp thông tin để tối ưu hoá code.
- Webpack có thể tách CSS từ JS.

#### Nhược điểm:
- Phải cài đặt nhiều thứ liên quan lằng nhằng.
- Javascript phải ở dạng module (cả code của app lẫn của bên thứ 3).

# ESLint
Như đã giới thiệu ở phần đầu, khi JavaScript lên ngôi bài toán về việc đảm bảo chất lượng code cũng được đặt ra.

Có rất nhiều yếu tố khác nhau để tạo ra một project tốt như: cấu trúc code rõ ràng, hợp lý, tài liệu hướng dẫn chính xác và đầy đủ,... Tuy nhiên yếu tố quan trọng nhất là code phải dễ đọc, dễ hiểu và bảo trì.

Để đảm bảo những việc đó sức người là không thể, đây là lúc ESLint ra đời.

#### Lint
Lint là những công cụ giúp chúng ta phân tích code, từ đó đưa ra các vấn đề mà code đang gặp phải như không tuân thủ coding style, sai coding convention. Ngoài ra, lint còn có thể giúp chúng ta tìm ra một số bug tiềm ẩn trong code như gán biến chưa khai báo, có thể gây lỗi runtime hoặc lấy giá trị từ một biến toàn cục khiến cho việc debug trở nên khó khăn.

#### ESLint
ESLint là một `Lint tool`, nó cho phép tuỳ chỉnh coding convention theo nhu cầu riêng của từng dự án.


## Cài đặt ESLint

```sh
yarn add eslint eslint-loader eslint-plugin-vue --save-dev

# Or specific the version
# yarn add eslint@4.19.1 eslint-plugin-vue --save-dev
./node_modules/.bin/eslint --init
```
Chọn 1 trong 3 option để tạo ra file `.eslintrc.js`.

```txt
? How would you like to configure ESLint? (Use arrow keys)
❯ Answer questions about your style
  Use a popular style guide
  Inspect your JavaScript file(s)
? How would you like to configure ESLint? Answer questions about your style
? Are you using ECMAScript 6 features? Yes
? Are you using ES6 modules? Yes
? Where will your code run? Browser, Node
? Do you use CommonJS? Yes
? Do you use JSX? No
? What style of indentation do you use? Spaces
? What quotes do you use for strings? Single
? What line endings do you use? Unix
? Do you require semicolons? No
? What format do you want your config file to be in? JavaScript
Successfully created .eslintrc.js file in <path>
```

Sau bước này 1 file mới `.eslintrc.js` sẽ sinh ra trong thư mục gốc của dự án, file này sẽ chứa toàn bộ các cấu hình của ESLint bao gồm cả các rules, plugins...

Nếu ESLint chưa hoạt động được trên IDE/Text editor của bạn có thể tham khảo đường dẫn sau để cấu hình:
> https://alligator.io/vuejs/vue-eslint-plugin/

# Webpacker
Webpacker là một Ruby gem dùng để tích hợp Webpack vào dự án Rails sử dụng chung với Asset Pipeline.

## Yêu cầu hệ thống:
>Ruby 2.2+
>Rails 4.2+
>Node.js 6.0.0+
>Yarn 0.25.2+

## Cài đặt
Từ Rails 5.1+ đã có thể thêm `webpacker` vào Rails như 1 option khi khởi tạo project.
```sh
rails new a_rails_app --webpack
```

Hoặc cách truyền thống là add vào `Gemfile`
```Gemfile
gem 'webpacker', '~> 3.5'
```
Sau đó chạy bundle để cài đặt webpack
```sh
bundle install
bundle exec rails webpacker:install

# Or if Rails version is under 5.0
# bundle exec rake webpacker:install
```

Để sử dụng Vue với webpacker, khi tạo app chỉ cần thêm option `--webpack=vue`
```sh
rails new a_rails_app --webpack=vue
```

Nếu dự án đã có sẵn, sau khi thêm gem `webpacker` chỉ cần cài `vue`
```sh
bundle exec rails webpacker:install:vue
```

Installer sẽ tự động thêm Vue và các thư viện cần thiết vào `yarn` trong quá trình cài đặt và apply một số thay đổi cần thiết trong config. Phần lớn trong số đó chúng ta không cần quan tâm, tuy nhiên có 1 cấu hình cần sửa lại bằng cách thêm đoạn js bên dưới:

```js
// config/webpack/environment.js
environment.loaders.get ('vue').use[0].options.extractCSS = false
```

Sau khi install, sẽ có 1 app __Hello World__ được sinh ra trong thư mục `app/javascript`.

#### Lưu ý với Rails 5.2+
Phiên bản Rails 5.2 trở lên cần enable `unsafe-eval` ở môi trường `development`

```rb
# file: config/initializers/content_security_policy.rb

if Rails.env.development?
  policy.script_src :self, :https, :unsafe_eval
else
  policy.script_src :self, :https
end
```

# Sử dụng
Cấu trúc code của webpacker như bên dưới:

```yml
app/javascript:
  ├── packs:
  │   # only webpack entry files here
  │   └── application.js
  └── src:
  │   └── application.css
  └── images:
      └── logo.svg
```

Webpacker cung cấp một số helpers để chèn JS/CSS vào trang views
```html
<!-- Helper generate script, link tag -->
<%= javascript_pack_tag 'application' %>
<%= stylesheet_pack_tag 'application' %>

<!-- hoặc helper generate file path -->
<link rel="prefetch" href="<%= asset_pack_path 'application.css' %>" />
<img src="<%= asset_pack_path 'images/logo.svg' %>" />
```
