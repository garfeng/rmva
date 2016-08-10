#encoding:utf-8
#==============================================================================
# ■ Window_Message
#------------------------------------------------------------------------------
# 　显示文字信息的窗口。
#==============================================================================


#==============================================================================
# fuki by garfeng
# 我写的第一个ruby代码，满满的糟点和黑历史……以后会优化的
# 使用方法：
# 显示文本，填入
# u[event_id]你好！
# 或者
# u[0]你好，我是阿尔西斯！
#
# 普通窗口背景则为呼出对话框，暗色背景则为横向居中显示的文字。
# 设置头像后可以多显示一个头像窗口
# 请自备两个呼出箭头（小气泡），文件名分别为 "system/sharp_up.png" ,"system/sharp_down.png"
# 对话框会跟着人物跑哦~
#==============================================================================


# 脸图窗口
class Window_Face < Window_Base

  def initialize
    super(0, 0, 96 + 2 * standard_padding, 96 + 2 * standard_padding)
    self.z = 200
    self.visible = false
    fukiId = -1
  end

  def update_placement(x,y,height,down)
    self.x = x - self.width
    if !down
      self.y = y + height - self.height
    else
      self.y = y
    end
  end

  def draw_face
    super($game_message.face_name, $game_message.face_index, 0, 0)
  end

  def need_show(fukiId)
    if fukiId == -1
      false
    else
      $game_message.face_name.empty? ? false : true
    end
    end
end



class Window_Message < Window_Base
   #attr_reader   :firstCode
  #--------------------------------------------------------------------------
  # ● 初始化对象
  #--------------------------------------------------------------------------
  #    bitmap = Cache.system("Iconset")
  #    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
  #    contents.blt(x, y, bitmap, rect, enabled ? 255 : translucent_alpha)
  def initialize
    super(0, 0, window_width, window_height)
    @fukiId = -1;
    @down = false
    init_fuki_sharp
    self.z = 200
    self.openness = 0
    create_all_windows
    create_back_bitmap
    create_back_sprite
    clear_instance_variables

  end
  
  #--------------------------------------------------------------------------
  # ● 输出一个字符后的等待
  #--------------------------------------------------------------------------
  def wait_for_one_character
    wait(1)
    update_show_fast
    Fiber.yield unless @show_fast || @line_show_fast
  end

def init_fuki_sharp
    @fuki_sharp_up = Sprite.new
    @fuki_sharp_down = Sprite.new
    @fuki_sharp_up.bitmap = Cache.system("sharp_up")
    @fuki_sharp_down.bitmap = Cache.system("sharp_down")
    @fuki_sharp_up.visible = false
    @fuki_sharp_down.visible = false
    @fuki_sharp_up.ox = @fuki_sharp_up.bitmap.width - 2
    @fuki_sharp_up.oy = @fuki_sharp_up.bitmap.height
    @fuki_sharp_down.ox = 2
    @fuki_sharp_down.oy = 0
    @fuki_sharp_up.z = 300
    @fuki_sharp_down.z = 300
end

def dispose_sharp
    @fuki_sharp_up.bitmap.dispose
    @fuki_sharp_down.bitmap.dispose
    @fuki_sharp_up.dispose
    @fuki_sharp_down.dispose
end

def close_sharp
    @fuki_sharp_up.visible = false
    @fuki_sharp_down.visible = false

