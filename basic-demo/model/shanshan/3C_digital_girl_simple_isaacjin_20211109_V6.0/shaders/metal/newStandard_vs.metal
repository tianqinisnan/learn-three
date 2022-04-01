using namespace metal;
struct xlatMtlShaderInput {
  float3 inVertexPosition [[attribute(0)]];
  float3 inVertexNormal [[attribute(1)]];
  float3 inVertexTangent [[attribute(5)]];
  float3 inVertexBinormal [[attribute(6)]];
  uint   inVertexColor [[attribute(2)]];
  float2 inTexCoord0 [[attribute(3)]];
  float2 inTexCoord1 [[attribute(4)]];
};
struct xlatMtlShaderOutput {
  float4 gl_Position [[position]];
  float4 v_Col;
  float2 v_UV0;
  float2 v_UV1;
  float2 v_UV2;
  float2 v_UV3;
  float3 v_wPos;
  float3 v_wN;
};
struct xlatMtlShaderUniform {
  float4x4 _M;
  float4x4 _MIT;
  float4x4 _MVP;
  float4 albedo_uv;
  float4 metallictex_uv;
  float4 aotex_uv;
  float4 emissivetex_uv;
  float4 bumptex_uv;
};
vertex xlatMtlShaderOutput newStandard_vs(xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(1)]])
{
  xlatMtlShaderOutput _mtl_o;
  float4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _mtl_i.inVertexPosition;
  _mtl_o.gl_Position = (_mtl_u._MVP * tmpvar_1);
  _mtl_o.v_UV0 = ((_mtl_i.inTexCoord0 * _mtl_u.albedo_uv.xy) + _mtl_u.albedo_uv.zw);
  _mtl_o.v_UV1 = ((_mtl_i.inTexCoord0 * _mtl_u.metallictex_uv.xy) + _mtl_u.metallictex_uv.zw);
  _mtl_o.v_UV2 = ((_mtl_i.inTexCoord1 * _mtl_u.aotex_uv.xy) + _mtl_u.aotex_uv.zw);
  _mtl_o.v_UV3 = ((_mtl_i.inTexCoord0 * _mtl_u.emissivetex_uv.xy) + _mtl_u.emissivetex_uv.zw);
  float4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _mtl_i.inVertexPosition;
  _mtl_o.v_wPos = (_mtl_u._M * tmpvar_2).xyz;
  float4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = _mtl_i.inVertexNormal;
  _mtl_o.v_wN = normalize((_mtl_u._MIT * tmpvar_3).xyz);

  float4 color = unpack_unorm4x8_to_float(_mtl_i.inVertexColor);
  _mtl_o.v_Col = float4(color.z, color.y, color.x, color.w);
  _mtl_o.gl_Position.z = (_mtl_o.gl_Position.z + _mtl_o.gl_Position.w) / 2.0f;
  return _mtl_o;
}

