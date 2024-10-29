class_name Projectile
extends Node2D

@export var speed: float = 200.0
@export var MAX_DISTANCE: float = 320.0

var target: Node2D = null
var direction := Vector2.RIGHT
var traveled_distance: float = 0.0
var damage: int = 1

@onready var hitbox: Hitbox = $Hitbox


func _ready() -> void:
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	hitbox.damage = damage


func set_target(new_target: Node2D):
	target = new_target
	if target:
		direction = global_position.direction_to(target.global_position)


func _process(delta):
	if is_instance_valid(target):
		direction = global_position.direction_to(target.global_position)
	
	move_and_check_range(delta)


func move_and_check_range(delta: float) -> void:
	var distance_to_travel = speed * delta
	traveled_distance += distance_to_travel
	position += direction * distance_to_travel
	
	if traveled_distance >= MAX_DISTANCE:
		queue_free()


func _on_hitbox_area_entered(_area: Area2D):
	queue_free()
