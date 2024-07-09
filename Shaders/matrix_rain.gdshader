shader_type canvas_item;

uniform sampler2D chars;
uniform sampler2D noise_tex; 

void fragment() {
	// Random character
	vec2 uv = fract(UV * 32.0); // loop uv 32 times for the characters (as the noise resolution is 32x32)
	float noise = texture(noise_tex, UV).g;
	noise = round(noise * 10.0) / 10.0; // make sure the color value are snapped by 0.1 (so its only 0.0, 0.1, 0.2, and so on) for perfect offset
	uv.x = (uv.x / 10.0) - 0.005; // offset
	uv.x += noise; // offset every character by the noise value
	uv.x += round(TIME * 0.5 * 10.0)/10.0; // animate characters with TIME, then snapped by 0.1 so it doesnt slide. 0.5 is the speed, you might want to change that
	
	// distortion
	float rain = UV.y; // this is a vertical gradient
	float distortion = texture(noise_tex, UV / vec2(1.0, 32.0)).g; // this will be used for distortion, using previous noise but only horizontal
	distortion = round(distortion * 10.0) / 10.0; // for precision reason, you need to round your distortion too, otherwise some character wouldnt be fully shown
	rain -= round(TIME * 0.2 * 32.0) / 32.0; // the 'rain' shouldn't move smoothly right? also, 0.2 is the speed
	rain += distortion; // distort this gradient, turning it into a rain
	rain = fract(rain); // loop the rain
	rain = round(rain * 16.0) / 16.0; // pixelate the rain. Rounding by 32.0 or 8.0 is optional
	rain = pow(rain, 3.0); // this is not necessary, i just think that it looks good
	rain *= 2.0; // this is also not important, just making the characters brighter
	
	COLOR.rgb = texture(chars, uv).rgb * rain * vec3(0.0, 1.0, 0.0); // finally multiply them together then multiply with green for the color
}