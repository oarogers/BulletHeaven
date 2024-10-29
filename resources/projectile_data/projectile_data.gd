class_name ProjectileData
extends Node


@export var player_hitbox_radius: float = 2.0
@export var enemy_hitbox_radius: float = 1.5

var is_from_player: bool = true

@onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D

func _ready() -> void:
	var collision_shape = CircleShape2D.new()
	
	if is_from_player:
		collision_shape.radius = player_hitbox_radius
	else:
		collision_shape.radius = enemy_hitbox_radius
	hitbox_collision_shape.shape = collision_shape
