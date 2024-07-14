shader_type canvas_item;

uniform vec4 laser_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Red laser
uniform float intensity : hint_range(0.0, 3.0) = 1.0;
uniform float distortion_amount : hint_range(0.0, 0.2) = 0.05; // Amount of distortion
uniform float time_speed : hint_range(0.0, 10.0) = 1.0; // Speed of distortion

void fragment() {
    vec2 uv = UV;
    
    float time = TIME * time_speed;
    uv.y += sin(uv.x * 10.0 + time) * distortion_amount;
    uv.x += sin(uv.y * 10.0 + time) * distortion_amount;

    float glow = max(0.0, 1.0 - abs(uv.y - 0.5) * 2.0);

    vec4 lighter_color = mix(laser_color, vec4(1.0,0.5,0.5,1.0), 0.5);

    vec4 beam_color = mix(lighter_color, laser_color, abs(uv.y - 0.5) * 3.0);

    COLOR = beam_color * glow * intensity;
}
