//////////////////////////////////////////////
/// 2DxFX v3 - by VETASOFT 2018 //
//////////////////////////////////////////////


//////////////////////////////////////////////

Shader "2DxFX_Extra_Shaders/Animated_PingPong_Rotation"
{
Properties
{
_MainTexInput("User Input Texture", 2D) = "white" {}
AnimatedRotationUV_AnimatedRotationUV_Rotation_1("AnimatedRotationUV_AnimatedRotationUV_Rotation_1", Range(-360, 360)) = -16.715
AnimatedRotationUV_AnimatedRotationUV_PosX_1("AnimatedRotationUV_AnimatedRotationUV_PosX_1", Range(-1, 2)) = 0.5
AnimatedRotationUV_AnimatedRotationUV_PosY_1("AnimatedRotationUV_AnimatedRotationUV_PosY_1", Range(-1, 2)) = 0.5
AnimatedRotationUV_AnimatedRotationUV_Intensity_1("AnimatedRotationUV_AnimatedRotationUV_Intensity_1", Range(0, 4)) = 0.5
AnimatedRotationUV_AnimatedRotationUV_Speed_1("AnimatedRotationUV_AnimatedRotationUV_Speed_1", Range(-10, 10)) = 4.107
_LerpUV_Fade_1("_LerpUV_Fade_1", Range(0, 1)) = 1
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
float AnimatedRotationUV_AnimatedRotationUV_Rotation_1;
float AnimatedRotationUV_AnimatedRotationUV_PosX_1;
float AnimatedRotationUV_AnimatedRotationUV_PosY_1;
float AnimatedRotationUV_AnimatedRotationUV_Intensity_1;
float AnimatedRotationUV_AnimatedRotationUV_Speed_1;
float _LerpUV_Fade_1;

v2f vert(appdata_t IN)
{
v2f OUT;
OUT.vertex = UnityObjectToClipPos(IN.vertex);
OUT.texcoord = IN.texcoord;
OUT.color = IN.color;
return OUT;
}


float2 AnimatedRotationUV(float2 uv, float rot, float posx, float posy, float radius, float speed)
{
uv = uv - float2(posx, posy);
float angle = rot * 0.01744444;
angle += sin(_Time * speed * 20) * radius;
float sinX = sin(angle);
float cosX = cos(angle);
float2x2 rotationMatrix = float2x2(cosX, -sinX, sinX, cosX);
uv = mul(uv, rotationMatrix) + float2(posx, posy);
return uv;
}
float4 frag (v2f i) : COLOR
{
float2 AnimatedRotationUV_1 = AnimatedRotationUV(i.texcoord,AnimatedRotationUV_AnimatedRotationUV_Rotation_1,AnimatedRotationUV_AnimatedRotationUV_PosX_1,AnimatedRotationUV_AnimatedRotationUV_PosY_1,AnimatedRotationUV_AnimatedRotationUV_Intensity_1,AnimatedRotationUV_AnimatedRotationUV_Speed_1);
i.texcoord = lerp(i.texcoord,AnimatedRotationUV_1,_LerpUV_Fade_1);
float4 _MainTex_1 = tex2D(_MainTexInput,i.texcoord);
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
