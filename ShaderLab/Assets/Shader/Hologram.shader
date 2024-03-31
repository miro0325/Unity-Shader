Shader "Custom/Hologram"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimPower ("Rim Power", Range(0.5, 8)) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }

        Pass 
        {
            ZWrite On
            ColorMask 0
        }

        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert alpha:fade

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        float4 _RimColor;
        float _RimPower;
        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;

            half rim = 1 - saturate(dot(normalize(IN.viewDir),o.Normal));
            o.Emission = _RimColor.rgb * pow(rim,_RimPower) * 10;
            o.Alpha =  pow(rim,_RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
