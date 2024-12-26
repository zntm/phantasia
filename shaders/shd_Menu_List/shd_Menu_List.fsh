//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 area;

void main()
{
	vec4 base = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	
	base.a *= clamp((1.0 - (abs(((area.x + area.y) / 2.0) - v_vTexcoord.y) * 3.5)) * 8.0, 0.0, 1.0);
	
	gl_FragColor = base;
}