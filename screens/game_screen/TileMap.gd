extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	for tile in get_used_cells_by_id(5):
		create_active_area(tile, 'water', 1)
	
	var this_y = 0
	var this_x = 0
	var tiles_group = {}
	var n_areas = -1
	var this = Vector2()
	for tile in get_used_cells_by_id(6):
		# is it a group of tiles area? 
		if this_x == tile.x -1 and this_y == tile.y:
			tiles_group[n_areas].append(tile)
			this_x = tile.x
		#it is a new area
		else:
			n_areas += 1
			tiles_group[n_areas] = [tile]
			this_y = tile.y
			this_x = tile.x
		# create_active_area(tile, 'water_surface', 0.4)

	
	for index_area in tiles_group:
		create_big_active_area(tiles_group[index_area], 'water_surface', 0.4)
	
	for tile in get_used_cells_by_id(8):
		create_active_area(tile, 'lava', 0.4)
		
	for tile in get_used_cells_by_id(9):
		create_active_area(tile, 'spikes', 0.4)
		
func create_active_area(tile, name, height):
	var a2d = Area2D.new()
	var cs = CollisionShape2D.new()
	cs.shape = RectangleShape2D.new()
	cs.shape.extents.x = cell_size.x/2
	cs.shape.extents.y = cell_size.y/2 * height
	cs.position = map_to_world(tile)+cell_size/2
	
	# adjust position for non-full height areas
	cs.position.y += (1-height)*cell_size.y/2
	
	# connect signals
	a2d.connect('body_entered', self, '_on_area_entered', [name])
	a2d.connect('body_exited', self, '_on_area_exited', [name])
	
	# append nodes
	a2d.add_child(cs)
	add_child(a2d)

func create_big_active_area(tiles, name, height):
	print(tiles[0])
	var length = len(tiles)
	var a2d = Area2D.new()
	var cs = CollisionShape2D.new()
	cs.shape = RectangleShape2D.new()
	cs.shape.extents.x = cell_size.x/2 * len(tiles)
	cs.shape.extents.y = cell_size.y/2 * height
	cs.position = map_to_world(tiles[((length)/2)])+cell_size/2
	# adjust for odd number tiles
	if not length % 2:
		cs.position.x -= cell_size.x/2
	
	# adjust position for non-full height areas
	cs.position.y += (1-height)*cell_size.y/2
	
	# connect signals
	a2d.connect('body_entered', self, '_on_area_entered', [name])
	a2d.connect('body_exited', self, '_on_area_exited', [name])
	
	# append nodes
	a2d.add_child(cs)
	add_child(a2d)
	

func _on_area_entered(body, tile_name):
	if body.is_in_group("player"):
		body.zone_entered(tile_name)
	
func _on_area_exited(body, tile_name):
	if body.is_in_group("player"):
		body.zone_exited(tile_name)
	