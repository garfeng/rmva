#encoding:utf-8
#==============================================================================
# shift alter by garfeng
# 给事件不同的y坐标偏移
# 可以实现椅子的效果，以及摆放物品的错落效果
# 使用方法：
# 绘制地图时，绘制region，说明见下
#==============================================================================


class Game_CharacterBase
  def shift_y
    region_id = $game_map.region_id(@x,@y)
    case region_id
    when 5
      object_character? ? 0 : -2 # 5：人物下移2
    when 6
      object_character? ? 0 : 16 # 6：人物上移16
    when 7
      object_character? ? 0 : 16 # 7：人物上移16
    when 8
      object_character? ? 16 : 4 # 8：图块事件/文件名!开头的事件 上移16
    when 4 
      object_character? ? -10 : 4 # 4：图块事件/文件名!开头的事件 下移10
    else
      object_character? ? 0 : 4
    end
  end
end