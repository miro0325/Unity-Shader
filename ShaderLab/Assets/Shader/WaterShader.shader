Shader "Custom/WaterShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _FormTex ("Form", 2D) = "white" {}
        _ScrollUVX("Scrool UV X",Range(-10,10)) = 1
        _ScrollUVY("Scrool UV Y",Range(-10,10)) = 1
        _ScrollSpeed("Scroll Speed",Range(0,10)) = 1
        _Tint("Colour Tint", Color) = (1,1,1,1)
        _Freq("Frequency", Range(0,10)) = 3
        _WaveSpeed("Wave Speed", Range(0,100)) = 10
        _Amp("Amplitude", Range(0,10)) = 0.5
    }
    SubShader
    {
         CGPROGRAM
        #pragma surface surf Lambert vertex:vert 
        struct Input 
        {
            float2 uv_MainTex;
            float2 uv_FormTex;
            float3 vertexColor;
        };

        struct appdata 
        {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
            float4 texcoord1 : TEXCOORD1;
            float4 texcoord2 : TEXCOORD2;
        };

        float _ScrollSpeed;
        float _ScrollUVX;
        float _ScrollUVY;
        float4 _Color;
        
        float _WaveSpeed;
        float _Freq;
        float _Amp;
        float4 _Tint;

        sampler2D _MainTex;
        sampler2D _FormTex;
       
       void vert(inout appdata v, out Input o) 
        {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            float t = _Time * _WaveSpeed;
            float waveHeightX = cos(t + v.vertex.x * _Freq) * _Amp;
            float waveHeightZ = sin(t + v.vertex.z * _Freq) * _Amp;
            float waveHeight = (waveHeightX + waveHeightZ)/2;
            v.vertex.y = v.vertex.y + waveHeight;
            v.normal = normalize(float3(v.normal.x + waveHeight,v.normal.y,v.normal.z + waveHeight));
            o.vertexColor = waveHeight + 2;
        }

        void surf(Input IN, inout SurfaceOutput o) 
        {
            _ScrollUVX *= _Time * _ScrollSpeed;
            _ScrollUVY *= _Time * _ScrollSpeed;
            float2 mainUV = IN.uv_MainTex + float2(_ScrollUVX,_ScrollUVY);
            float4 col = tex2D(_MainTex, mainUV);
            float2 formUV = IN.uv_FormTex + float2(_ScrollUVX / 2,_ScrollUVY / 2); 
            float4 form = tex2D(_FormTex, formUV);
            float3 final = (col.rgb + form.rgb)/2 * _Color;
            final * IN.vertexColor.rgb;
            o.Albedo = final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
