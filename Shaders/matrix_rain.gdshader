shader_type canvas_item;

uniform sampler2D noise_tex;

// Function to generate pseudo-random numbers
float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = fract(UV); // loop uv 32 times for the characters (as the noise resolution is 32x32)
    float noise = texture(noise_tex, uv).g;
    noise = round(noise); // make sure the color value are snapped by 0.1 (so its only 0.0, 0.1, 0.2, and so on) for perfect offset
    uv.x = (uv.y) - 0.0005; // offset
    uv.x += noise; // offset every character by the noise value
    uv.x += round(TIME); // animate characters with TIME, then snapped by 0.1 so it doesn't slide. 0.5 is the speed, you might want to change that

    // Generate a random character using pseudo-random function
    float rand_val = random(uv + TIME);
    int char_index = int(floor(rand_val * 10.0)); // Generate a random digit (0-9)
    float digit = float(char_index); // Convert digit to a floating-point value

    // distortion
    float rain = UV.y; // this is a vertical gradient
    float distortion = texture(noise_tex, UV / vec2(1.0, 32.0)).g; // this will be used for distortion, using previous noise but only horizontal
    distortion = round(distortion * 10.0) / 10.0; // for precision reason, you need to round your distortion too, otherwise some character wouldn't be fully shown
    rain -= round(TIME * 2.0 * 32.0) / 32.0; // the 'rain' shouldn't move smoothly right? also, 0.2 is the speed
    rain += distortion; // distort this gradient, turning it into a rain
    rain = fract(rain); // loop the rain

	COLOR.rgb = vec3(digit, 1.0, digit) * rain * 0.1 * vec3(0.0, 1.0, 0.0); // finally multiply them together then multiply with green for the color
}
