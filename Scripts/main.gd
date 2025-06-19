extends Node2D

const piece_scene = preload("res://Scenes/piece.tscn")
const marker_scene = preload("res://Scenes/dot_marker.tscn")
const square_size = 125

@export var light_square_colour = Color.WHITE
@export var dark_square_colour = Color.DARK_CYAN



var starting_position = [
	"br", "bn", "bb", "bq", "bk", "bb", "bn", "br",
	"bp", "bp", "bp", "bp", "bp", "bp", "bp", "bp",
	"--", "--", "--", "--", "--", "--", "--", "--",
	"--", "--", "--", "--", "--", "--", "--", "--",
	"--", "--", "--", "--", "--", "--", "--", "--",
	"--", "--", "--", "--", "--", "--", "--", "--",
	"wp", "wp", "wp", "wp", "wp", "wp", "wp", "wp",
	"wr", "wn", "wb", "wq", "wk", "wb", "wn", "wr"
]

const UP = Vector2i(0, -1)
const DOWN = Vector2i(0, 1)
const LEFT = Vector2i(-1, 0)
const RIGHT = Vector2i(1, 0)
const UP_LEFT = Vector2i(-1, -1)
const UP_RIGHT = Vector2i(1, -1)
const DOWN_LEFT = Vector2i(-1, 1)
const DOWN_RIGHT = Vector2i(1, 1)

const ROOK_DIRECTIONS = [UP, DOWN, LEFT, RIGHT]
const BISHOP_DIRECTIONS = [UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT]
const QUEEN_DIRECTIONS = ROOK_DIRECTIONS + BISHOP_DIRECTIONS

const KNIGHT_MOVES = [
	Vector2i(1, 2), Vector2i(1, -2), Vector2i(-1, 2), Vector2i(-1, -2),
	Vector2i(2, 1), Vector2i(2, -1), Vector2i(-2, 1), Vector2i(-2, -1)
]
const KING_MOVES = QUEEN_DIRECTIONS

func _ready():
	setup_board()
	setup_pieces()
	
func setup_board():
	for i in 64:
		var file = i % 8
		var rank = i / 8

		var square = ColorRect.new()

		if (file + rank) % 2 == 0:
			square.color = dark_square_colour
		else:
			square.color = light_square_colour

		square.size = Vector2(square_size, square_size)
		square.position = Vector2(file * square_size, rank * square_size)
		
		square.mouse_filter = Control.MOUSE_FILTER_IGNORE
		square.z_index = 0

		add_child(square)

func setup_pieces():
	for i in starting_position.size():
		var piece_code = starting_position[i]
		
		if piece_code != "--":
			var new_piece = piece_scene.instantiate()
			
			var piece_colour = piece_code[0]
			var piece_type = piece_code[1]
			
			if piece_colour == "w":
				new_piece.colour = "white"
			else:
				new_piece.colour = "black"
			
			match piece_type:
				"p": new_piece.type = "pawn"
				"r": new_piece.type = "rook"
				"n": new_piece.type = "knight"
				"b": new_piece.type = "bishop"
				"q": new_piece.type = "queen"
				"k": new_piece.type = "king"
			
			var file = i % 8 # e.g. 0rem1 when 1, 0rem1 when 9
			var rank = i / 8 # 0 when piece 0-7, 1 when piece 8-15, etc.
			
			var x_pos = file * square_size + (square_size / 2)
			var y_pos = rank * square_size + (square_size / 2)
			
			new_piece.position = Vector2(x_pos, y_pos)
			new_piece.z_index = 1

			new_piece.selected_piece.connect(_on_piece_selected)

			add_child(new_piece)

func _on_piece_selected(piece):
	clear_markers()

	var valid_moves = []
	var starting_position_grid = piece.position / square_size

	print(piece.type)

	match piece.type:
		"rook": valid_moves = get_sliding_moves(starting_position_grid, ROOK_DIRECTIONS)
		"bishop": valid_moves = get_sliding_moves(starting_position_grid, BISHOP_DIRECTIONS)
		"queen": valid_moves = get_sliding_moves(starting_position_grid, QUEEN_DIRECTIONS)
		"knight": valid_moves = get_leap_moves(starting_position_grid, KNIGHT_MOVES)
		"pawn": valid_moves = get_pawn_moves(starting_position_grid, piece.colour)
		"king": valid_moves = get_leap_moves(starting_position_grid, KING_MOVES)

	create_marker(valid_moves)

func get_sliding_moves(start: Vector2i, directions: Array) -> Array:
	var moves = []

	for dir in directions:
		var current_position = start + dir
		while current_position.x >= 0 and current_position.x < 8 and current_position.y >= 0 and current_position.y < 8:
			moves.append(current_position)
			current_position += dir
	
	return moves

func get_leap_moves(start:Vector2i, move_offset: Array) -> Array:
	var moves = []
	for offset in move_offset:
		var target_pos = start + offset
		if target_pos.x >= 0 and target_pos.x < 8 and target_pos.y >= 0 and target_pos.y < 8:
			moves.append(target_pos)

	return moves

func get_pawn_moves(start: Vector2i, colour: String):
	var moves = []
	var direction = -1 if colour == "white" else 1

	var one_step_move = start + Vector2i(0, direction)
	if one_step_move.y >= 0 and one_step_move.y < 8:
		moves.append(one_step_move)

	var start_rank = 6 if colour == "white" else 1
	if start.y == start_rank:
		var two_step_move = start + Vector2i(0, direction * 2)
		moves.append(two_step_move)

	return moves

func create_marker(moves: Array):
	for move_grid_position in moves:
		var marker = marker_scene.instantiate()
		marker.add_to_group("markers")
		marker.z_index = 2
		marker.position = move_grid_position * square_size + Vector2i(square_size / 2, square_size / 2)
		add_child(marker)

func clear_markers():
	get_tree().call_group("markers", "queue_free")
