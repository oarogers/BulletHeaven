class_name HealthData
extends Resource

signal health_updated(current_health, max_health)
signal died()

@export var max_health: int = 1:
	set(value):
		if value <= max_health:
			return
		max_health = value
		health_updated.emit(current_health, max_health)

var current_health: int:
	set(value):
		value = clampi(value, 0, max_health)
		if current_health == value:
			return
		current_health = value
		health_updated.emit(current_health, max_health)
		if current_health == 0:
			died.emit()


func _init(max_health: int):
	self.max_health = max_health
	self.current_health = max_health
