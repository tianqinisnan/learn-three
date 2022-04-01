#version 300 es 
out highp vec4 out_fragColor;
precision highp float;
uniform int albedousage;
uniform sampler2D albedo;
uniform vec4 color;

in vec2 v_UV0;
in vec4 v_Col;
void main()
{
    vec4 albedoColor = vec4(1.0,1.0,1.0,1.0);
    if(bool(albedousage)){
        albedoColor = texture(albedo,v_UV0);
    }
    out_fragColor = albedoColor*color*v_Col.bgra*v_Col.a;
}
