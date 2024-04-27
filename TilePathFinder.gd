@tool
extends Node2D

@export var print_debug := false : set = set_print_debug

@export_node_path("TileMap") var tilemap_path: NodePath
@onready var tilemap: TileMap = get_node(tilemap_path)

var graph = AStar2D.new()

var points: Array[Vector2i]

func _ready() -> void:
	create_points()
	queue_redraw()

func create_points():
	for layer in range(tilemap.tile_set.get_physics_layers_count()):
		print(layer)
		var cells = tilemap.get_used_cells(layer)
		for cell in cells:
			var cell_above = Vector2i(cell.x, cell.y-1)
			var cell_tile_data := tilemap.get_cell_tile_data(layer, cell)
			var cell_above_tile_data := tilemap.get_cell_tile_data(layer, cell_above)
			if cell_tile_data == null:
				continue
			
			#print(cell_above_tile_data.get_collision_polygons_count(collisions_cells_layer))
			
			#if layer == 1:
				#print(cell_tile_data.get_collision_polygons_count(layer))
			#var b = (cell_above_tile_data == null or cell_above_tile_data.get_collision_polygons_count(layer) == 0)
			#var a = cell_tile_data.get_collision_polygons_count(layer) > 0
			#cell_tile_data.
			if layer == 1:
				print(cell_tile_data.get_collision_polygon_points(layer, 2))
			if cell_tile_data.get_collision_polygons_count(layer) > 0:
				#print(cell_above)
				points.append(cell_above)

func _draw() -> void:
	for point in points:
		#draw_circle(point * tilemap.tile_set.tile_size + tilemap.tile_set.tile_size/2, 8, Color.RED)
		pass


func set_print_debug(v):
	points = []
	create_points()
	queue_redraw()
