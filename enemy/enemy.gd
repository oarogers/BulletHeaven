class_name Enemy
extends Node2D

@export var hurtbox: Hurtbox
@export var sprite_2d: Sprite2D
@onready var hitbox: Hitbox = $Hitbox

var data: EnemyData
var texture: Texture
var health_data: HealthData
var base_damage: int
var experience_given: int
var movement_direction: Vector2
var target: Node2D


func set_data(data: EnemyData, growth_rate: float=1.0, wave_num: int=1):
	self.data = data
	texture = data.texture
	base_damage = get_scaled_stat(data.base_damage, growth_rate, wave_num)
	hitbox.damage = base_damage
	experience_given = get_scaled_stat(data.experience_given, growth_rate, wave_num)
	
	health_data = HealthData.new(get_scaled_stat(data.max_health, growth_rate, wave_num))
	health_data.died.connect(_on_died)
	hurtbox.health = health_data


func _physics_process(delta: float) -> void:
	target = Game.player
	movement_direction = global_position.direction_to(target.global_position)
	position += movement_direction * data.movement_speed * delta

func get_scaled_stat(base_stat: int, growth_rate: float, wave_num: int) -> int:
	var increased_stat = base_stat * (1.0 + ((wave_num - 1) * (growth_rate - 1.0)))
	return int(increased_stat)


func _on_died() -> void:
	Game.player.gain_experience(experience_given)
	queue_free()
