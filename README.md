# Tạo Personal Access Token trên Github

Từ tài khoản Github của bạn, đi đến Settings => Developer Settings => Personal Access Token => Generate New Token (cung cấp mật khẩu của bạn) => Fillup the form => click Generate token 
=> Copy the generated Token, nó sẽ kiểu như thế này: ghp_sFhFsSHhTzMDreGRLjmks4Tzuzgthdvfsrta

# For Linux based OS

Đối với Linux, bạn cần định cấu hình phía local GIT client với một username và địa chỉ email,

$ git config --global user.name "your_github_username"
$ git config --global user.email "your_github_email"
$ git config -l

Sau khi GIT được định cấu hình, chúng ta có thể bắt đầu sử dụng nó để truy cập GitHub. Ví dụ :

$ git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY
> Cloning into `Spoon-Knife`...
$ Username for 'https://github.com' : username
$ Password for 'https://github.com' : give your personal access token here

Bây giờ hãy lưu vào bộ nhớ cache của bản ghi đã cho trong máy tính của bạn để ghi nhớ mã token :

$ git config --global credential.helper cache

Nếu cần bấy cứ lúc nào bạn cũng có thể xóa bản ghi bộ nhớ cache bằng cách :

$ git config --global --unset credential.helper
$ git config --system --unset credential.helper

Giờ hãy thử xác minh:

$ git pull -v
