Shader "Custom/Leaves2"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Outline_Color("Outline Color", Color) = (1,1,1,1)
        _Outline_Bold("Outline Bold",Range(-100,100)) = 1
    }
    SubShader
    {
        
        

        Pass 
        {
            Tags { "Queue"="Transparent" }
            Cull front

            ZWrite Off Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float4 texcoord : TEXCOORD0;
            }; 
            struct v2f
            {
               float2 uv : TEXCOORD0;
               float4 vertex : SV_POSITION;
               fixed4 diff : COLOR0;
            }; 

            float _Outline_Bold;
            float4 _Outline_Color;

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _Color;

            v2f vert(appdata o) 
            {
                v2f v;
                //v.color = tex2D(_MainTex, uv_MainTex).rgb;
                v.uv = o.texcoord;
                float3 fNormalized_Normal = normalize(o.normal);
                float3 fOutline_Position = o.vertex + fNormalized_Normal * (_Outline_Bold * 0.1f);
                v.diff = _LightColor0;
                v.vertex = UnityObjectToClipPos(fOutline_Position );
                return v;
                    
            }


           fixed4 frag(v2f i) : SV_Target
            {
               fixed4 col;
                col.rg = i.uv;
                
                col.a = col.r;
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
