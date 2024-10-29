class_name HealthBar
extends ProgressBar

@export var gradient_texture: GradientTexture1D

var player_health_data: HealthData
var fill_stylebox: StyleBoxFlat


func _ready() -> void:
	fill_stylebox = get_theme_stylebox("fill")


func on_health_updated(current_health: int, max_health: int):
	value = float(current_health) / float(max_health)


func force_update_health_display():
	value = float(player_health_data.current_health) / float(player_health_data.max_health)


func _on_value_changed(new_value: float) -> void:
	fill_stylebox.bg_color = gradient_texture.gradient.sample(new_value)
