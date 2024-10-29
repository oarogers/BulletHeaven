extends Node2D


func _draw():
	draw_rect(Game.viewport_rect, Color(1, 0, 0, 0.5), true)


func _process(delta: float) -> void:
	queue_redraw()
