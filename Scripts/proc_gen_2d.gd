extends Node2D

@export var noise:FastNoiseLite
@onready var tile_map:TileMap = $TileMap
var spawn_size := 15#the number of tiles from the spawn point to the edge of the "spawning square area"

func try_create_terrain(p_spawn_world_center):
	perform_creation_iteration(spawn_size * 2,spawn_size * 2, tile_map.local_to_map(p_spawn_world_center)+ (Vector2i.UP * spawn_size) + (Vector2i.LEFT * spawn_size))
	
func perform_creation_iteration(p_width:int, p_height:int, p_offset:Vector2i) -> void:
	var _index = 0;
	var _changed_flag = false
	#iterate over each tile
	for i in p_width:#each column
		for j in p_height:#each row
			#check to make sure nothing has been spawned on the tile yet (-1 means unset)
			if tile_map.get_cell_source_id(0,Vector2i(i + p_offset.x, j + p_offset.y)) == -1:
				var _vec = Vector2i(i,j) + p_offset
				tile_map.set_cell(0,_vec, get_tile_index_using_noise(_vec), Vector2i(0, 0)) 
				_changed_flag = true
			_index = _index + 1
			
	#only update if a tile was added
	if _changed_flag:
		tile_map.force_update()
	
func get_tile_index_using_noise(p_tile_position:Vector2i)->int:
	var _val = noise.get_noise_2d(p_tile_position.x,p_tile_position.y)
	var _number_of_tiles = tile_map.tile_set.get_source_count()
	for _i in _number_of_tiles:
		var _segment =  _i  / (_number_of_tiles - 1.0)
		if _val <_segment:
			return _i
	return -1#should never get here if everything is set up right
	
