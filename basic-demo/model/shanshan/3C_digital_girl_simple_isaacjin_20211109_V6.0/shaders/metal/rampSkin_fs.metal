using namespace metal;
struct xlatMtlShaderInput {
  float2 v_UV0;
  float2 v_UV2;
  float2 v_UV3;
  float3 v_wT;
  float3 v_wB;
  float3 v_wN;
  float3 v_wL;
  float3 v_wView;
};
struct xlatMtlShaderOutput {
  float4 gl_FragColor;
};
struct xlatMtlShaderUniform {
  int albedousage;
  int ramptexusage;
  float rampintensity;
  int masktexusage;
  int matcapusage;
  float matcapintensity;
  int bumptexusage;
  float bumpscale;
  float4 color;
  float4x4 _V;
};
fragment xlatMtlShaderOutput rampSkin_fs (xlatMtlShaderInput _mtl_i [[stage_in]], constant xlatMtlShaderUniform& _mtl_u [[buffer(1)]]
  ,   texture2d<float> albedo [[texture(0)]], sampler _mtlsmp_albedo [[sampler(0)]]
  ,   texture2d<float> ramptex [[texture(1)]], sampler _mtlsmp_ramptex [[sampler(1)]]
  ,   texture2d<float> masktex [[texture(2)]], sampler _mtlsmp_masktex [[sampler(2)]]
  ,   texture2d<float> matcap [[texture(3)]], sampler _mtlsmp_matcap [[sampler(3)]]
  ,   texture2d<float> bumptex [[texture(4)]], sampler _mtlsmp_bumptex [[sampler(4)]])
{
  xlatMtlShaderOutput _mtl_o;
  float4 _spec_1;
  float mask_2;
  float4 diff_3;
  float3 n_4;
  float4 albedoColor_5;
  float4 tmpvar_6;
  tmpvar_6 = float4(_mtl_u.color);
  albedoColor_5 = tmpvar_6;
  if (bool(_mtl_u.albedousage)) {
    albedoColor_5 = ((float4)((float4)albedo.sample(_mtlsmp_albedo, (float2)(_mtl_i.v_UV0)) * _mtl_u.color));
  };
  float3 tmpvar_7;
  tmpvar_7 = float3(normalize(_mtl_i.v_wN));
  n_4 = tmpvar_7;
  if (bool(_mtl_u.bumptexusage)) {
    float3 tmpvar_8;
    tmpvar_8 = normalize(((bumptex.sample(_mtlsmp_bumptex, (float2)(_mtl_i.v_UV2)).xyz * (float)2.0) - (float)1.0));
    n_4.z = tmpvar_8.z;
    n_4.xy = ((float2)((float2)tmpvar_8.xy * _mtl_u.bumpscale));
    float3x3 tmpvar_9;
    tmpvar_9[0] = _mtl_i.v_wT;
    tmpvar_9[1] = _mtl_i.v_wB;
    tmpvar_9[2] = _mtl_i.v_wN;
    n_4.z = (sqrt(((float)1.0 - 
      clamp (dot (n_4.xy, n_4.xy), (float)0.0, (float)1.0)
    )) * sign(tmpvar_8.z));
    n_4 = normalize(((float3)(tmpvar_9 * (float3)n_4)));
  };
  float tmpvar_10;
  tmpvar_10 = ((((float)dot ((float3)n_4, _mtl_i.v_wL)) * (float)0.49) + (float)0.5);
  diff_3 = float4(float4(1.0, 1.0, 1.0, 1.0));
  if (bool(_mtl_u.ramptexusage)) {
    float2 tmpvar_11;
    tmpvar_11.y = float(0.5);
    tmpvar_11.x = tmpvar_10;
    diff_3 = ramptex.sample(_mtlsmp_ramptex, (float2)(tmpvar_11));
  };
  mask_2 = float(1.0);
  if (bool(_mtl_u.masktexusage)) {
    mask_2 = masktex.sample(_mtlsmp_masktex, (float2)(_mtl_i.v_UV3)).x;
  };
  _spec_1 = float4(float4(0.0, 0.0, 0.0, 0.0));
  if (bool(_mtl_u.matcapusage)) {
    float4 tmpvar_12;
    tmpvar_12.w = float(0.0);
    tmpvar_12.xyz = n_4;
    float3 tmpvar_13;
    tmpvar_13 = ((float4)(_mtl_u._V * (float4)tmpvar_12)).xyz;
    float3 tmpvar_14;
    tmpvar_14 = normalize(_mtl_i.v_wView);
    float3 tmpvar_15;
    tmpvar_15 = (((float3)(tmpvar_14.yzx * (float3)tmpvar_13.zxy)) - ((float3)(tmpvar_14.zxy * (float3)tmpvar_13.yzx)));
    float3 tmpvar_16;
    tmpvar_16.z = float(0.0);
    tmpvar_16.x = -(tmpvar_15.y);
    tmpvar_16.y = tmpvar_15.x;
    _spec_1 = ((matcap.sample(_mtlsmp_matcap, (float2)((
      (tmpvar_16.xy * (float)0.5)
     + (float)0.5))) * (float)2.0) - (float)1.0);
    _spec_1 = (max ((float4)float4(0.0, 0.0, 0.0, 0.0), _spec_1) * mask_2);
  };
  _mtl_o.gl_FragColor.xyz = float3((((float4)((float4)(albedoColor_5 * diff_3) * _mtl_u.rampintensity)) + ((float4)((float4)_spec_1 * _mtl_u.matcapintensity))).xyz);
  _mtl_o.gl_FragColor.w = float(albedoColor_5.w);
  return _mtl_o;
}
