// NOTE: Shader automatically converted from Godot Engine 4.2.dev's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,unshaded;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;

uniform vec2 tiling = vec2(1.0, 1.0);
uniform vec2 offset = vec2(0.0, 0.0);

uniform sampler2D mask;

uniform sampler2D erosion;
uniform sampler2D erosion_curve;
uniform float erosion_max_offset;

varying float lifetime;

void vertex() {
	lifetime = INSTANCE_CUSTOM.y;
	UV = UV * tiling + offset;
}


void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	albedo_tex *= COLOR;
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	ALPHA *= albedo.a * albedo_tex.a;
	ALPHA *= texture(mask, UV).r;
	
	vec4 erosion_tex = texture(erosion, UV);
	float erosion_curve_val = texture(erosion_curve, vec2(lifetime)).r;
	
	float erosion_val = smoothstep(erosion_curve_val, erosion_curve_val + erosion_max_offset, erosion_tex).r;
	ALPHA *= erosion_val;
}
