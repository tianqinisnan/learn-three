using namespace metal;
struct xlatMtlShaderInput {
  float3 inVertexPosition [[attribute(0)]];
  float2 inTexCoord0 [[attribute(3)]];
  float3 inVertexNormal [[attribute(1)]];
  float3 inVertexBinormal [[attribute(6)]];
  float3 inVertexTangent [[attribute(5)]];
};
struct xlatMtlShaderOutput {
  float4 gl_Position [[position]];
  float2 v_UV0;
  float2 v_UV1;
  float2 v_UV2;
  float2 v_UV3;
  float3 v_wL;
  float3 v_wT;
  float3 v_wB;
  float3 v_wN;
  float3 v_wPos;
};
struct xlatMtlShaderUniform {
  float4x4 _MVP;
  float4x4 _M;
  float4x4 _MIT;
  float4 albedo_uv;
  float4 bumptex_uv;
  float4 anisotex_uv;
  float3 lightdir;
};
vertex xlatMtlShaderOutput hair_vs (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(1)]])
{
  xlatMtlShaderOutput _mtl_o;
  float4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _mtl_i.inVertexPosition;
  _mtl_o.gl_Position = (_mtl_u._MVP * tmpvar_1);
  _mtl_o.v_UV0 = ((_mtl_i.inTexCoord0 * _mtl_u.albedo_uv.xy) + _mtl_u.albedo_uv.zw);
  _mtl_o.v_UV1 = _mtl_i.inTexCoord0;
  _mtl_o.v_UV2 = ((_mtl_i.inTexCoord0 * _mtl_u.bumptex_uv.xy) + _mtl_u.bumptex_uv.zw);
  _mtl_o.v_UV3 = ((_mtl_i.inTexCoord0 * _mtl_u.anisotex_uv.xy) + _mtl_u.anisotex_uv.zw);
  float4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = _mtl_i.inVertexNormal;
  _mtl_o.v_wN = normalize((_mtl_u._MIT * tmpvar_2).xyz);
  float4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = _mtl_i.inVertexTangent;
  _mtl_o.v_wT = normalize((_mtl_u._MIT * tmpvar_3).xyz);
  float4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = _mtl_i.inVertexBinormal;
  _mtl_o.v_wB = normalize((_mtl_u._MIT * tmpvar_4).xyz);
  float4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _mtl_i.inVertexPosition;
  _mtl_o.v_wPos = (_mtl_u._M * tmpvar_5).xyz;
  _mtl_o.v_wL = normalize(_mtl_u.lightdir);
  _mtl_o.gl_Position.z = (_mtl_o.gl_Position.z + _mtl_o.gl_Position.w) / 2.0f;
  return _mtl_o;
}
