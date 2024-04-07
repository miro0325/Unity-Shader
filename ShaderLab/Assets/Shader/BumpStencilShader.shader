Shader "Custom/BumpStencil"
{
    Properties
    {
        _MainTex ("Diffuse", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _BumpMap ("Normal Map",2D) = "bump" {}
        _BumpStrength ("Normal Strength", Range(0,1)) = 0
        _StencilRef("Stencil Ref", float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp("Stencil Comp", float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilOp("Stencil Op", float) = 2
        
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }
        LOD 200

        Stencil 
        {
            Ref [_StencilRef]
            Comp [_StencilComp]
            Pass [_StencilOp]
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;

        float _BumpStrength;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpTex;
        };

        fixed4 _Color;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = _Color.a;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpTex));
            o.Normal *= float3(_BumpStrength, _BumpStrength, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
