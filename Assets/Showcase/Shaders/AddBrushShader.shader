﻿Shader "Hidden/AddBrushShader"
{
    Properties
    {
        _MainTex ("Brush", 2D) = "white" {}
        _Scale("Scaling factor", Float) = 1.0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            Blend One One

            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _Scale;

            float4 frag(v2f_img i) : SV_Target
            {
                return tex2D(_MainTex, i.uv) * _Scale;
            }
            ENDCG
        }
    }
}
