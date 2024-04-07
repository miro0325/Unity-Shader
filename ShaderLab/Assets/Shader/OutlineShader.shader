Shader "Custom/OutlineShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Outline_Color("Outline Color", Color) = (1,1,1,1)
        _Outline_Bold("Outline Bold",Range(0,2)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        
        CGPROGRAM
        #pragma surface surf Lambert
        struct Input 
        {
            float2 uv_MainTex;        
        };

        sampler2D _MainTex;
        void surf(Input IN, inout SurfaceOutput o) 
        {
            o.Albedo = tex2D(_MainTex,IN.uv_MainTex).rgb;
        }
        ENDCG

        Pass 
        {
            Cull front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata 
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR;
            };

            float _Outline_Bold;
            float4 _Outline_Color;

            v2f vert(appdata v) 
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                float3 normal = normalize(mul((float3x3)UNITY_MATRIX_IT_MV,v.normal));
                float2 offset = TransformViewToProjection(normal.xy);
                o.pos.xy += offset * o.pos.z * _Outline_Bold;
                o.color = _Outline_Color;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target 
            {
                return i.color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
