#encoding:utf-8
#==============================================================================
#ACE rtp提取工具，by garfeng
#只能提取bgm，和图片
#请把原始rtp复制一份使用，不要使用原始的rtp路径
#因为是移动文件，而非复制。 
#==============================================================================


$rootDir = "../rtp/"

def mvBgm(bgm)
  name = bgm.name
  p name
  path = "Audio/BGM/" + name + ".ogg"
  exist = File.exist?(path)
  if !exist 
    ori = $rootDir + path
    if File.exist?(ori)
      File.rename(ori,path)
    end
  end
end

def mvImg(img)
  path1 = img+".png"
  path2 = img+".jpg"
  exist = File.exist?(path1) || File.exist?(path2)
  if !exist
    ori1 = $rootDir + path1
    ori2 = $rootDir + path2
    if File.exist?(ori1)
      File.rename(ori1,path1)
    elsif File.exist?(ori2)
      file.rename(ori2,path2)
    end
  end
end


module Cache

  class <<self; alias back_normal_bitmap normal_bitmap; end
  def self.normal_bitmap(path)
    mvImg(path)
    back_normal_bitmap(path)
  end

end

class Game_Map

  alias back_autoplay autoplay
  def autoplay
    if @map.autoplay_bgm
      mvBgm(@map.bgm)
    end
    back_autoplay
  end

end

module BattleManager

  def self.play_battle_bgm
    mvBgm($game_system.battle_bgm)
    $game_system.battle_bgm.play
    RPG::BGS.stop
  end

end

class Game_Vehicle < Game_Character

  alias back_get_on get_on
  def get_on
    mvBgm(system_vehicle.bgm)
    back_get_on
  end

  alias back_get_off get_off
  def get_off
    mvBgm(@walking_bgm)
    back_get_off
  end

end

class Scene_Title < Scene_Base

  alias back_play_title_music play_title_music
  def play_title_music
    mvBgm($data_system.title_bgm)
    back_play_title_music
  end

end

class Game_Interpreter
 
  alias back_command_241 command_241
  def command_241
    mvBgm(@params[0])
    back_command_241
  end
 
end