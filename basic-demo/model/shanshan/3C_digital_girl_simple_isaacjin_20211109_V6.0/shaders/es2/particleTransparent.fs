precision highp float;
uniform int albedousage;
uniform sampler2D albedo;
uniform vec4 color;

varying vec2 v_UV0;
varying vec4 v_Col;
void main()
{
	vec4 albedoColor = vec4(1.0,1.0,1.0,1.0);
	if(bool(albedousage)){
		albedoColor = texture2D(albedo,v_UV0);
	}
    gl_FragColor = albedoColor*color*v_Col.bgra;
}
