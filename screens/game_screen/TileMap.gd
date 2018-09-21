extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	for tile in get_used_cells_by_id(5):
		create_active_area(tile, 'water', 1)
	
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
	
func _on_area_entered(body, tile_name):
	if body.is_in_group("player"):
		body.zone_entered(tile_name)
	
func _on_area_exited(body, tile_name):
	if body.is_in_group("player"):
		body.zone_exited(tile_name)
	