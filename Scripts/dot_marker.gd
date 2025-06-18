extends Node2D

@export var radius: float = 15.0
@export var colour: Color = Color(0.1, 0.1, 0.1, 0.75)

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius,colour)
