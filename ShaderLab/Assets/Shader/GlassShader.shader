Shader "Custom/GlassShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _BumpMap ("Normal Map",2D) = "bump" {}
        _ScaleUV ("Scale",Range(1,10)) = 1
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        
        GrabPass {}
        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata 
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv_MainTex : TEXCOORD0;
                float4 uv_GrabTex : TEXCOORD1;
                float2 uv_BumpMap : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            sampler2D _GrabTexture;
            sampler2D _MainTex;
            sampler2D _BumpMap;

            float4 _GrabTexture_TexelSize;
            float4 _MainTex_ST;
            float4 _BumpMap_ST;
            float _ScaleUV;

            float4 _Color;
            
            v2f vert(appdata v) 
            {
                v2f o;
                # if UNITY_UV_STARTS_AT_TOP
                float scale = -1.0;
                # else
                float scale = 1.0f;
                # endif
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv_GrabTex.xy = (float2(o.vertex.x,o.vertex.y * scale) + o.vertex.w) * 0.5;
                o.uv_GrabTex.zw = o.vertex.zw;
                o.uv_MainTex = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv_BumpMap = TRANSFORM_TEX(v.uv, _BumpMap);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target 
            {
                fixed2 bump = UnpackNormal(tex2D(_BumpMap,i.uv_BumpMap)).rg;
                fixed2 offset = bump * ((_ScaleUV-1) * 10000) * _GrabTexture_TexelSize.xy;
                i.uv_GrabTex.xy = offset * i.uv_GrabTex.z + i.uv_GrabTex.xy; 

                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uv_GrabTex));
                fixed4 tint = tex2D(_MainTex, i.uv_MainTex);
                col *= (tint * _Color);
                return col;
            }
            ENDCG

        }
       
    }
    FallBack "Diffuse"
}
