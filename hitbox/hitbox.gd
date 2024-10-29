class_name Hitbox
extends Area2D

## Will hit every x seconds as long as Hurtboxes are overlapping.
@export var HIT_INTERVAL := 1.0

var hurtboxes_in_area: Array[Area2D]
var damage: int  = 1
var collision_radius

@onready var timer: Timer = $Timer


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
	timer.wait_time = HIT_INTERVAL
	timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	hit_overlapping_hurtboxes()
	if hurtboxes_in_area.size() > 0:
		timer.start()


func _on_area_entered(area: Area2D):
	hit(area)
	
	if timer.is_stopped():
		timer.start()


func hit_overlapping_hurtboxes() -> void:
	hurtboxes_in_area = get_overlapping_areas()
	for hurtbox in hurtboxes_in_area:
			hit(hurtbox)
			if hurtbox.is_queued_for_deletion():
				hurtboxes_in_area.erase(hurtbox)


func hit(area: Area2D):
	if not area is Hurtbox:
		return
	
	area = area as Hurtbox
	area.take_damage(damage)
