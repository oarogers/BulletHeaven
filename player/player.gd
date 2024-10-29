class_name Player
extends Node2D


@export var experience_data: ExperienceData
@export var movement_speed: float = 60

var health_data: HealthData
var damage: int = 1
var movement_direction: Vector2

@onready var hurtbox: Hurtbox = $Hurtbox
@onready var camera_2d: Camera2D = $Camera2D


func _unhandled_input(_event: InputEvent) -> void:
	if not get_tree().paused:
		movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")


func _physics_process(delta: float) -> void:
	if movement_direction != Vector2.ZERO:
		position += movement_direction * movement_speed * delta
	
	Game.viewport_rect = Rect2(camera_2d.get_screen_center_position() - (get_viewport_rect().size * camera_2d.zoom / 2),
		get_viewport_rect().size * camera_2d.zoom
	)


func gain_experience(exp_amount: int):
	experience_data.current_experience += exp_amount
