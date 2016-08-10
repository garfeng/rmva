# 一些RMVA的脚本

### 使用规约

本仓库下所有的代码遵循MIT协议，您可以自由的用于任何类型，任何商业或非商业的游戏。

您可以根据需要，自由的修改协议，或者加密闭源。

但请在您的license文件里，保留本仓库下代码的来源，和所使用的MIT协议。

规约详情见：[The MIT License](https://github.com/garfeng/rmva/blob/master/LICENSE)

----

## 简易自动寻路

RMVA 的简易自动寻路，因为调用的是系统自带的寻路算法，所以不能绕路……

遇到挡路的障碍会直接跳过。

代码主体只有30行。

[链接](https://github.com/garfeng/rmva/blob/master/src/move_toward.rb)


----

## rtp提取工具

在游戏运行时移动用到的bgm和图片到游戏目录下。

[链接](https://github.com/garfeng/rmva/blob/master/src/rtp_get.rb)


----

## fuki对话框

呼出对话框（可以用，优化中）

[链接](https://github.com/garfeng/rmva/blob/master/src/fuki.rb)


----

## y 坐标偏移

给事件不同的y坐标偏移

可以实现椅子的效果，以及摆放物品的错落效果

[链接](https://github.com/garfeng/rmva/blob/master/src/shift_alter.rb)


----

## 事件 blend type 预加载

进入地图时事件的blend type已经显现好，无需手动操作

[链接](https://github.com/garfeng/rmva/blob/master/src/pre_load_event.rb)


----