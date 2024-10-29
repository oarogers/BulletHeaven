class_name ExperienceBar
extends ProgressBar

var player_experience_data: ExperienceData

func on_experience_updated(current_experience: int, needed_experience: int):
	value = float(current_experience) / float(needed_experience)
