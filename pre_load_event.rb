#encoding:utf-8
#----------------------------------------------------------------------------
# pre load event by garfeng
# 事件的合成属性预加载
# 比如增加一个加法的事件，在进入地图时即已经是加法
# 使用方法：
# 添加事件，在名称里添加 ：bm1
#----------------------------------------------------------------------------

class Game_Event < Game_Character

  #--------------------------------------------------------------------------
  # ● 设置事件页的设置
  #--------------------------------------------------------------------------
  alias back_setup_page_settings setup_page_settings
  def setup_page_settings
    back_setup_page_settings
    if self.instance_variable_get(:@event).name =~ /bm1/
      #p self.instance_variable_get(:@event).name
      @blend_type = 1
    end
  end
end