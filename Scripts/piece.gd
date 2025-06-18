extends Area2D

const marker_scene = preload("res://Scenes/dot_marker.tscn")

@export var colour = "white"
@export var type = "pawn"

const square_size = 125
var mult = 1
var switch = 1

func _ready():
	update_texture()
	
func update_texture():
	var tex_path = "res://Assets/Pieces/" + colour + "-" + type + ".png"
	$Sprite.texture = load(tex_path)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			get_parent().clear_markers()
			if type == "pawn":
				if colour == "white":
					mult = -1
				for i in 2:
					var marker_piece = marker_scene.instantiate()

					marker_piece.add_to_group("markers")

					marker_piece.position = Vector2((self.position.x), (self.position.y + (mult*((i+1) * square_size))))
					get_parent().add_child(marker_piece)
			if type == "knight":
				switch = 1
				if colour == "white":
					mult = -1
				for i in 2:
					var marker_piece = marker_scene.instantiate()

					marker_piece.add_to_group("markers")

					marker_piece.position = Vector2(self.position.x + (mult * switch * square_size), (self.position.y + (mult * 2 * square_size)))
					switch -= 2
					get_parent().add_child(marker_piece)
