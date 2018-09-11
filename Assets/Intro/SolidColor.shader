﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Intro/SolidColor"
{
	Properties
	{
        _Color ("Color", Color) = (1, 0, 0, 1)
	}
	SubShader
	{

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

            struct vertInput {
                float4 pos: POSITION;
            };

            struct vertOutput {
                float4 pos: SV_POSITION;
            };

			half4 _Color;
			
			vertOutput vert(vertInput input) {
                vertOutput o;
                o.pos = UnityObjectToClipPos(input.pos);
                return o;
			}
			
			half4 frag (vertOutput i) : COLOR {
                return _Color;
			}
			ENDCG
		}
	}
}
