#version 330

in vec4 color;
in float fill_all;  // Either 0 or 1
in float uv_anti_alias_width;

in float orientation;
in vec2 uv_coords;
in float is_linear;

out vec4 frag_color;

float sdf(){
    float x0 = uv_coords.x;
    float y0 = uv_coords.y;
    if(bool(is_linear)) return abs(y0);

    float Fxy = y0 - x0 * x0;
    if(orientation * Fxy >= 0) return 0.0;

    return abs(Fxy) / sqrt(1 + 4 * x0 * x0);
}


void main() {
    if (color.a == 0) discard;
    frag_color = color;
    if (bool(fill_all)) return;
    frag_color.a *= smoothstep(1, 0, sdf() / uv_anti_alias_width);
}
