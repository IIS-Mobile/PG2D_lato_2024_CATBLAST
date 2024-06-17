extends PointLight2D

var time = 0.0
var blink_interval = 0.1  
var pause_interval = 7.0  
var blink_count = 0
var is_fading = false
var fade_duration = 0.05  
var rng = RandomNumberGenerator.new()

func _process(delta):
	time += delta

	if blink_count < 3:  
		if is_fading:
			if time <= fade_duration:
				energy = lerp(1.0, 0.0, time / fade_duration)  
			else:
				energy = lerp(0.0, 1.0, (time - fade_duration) / fade_duration)  

			if time >= 2.0 * fade_duration:
				time = 0.0
				blink_count += 1
				is_fading = false
		else:
			if time >= blink_interval:
				time = 0.0
				is_fading = true
	else:
		energy = 1.0  
		if time >= pause_interval + rng.randf_range(1.0, 5.0):
			time = 0.0
			blink_count = 0
			is_fading = false
