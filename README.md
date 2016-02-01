# opencloud-ios
一个开放云存储App，后端存储又拍云。

本次版本实现：
* 本地文件的读取
* 拍照上传
* 重启后文件的续传
* 上传完成后从从云服务器获取文件夹路径、文件列表、文件信息等。

iOS中可以通过一个全局变量来获取服务器信息，然后从不同的地方调用这个获取信息的函数。再用delegate调用该获取这个服务器信息的页面。
可以做到在一个页面的改动，实时更改另外的页面。有的地方可以省略刷新这个步骤。

之后可以自己开发一个服务器，做获取云服务器信息的验证，以及下载文件生成动态下载码。如果用于多用户，服务器还需要账号系统。
云服务器空间的管理（动态生成）。

![opencloud-01](http://wiki.huihoo.com/images/a/a9/Opencloud-01.png) ![opencloud-02](http://wiki.huihoo.com/images/0/05/Opencloud-02.png)

![opencloud-03](http://wiki.huihoo.com/images/c/c2/Opencloud-03.png) ![opencloud-04](http://wiki.huihoo.com/images/3/37/Opencloud-04.png)

http://code.huihoo.com/ios-modules/opencloud

许可协议：BSD License.
