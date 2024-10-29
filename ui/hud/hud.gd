extends CanvasLayer

@onready var health_bar: HealthBar = %HealthBar
@onready var experience_bar: ExperienceBar = %ExperienceBar
@onready var time_label: Label = %TimeLabel


func update_time_display(time_string: String) -> void:
	time_label.text = time_string
