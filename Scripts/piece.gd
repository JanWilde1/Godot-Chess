extends Area2D

@export var colour = "white"
@export var type = "pawn"

func _ready():
	update_texture()
	
func update_texture():
	var tex_path = "res://Assets/Pieces/" + colour + "-" + type + ".png"
	$PieceSprite.texture = load(tex_path)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			print(colour, " ", type, " Pressed")