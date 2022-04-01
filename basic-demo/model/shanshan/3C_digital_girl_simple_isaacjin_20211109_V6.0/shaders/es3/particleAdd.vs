#version 300 es 
precision highp float;
in vec3 inPos;
in vec2 inTexCoord0;
in vec4 inVertexColor;

uniform mat4 _MVP;
uniform vec4 albedo_uv;

out vec2 v_UV0;
out vec4 v_Col;
                                                                  
void main(){
    gl_Position = _MVP * vec4(inPos, 1.0);
    v_UV0 = vec2(inTexCoord0*albedo_uv.xy+albedo_uv.zw);
    v_Col = inVertexColor;
}
