class_name BasicProjectileSkill
extends Node2D

@export var projectile_scene: PackedScene

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	attack()


func attack() -> void:
	var target = find_nearest_enemy()
	if is_instance_valid(target):
		throw_projectile_at(target)


func find_nearest_enemy() -> Enemy:
	var enemies = get_tree().get_nodes_in_group("enemies")

	enemies = enemies.filter(func(enemy: Node2D) -> bool:
		return Game.viewport_rect.has_point(enemy.global_position) \
			and enemy.global_position.distance_squared_to(owner.global_position) <= pow(250.0, 2)
	)
	
	if enemies.size() == 0:
		return null
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		return a.global_position.distance_squared_to(owner.global_position) \
			< b.global_position.distance_squared_to(owner.global_position)
	)
	
	return enemies[0]

## projectile moves on its own
func throw_projectile_at(target: Enemy):
	var projectile = projectile_scene.instantiate() as Projectile
	projectile.set_target(target)
	projectile.damage = Game.player.damage
	owner.get_parent().add_child(projectile)
	projectile.global_position = global_position
