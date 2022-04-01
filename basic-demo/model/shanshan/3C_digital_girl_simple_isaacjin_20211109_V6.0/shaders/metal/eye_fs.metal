using namespace metal;
struct xlatMtlShaderInput {
  float2 v_UV1;
  float rotate;
  float3 v_wL;
  float3 v_wN;
  float3 v_wView;
};
struct xlatMtlShaderOutput {
  float4 gl_FragColor;
};
struct xlatMtlShaderUniform {
  int albedousage;
  int ramptexusage;
  float rampintensity;
  int matcapusage;
  float matcapintensity;
  int shadowtexusage;
  int isflip;
  int speculartexusage;
  int transmasktexusage;
  float transmission;
  float4x4 _V;
};
fragment xlatMtlShaderOutput eye_fs (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(1)]]
  ,   texture2d<float> albedo [[texture(0)]], sampler _mtlsmp_albedo [[sampler(0)]]
  ,   texture2d<float> ramptex [[texture(1)]], sampler _mtlsmp_ramptex [[sampler(1)]]
  ,   texture2d<float> matcap [[texture(2)]], sampler _mtlsmp_matcap [[sampler(2)]]
  ,   texture2d<float> shadowtex [[texture(3)]], sampler _mtlsmp_shadowtex [[sampler(3)]]
  ,   texture2d<float> speculartex [[texture(4)]], sampler _mtlsmp_speculartex [[sampler(4)]]
  ,   texture2d<float> transmasktex [[texture(5)]], sampler _mtlsmp_transmasktex [[sampler(5)]])
{
  xlatMtlShaderOutput _mtl_o;
  float fresnel_1;
  float4 shadow_2;
  float4 transmask_3;
  float2 _spec_UV_4;
  float4 _spec1_5;
  float4 _spec_6;
  float4 diff_7;
  float4 albedoColor_8;
  albedoColor_8 = float4(float4(1.0, 1.0, 1.0, 1.0));
  if (bool(_mtl_u.albedousage)) {
    albedoColor_8 = albedo.sample(_mtlsmp_albedo, (float2)(_mtl_i.v_UV1));
  };
  float tmpvar_9;
  tmpvar_9 = ((dot (_mtl_i.v_wN, _mtl_i.v_wL) * 0.49) + 0.5);
  diff_7 = float4(float4(1.0, 1.0, 1.0, 1.0));
  if (bool(_mtl_u.ramptexusage)) {
    float2 tmpvar_10;
    tmpvar_10.y = 0.5;
    tmpvar_10.x = tmpvar_9;
    diff_7 = ramptex.sample(_mtlsmp_ramptex, (float2)(tmpvar_10));
  };
  _spec_6 = float4(float4(0.0, 0.0, 0.0, 0.0));
  if (bool(_mtl_u.matcapusage)) {
    float4 tmpvar_11;
    tmpvar_11.w = 0.0;
    tmpvar_11.xyz = _mtl_i.v_wN;
    float3 tmpvar_12;
    tmpvar_12 = (_mtl_u._V * tmpvar_11).xyz;
    float3 tmpvar_13;
    tmpvar_13 = normalize(_mtl_i.v_wView);
    float3 tmpvar_14;
    tmpvar_14 = ((tmpvar_13.yzx * tmpvar_12.zxy) - (tmpvar_13.zxy * tmpvar_12.yzx));
    float3 tmpvar_15;
    tmpvar_15.z = 0.0;
    tmpvar_15.x = -(tmpvar_14.y);
    tmpvar_15.y = tmpvar_14.x;
    float2 tmpvar_16;
    tmpvar_16 = ((tmpvar_15.xy * 0.5) + 0.5);
    _spec_6 = ((matcap.sample(_mtlsmp_matcap, (float2)(tmpvar_16)) * (float)2.0) - (float4)float4(1.0, 1.0, 1.0, 1.0));
    _spec_6 = ((float4)((float4)max ((float4)float4(0.0, 0.0, 0.0, 0.0), _spec_6) * _mtl_u.matcapintensity));
  };
  _spec1_5 = float4(float4(0.0, 0.0, 0.0, 0.0));
  float2 tmpvar_17;
  tmpvar_17 = (_mtl_i.v_UV1 - float2(0.5, 0.5));
  float tmpvar_18;
  tmpvar_18 = ((_mtl_i.rotate * 0.2) - 0.6);
  float2 tmpvar_19;
  tmpvar_19.x = ((tmpvar_17.x * cos(tmpvar_18)) - (tmpvar_17.y * sin(tmpvar_18)));
  tmpvar_19.y = ((tmpvar_17.x * sin(tmpvar_18)) + (tmpvar_17.y * cos(tmpvar_18)));
  _spec_UV_4 = (tmpvar_19 + float2(0.5, 0.5));
  if (bool(_mtl_u.speculartexusage)) {
    _spec1_5 = speculartex.sample(_mtlsmp_speculartex, (float2)(_spec_UV_4));
  };
  transmask_3 = float4(float4(0.0, 0.0, 0.0, 0.0));
  if (bool(_mtl_u.transmasktexusage)) {
    transmask_3 = ((float4)((float4)transmasktex.sample(_mtlsmp_transmasktex, (float2)(_mtl_i.v_UV1)) * _mtl_u.transmission));
  };
  float2 x_20;
  x_20 = (_mtl_i.v_UV1 - 0.5);
  float tmpvar_21;
  tmpvar_21 = (((1.0 - 
    sqrt(dot (x_20, x_20))
  ) * 5.0) - 3.2);
  shadow_2 = float4(float4(1.0, 1.0, 1.0, 1.0));
  if (bool(_mtl_u.shadowtexusage)) {
    float2 tmpvar_22;
    tmpvar_22.x = ((1.0 - (
      float(_mtl_u.isflip)
     * 2.0)) * _mtl_i.v_UV1.x);
    tmpvar_22.y = _mtl_i.v_UV1.y;
    shadow_2 = shadowtex.sample(_mtlsmp_shadowtex, (float2)(tmpvar_22));
  };
  float tmpvar_23;
  tmpvar_23 = (dot (_mtl_i.v_wN, _mtl_i.v_wView) + 0.41);
  fresnel_1 = (max (0.0, (1.0 - 
    (tmpvar_23 * tmpvar_23)
  )) * tmpvar_21);
  float4 tmpvar_24;
  tmpvar_24 = mix (((float4)((float4)(albedoColor_8 * diff_7) * _mtl_u.rampintensity)), (albedoColor_8 * (float)2.0), ((float4)((float4)transmask_3 * _mtl_u.transmission)));
  _mtl_o.gl_FragColor.xyz = float3((((tmpvar_24 + _spec_6) + ((float4)((float4)_spec1_5 + fresnel_1))) * shadow_2).xyz);
  _mtl_o.gl_FragColor.w = float(albedoColor_8.w);
  return _mtl_o;
}