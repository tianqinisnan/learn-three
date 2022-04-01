#version 300 es
precision highp float;
in vec3 inVertexPosition; 
in vec3 inVertexNormal; 
in vec3 inVertexTangent; 
in vec3 inVertexBinormal; 
in vec4 inVertexColor; 
in vec2 inTexCoord0; 
in vec2 inTexCoord1; 

uniform mat4 _M; 
uniform mat4 _MIT; 
uniform mat4 _MVP; 
uniform vec4 albedo_uv; 
uniform vec4 metallictex_uv; 
uniform vec4 aotex_uv; 
uniform vec4 emissivetex_uv; 
uniform vec4 bumptex_uv; 
 
out vec2 v_UV0; 
out vec2 v_UV1; 
out vec2 v_UV2; 
out vec2 v_UV3; 
out vec2 v_UV4; 

out vec3 v_wPos; 
out vec4 v_Col;
out vec3 v_wT;
out vec3 v_wB;
out vec3 v_wN;

void main(){
	gl_Position = _MVP * vec4(inVertexPosition, 1.0);
    v_UV0 = vec2(inTexCoord0*albedo_uv.xy+albedo_uv.zw); 
    v_UV1 = vec2(inTexCoord0*metallictex_uv.xy+metallictex_uv.zw); 
    v_UV2 = vec2(inTexCoord1*aotex_uv.xy+aotex_uv.zw); 
    v_UV3 = vec2(inTexCoord0*emissivetex_uv.xy+emissivetex_uv.zw); 
    v_UV4 = vec2(inTexCoord0*bumptex_uv.xy+bumptex_uv.zw); 
    v_wPos = (_M * vec4(inVertexPosition, 1.0)).xyz; 
    v_wN = normalize((_MIT * vec4(inVertexNormal, 0.0)).xyz);
    v_wT = normalize((_MIT * vec4(inVertexTangent, 0.0)).xyz);
    v_wB = normalize((_MIT * vec4(inVertexBinormal, 0.0)).xyz);
    v_Col = inVertexColor;
}
