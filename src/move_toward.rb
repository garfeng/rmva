#encoding:utf-8
#==============================================================================
# RMVA 自动寻路 by garfeng
# 移动一步：move_to(from_id,to_id) id如果是0，则表示人物
# 		 ： move_to(from_id,to_x,to_y)
# 移动直到指定位置：move_loop_to(from_id,to_id)
#				: move_loop_tp(from_id,to_x,to_y)
# 坐标可以看编辑器右下角
#==============================================================================

class Py_Tmp
	attr_reader   :x
	attr_reader   :y

	def initialize(x,y)
		@x, @y = x,y
	end
end

def move_obj_to_obj(a,b)
	a.move_toward_character(b)
	Fiber.yield while a.moving?
	return  a.move_succeed && ( a.x != b.x || a.y != b.y )
end

def get_obj(id)
	return (id == 0 ? $game_player : $game_map.events[id])
end

def move_to(a,b,c = -1)
	from = get_obj(a)
	to = (c == -1 ?  get_obj(b) : Py_Tmp.new(b,c))
	return move_obj_to_obj(from,to)
end

def move_loop_to(a,b,c = -1)
	tbc = true
	while tbc do
		tbc = move_to(a,b,c)
	end
end