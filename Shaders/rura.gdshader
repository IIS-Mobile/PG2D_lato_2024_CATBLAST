shader_type canvas_item;

uniform float OFFSET : hint_range(0.0, 1.0); // Control the offset for each pipe

void fragment() {
    // Calculate the wave position based on TIME and OFFSET
    float wavePosition = mod(TIME / 10.0, 1.0); // Control the wave position over time

	wavePosition += OFFSET;
	wavePosition = mod(wavePosition,1.0);
    float waveThickness = 0.016; // Total thickness of the wave (approx. 2 pixels on either side)
    float smoothRange = 0.008;   // Half the thickness for smooth edges (approx. 1 pixel on either side)

    // Calculate the smooth transition factor
    float distanceFromWave = abs(UV.y - wavePosition);
    float alpha = smoothstep(smoothRange, 0.0, distanceFromWave);

    // Check if the current pixel's UV.y is within the 3-4 pixel range of the wave
    if (abs(UV.y - wavePosition) < 0.007) { // Adjust the range as needed
        // Apply the color change effect
        COLOR = texture(TEXTURE, UV);
        COLOR.a *= alpha;
    } else {
        // Make the pixel fully transparent
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    }
}
