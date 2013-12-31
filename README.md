## iteye2markdown

iteye2markdown是一款博客迁移工具

* 此工具会自动下载iteye博客上的所有文章
* 接着会将博客中的bbcode代码转换成markdown
* 下载转换后的markdown可用于octopress,迁移至自己的博客系统上

使用方式: 

* 修改download.rb中的cookie配置, cookie将用于连接iteye.com的后台系统, 下载博客内容
* 修改download.rb中的博客地址
* 使用以下命令
```
ruby download.rb
```
执行下载转换, 结果保存于blog目录中



