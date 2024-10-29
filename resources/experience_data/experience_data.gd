class_name ExperienceData
extends Resource

signal experience_updated(current_experience, experience_needed)
signal leveled_up(new_level)

@export var experience_curve: Curve
const MAX_LEVEL = 100

var current_level: int = 1:
	set(value):
		if value < current_level:
			return
		current_level = value
		experience_needed = get_experience_needed()
		leveled_up.emit(current_level)

var current_experience: int = 0:
	set(value):
		while value >= experience_needed:
			value -= experience_needed
			current_level += 1
		current_experience = value
		experience_updated.emit(current_experience, experience_needed)

var experience_needed: int:
	get():
		return get_experience_needed()

func get_experience_needed() -> int:
	return int(experience_curve.sample(float(current_level) / float(MAX_LEVEL)))
