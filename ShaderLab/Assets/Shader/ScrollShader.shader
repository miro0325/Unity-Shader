Shader "Custom/ScrollShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _FormTex ("Form", 2D) = "white" {}
        _ScrollUVX("Scrool UV X",Range(-10,10)) = 1
        _ScrollUVY("Scrool UV Y",Range(-10,10)) = 1
        _Speed("Speed",Range(0,10)) = 1
    }
    SubShader
    {
         CGPROGRAM
        #pragma surface surf Lambert

        struct Input 
        {
            float2 uv_MainTex;
            float2 uv_FormTex;
        };

        float _Speed;
        float _ScrollUVX;
        float _ScrollUVY;
        float4 _Color;

        sampler2D _MainTex;
        sampler2D _FormTex;
       
        void surf(Input IN, inout SurfaceOutput o) 
        {
            _ScrollUVX *= _Time * _Speed;
            _ScrollUVY *= _Time * _Speed;
            float2 mainUV = IN.uv_MainTex + float2(_ScrollUVX,_ScrollUVY);
            float4 col = tex2D(_MainTex, mainUV);
            float2 formUV = IN.uv_FormTex + float2(_ScrollUVX / 2,_ScrollUVY / 2); 
            float4 form = tex2D(_FormTex, formUV);
            o.Albedo = (col.rgb + form.rgb)/2 * _Color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