end

  #--------------------------------------------------------------------------
  # ● 获取窗口的宽度
  #--------------------------------------------------------------------------
  def window_width
    if @fukiId == -1 
        return Graphics.width
    else
        if @background == 1
          return Graphics.width
        else
          return Graphics.width*2/3
        end
    end
  end



  #--------------------------------------------------------------------------
  # ● 释放
  #--------------------------------------------------------------------------
  def dispose
    super
    dispose_all_windows
    dispose_back_bitmap
    dispose_back_sprite
    dispose_sharp
    @face_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● 更新画面
  #--------------------------------------------------------------------------
  def update
    super
    update_all_windows
    update_back_sprite
    update_fiber
    if @fukiId > -1
        update_placement
    end
  end

  #--------------------------------------------------------------------------
  # ● 生成所有窗口
  #--------------------------------------------------------------------------
  def create_all_windows
    @gold_window = Window_Gold.new
    @gold_window.x = Graphics.width - @gold_window.width
    @gold_window.y = 0
    @gold_window.openness = 0
    @choice_window = Window_ChoiceList.new(self)
    @number_window = Window_NumberInput.new(self)
    @item_window = Window_KeyItem.new(self)
    @face_window = Window_Face.new
  end
  #--------------------------------------------------------------------------
  # ● 生成背景位图
  #--------------------------------------------------------------------------
  def create_back_bitmap
    @back_bitmap = Bitmap.new(Graphics.width, height)
    rect1 = Rect.new(0, 0, Graphics.width, 12)
    rect2 = Rect.new(0, 12, Graphics.width, height - 24)
    rect3 = Rect.new(0, height - 12, Graphics.width, 12)
    @back_bitmap.gradient_fill_rect(rect1, back_color2, back_color1, true)
    @back_bitmap.fill_rect(rect2, back_color1)
    @back_bitmap.gradient_fill_rect(rect3, back_color1, back_color2, true)
  end

  def update_back_bitmap
    rect1 = Rect.new(0, 0, Graphics.width, 12)
    rect2 = Rect.new(0, 12, Graphics.width, height - 24)
    rect3 = Rect.new(0, height - 12, Graphics.width, 12)
    rect4 = Rect.new(0,height,Graphics.width,@back_bitmap.height-height);
    @back_bitmap.gradient_fill_rect(rect1, back_color2, back_color1, true)
    @back_bitmap.fill_rect(rect2, back_color1)
    @back_bitmap.gradient_fill_rect(rect3, back_color1, back_color2, true)
    @back_bitmap.fill_rect(rect4, back_color2)
  end

  
  #--------------------------------------------------------------------------
  # ● 更新所有窗口
  #--------------------------------------------------------------------------
  def update_all_windows
    @gold_window.update
    @choice_window.update
    @number_window.update
    @item_window.update
    @face_window.update
  end
 
  #--------------------------------------------------------------------------
  # ● 更新窗口的位置
  #--------------------------------------------------------------------------
  def update_placement
    down_tmp = false
    idx = 0
    idy = 0
    if @fukiId == 0
        idy = $game_map.adjust_y($game_player.real_y)*32
        idx = $game_map.adjust_x($game_player.real_x)*32 + 16
    elsif @fukiId > 0
        idy = $game_map.adjust_y($game_map.events[@fukiId].real_y)*32
        idx = $game_map.adjust_x($game_map.events[@fukiId].real_x)*32 + 16
    else
      self.y = @position * (Graphics.height - height) / 2
      self.x = 0
    end

    #puts @face_window.visible,self.visible

    if @background == 1
      idx = Graphics.width/2
      idy = @position*(Graphics.height - 100)/2 + 50 + height
    end

    tmp_y =  idy - self.height - 23
    tmp_x =  idx - self.width/2

    face_window_x = update_face_window_x(tmp_x)
    face_window_y = update_face_window_y(tmp_y,down_tmp)

    if tmp_y < 0 || (@face_window.visible && face_window_y < 0)
        @down = true
        down_tmp = true
        tmp_y = idy + 32 + 23
    end

    if tmp_x < 0 || (@face_window.visible && face_window_x < 0)
        tmp_x = @face_window.visible ? @face_window.width : 0
    end

    if tmp_x + self.width > Graphics.width
        tmp_x = Graphics.width - self.width
    end

    if @fukiId > -1
      self.x = tmp_x
      self.y = tmp_y      
      @face_window.update_placement(self.x,self.y,self.height,@down)
      if down_tmp 
          @fuki_sharp_down.x = idx
          @fuki_sharp_down.y = idy + 32 + 10
          @fuki_sharp_down.visible = @background == 0 ? true : false
          @fuki_sharp_up.visible = false
      else
          @fuki_sharp_up.x = idx
          @fuki_sharp_up.y = idy - 10
          @fuki_sharp_up.visible = @background == 0 ? true : false
          @fuki_sharp_down.visible = false
      end
    end


    @gold_window.y = y > 0 ? 0 : Graphics.height - @gold_window.height
  end

  def update_face_window_x(tmp_x)
    return tmp_x - @face_window.width
  end

  def update_face_window_y(tmp_y,down)
    if !down
      return tmp_y + self.height - @face_window.height
    else
      return tmp_y
    end
  end

  #--------------------------------------------------------------------------
  # ● 处理所有内容
  #--------------------------------------------------------------------------
  def process_all_text
    @fukiId = -1;
    @down = false;
    text = convert_escape_characters($game_message.all_text)
    if text[0] == "u"
        text.slice!(0,1);
        @fukiId = obtain_escape_param(text)
    end
    @background = $game_message.background
    self.width = window_width
    pos = {}
    new_page(text, pos)
    open_and_wait
   
    text_tmp = text
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end

  #--------------------------------------------------------------------------
  # ● 打开窗口并等待窗口开启完成
  #--------------------------------------------------------------------------
  def open_and_wait
    open
    @face_window.open
    Fiber.yield until ( open? && @face_window.open? )
  end
  #--------------------------------------------------------------------------
  # ● 关闭窗口并等待窗口关闭完成
  #--------------------------------------------------------------------------
  def close_and_wait
    close
    @face_window.close
    @fukiId = -1
    close_sharp
    Fiber.yield until all_close?
  end
  
  #--------------------------------------------------------------------------
  # ● 翻页处理
  #--------------------------------------------------------------------------
  def new_page(text, pos)
    @down = false
    @fuki_sharp_down.visible = false
    @fuki_sharp_up.visible = false
    @line_num = 0
    @max_width = 0
    @position = $game_message.position
    text_tmp = text.rstrip
    if @fukiId > -1
      calc_width(text_tmp)
      self.width = @max_width + standard_padding*2
      self.height = fitting_height(@line_num + 1 > 4 ? 4 : @line_num + 1)
    else
      self.width = Graphics.width
      self.height = fitting_height(4)
      update_placement
    end
    update_back_bitmap
    contents.dispose
    create_contents
    contents.clear

    @face_window.visible = @face_window.need_show(@fukiId)
    draw_face
    reset_font_settings
    pos[:x] = new_line_x
    pos[:y] = 0
    pos[:new_x] = new_line_x
    pos[:height] = calc_line_height(text)
    clear_flags
  end
  #--------------------------------------------------------------------------
  # ● 获取换行位置
  #--------------------------------------------------------------------------
  def new_line_x
    if @fukiId == -1
      $game_message.face_name.empty? ? 0 : 112
    else
      0
    end
  end


  def draw_face
    if @fukiId == -1
      super($game_message.face_name, $game_message.face_index, 0, 0)
    else
      @face_window.draw_face
    end
  end

  #--------------------------------------------------------------------------
  # ● 文字的处理
  #     c    : 文字
  #     text : 绘制处理中的字符串缓存（字符串可能会被修改）
  #     pos  : 绘制位置 {:x, :y, :new_x, :height}
  #--------------------------------------------------------------------------
  def process_character(c, text, pos)
    case c
    when "\r"   # 回车
      return
    when "\n"   # 换行
      process_new_line(text, pos)
    when "\f"   # 翻页
      process_new_page(text, pos)
    when "\e"   # 控制符
      process_escape_character(obtain_escape_code(text), text, pos)
    else        # 普通文字
      process_normal_character(c, pos,text)
    end
  end

  #计算宽度
  def calc_width(text)
    lines = Array.new(10,0)
    calc_c_width(text.slice!(0, 1), text,lines) until text.empty?
    @max_width = @max_width < lines[@line_num] ? lines[@line_num] : @max_width
  end

  def calc_new_line(lines)
    @max_width = @max_width < lines[@line_num] ? lines[@line_num] : @max_width
    @line_num += 1
  end

  def calc_c_width(c, text,lines)
    case c 
    when "\r"
    when "\n"
        calc_new_line(lines)
    when "\f"
    when "\e"
        obtain_escape_code(text)
        obtain_escape_param(text)
    else
        calc_normal_c(c,lines)
    end
  end

  def calc_normal_c(c,lines)
    text_width = text_size(c).width
    if lines[@line_num] + text_width > window_width - standard_padding*2
        @max_width = lines[@line_num]
        @line_num += 1
    end
    lines[@line_num] += text_size(c).width
  end

    # 处理普通文本
  
  def process_normal_character(c, pos, text)
    text_width = text_size(c).width
    if pos[:x] + text_width > contents_width
        process_new_line(text,pos)
    end
    draw_text(pos[:x], pos[:y], text_width * 2, pos[:height], c)
    pos[:x] += text_width
    wait_for_one_character
  end

 
end
