extends Area2D

signal selected_piece(piece)

@export_enum("white", "black") var colour: String = "white"
@export_enum("pawn", "rook", "knight", "bishop", "queen", "king") var type: String = "pawn"	

func _ready():
	update_texture()
	
func update_texture():
	var tex_path = "res://Assets/Pieces/" + colour + "-" + type + ".png"
	$Sprite.texture = load(tex_path)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		emit_signal("selected_piece", self)
