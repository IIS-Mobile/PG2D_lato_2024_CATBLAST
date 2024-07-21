shader_type canvas_item;

uniform float glow_radius : hint_range(0.0, 100.0) = 50.0;
uniform vec4 glow_color = vec4(1.0, 1.0, 1.0, 0.5);
uniform float angle_speed : hint_range(0.0, 10.0) = 1.0;
uniform float time_offset : hint_range(0.0, 10.0) = 0.0;
uniform float noise_scale : hint_range(0.0, 10.0) = 1.0;

float random(vec2 p) {
    return fract(sin(dot(p.xy, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
    vec4 tex_color = texture(TEXTURE, UV);
    vec4 final_color = tex_color;
    
    vec2 center = vec2(0.5, 0.5);
    vec2 dir = UV - center;
    float distance = length(dir);
    
    float angle = atan(dir.y, dir.x) + TIME * angle_speed + time_offset;
    
    float noise = random(floor(UV * noise_scale)) * 2.0 - 1.0;
    float cone_effect = abs(sin(angle * 10.0 + noise)) * pow(1.0 - distance, 2.0);
    float glow = smoothstep(glow_radius, glow_radius * 0.5, distance);
    
    final_color += glow_color * cone_effect * glow * (1.0 - tex_color.a);
    COLOR = final_color;
}
