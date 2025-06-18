extends Node2D

const piece_scene = preload("res://Scenes/piece.tscn")
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
		square.z_index = 0
		square.mouse_filter = Control.MOUSE_FILTER_IGNORE

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

			add_child(new_piece)

func clear_markers():
	get_tree().call_group("markers", "queue_free")