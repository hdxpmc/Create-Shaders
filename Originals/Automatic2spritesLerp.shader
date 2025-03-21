//////////////////////////////////////////////
/// 2DxFX v3 - by VETASOFT 2018 //
//////////////////////////////////////////////


//////////////////////////////////////////////

Shader "2DxFX_Extra_Shaders/Automatic2spritesLerp"
{
Properties
{
_MainTexInput("User Input Texture", 2D) = "white" {}
_NewTex_1("NewTex_1(RGB)", 2D) = "white" { }
_AutomaticLerp_Speed_1("_AutomaticLerp_Speed_1", Range(0, 1)) = 1
_SpriteFade("SpriteFade", Range(0, 1)) = 1.0

// required for UI.Mask
[HideInInspector]_StencilComp("Stencil Comparison", Float) = 8
[HideInInspector]_Stencil("Stencil ID", Float) = 0
[HideInInspector]_StencilOp("Stencil Operation", Float) = 0
[HideInInspector]_StencilWriteMask("Stencil Write Mask", Float) = 255
[HideInInspector]_StencilReadMask("Stencil Read Mask", Float) = 255
[HideInInspector]_ColorMask("Color Mask", Float) = 15

}

SubShader
{

Tags {"Queue" = "Transparent" "IgnoreProjector" = "true" "RenderType" = "Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
ZWrite Off Blend SrcAlpha OneMinusSrcAlpha Cull Off

// required for UI.Mask
Stencil
{
Ref [_Stencil]
Comp [_StencilComp]
Pass [_StencilOp]
ReadMask [_StencilReadMask]
WriteMask [_StencilWriteMask]
}

Pass
{

CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest
#include "UnityCG.cginc"

struct appdata_t{
float4 vertex   : POSITION;
float4 color    : COLOR;
float2 texcoord : TEXCOORD0;
};

struct v2f
{
float2 texcoord  : TEXCOORD0;
float4 vertex   : SV_POSITION;
float4 color    : COLOR;
};

sampler2D _MainTexInput;
float _SpriteFade;
sampler2D _NewTex_1;
float _AutomaticLerp_Speed_1;

v2f vert(appdata_t IN)
{
v2f OUT;
OUT.vertex = UnityObjectToClipPos(IN.vertex);
OUT.texcoord = IN.texcoord;
OUT.color = IN.color;
return OUT;
}


float4 frag (v2f i) : COLOR
{
float4 _MainTex_1 = tex2D(_MainTexInput, i.texcoord);
float4 NewTex_1 = tex2D(_NewTex_1, i.texcoord);
float _AutomaticLerp_Fade_1 = (1 + cos(_Time.y * 4 * _AutomaticLerp_Speed_1)) / 2;
_MainTex_1.rgb = lerp(_MainTex_1.rgb, NewTex_1.rgb, 1-_MainTex_1.a);
NewTex_1.rgb = lerp(_MainTex_1.rgb, NewTex_1.rgb, NewTex_1.a);
_MainTex_1 = lerp(_MainTex_1, NewTex_1, _AutomaticLerp_Fade_1);
float4 FinalResult = _MainTex_1;
FinalResult.rgb *= i.color.rgb;
FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
return FinalResult;
}

ENDCG
}
}
Fallback "Sprites/Default"
}
