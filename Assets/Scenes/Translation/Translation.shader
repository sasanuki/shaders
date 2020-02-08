Shader "Custom/Translation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _X ("X", Float) = 0
        _Y ("Y", Float) = 0
        _Z ("Z", Float) = 0
        _Speed ("SPEED", Float) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4x4 translation(float x, float y, float z)
            {
                // xyzを左手座標に対応する
                return float4x4(
                    1, 0, 0, -y,
                    0, 1, 0, x,
                    0, 0, 1, z,
                    0, 0, 0, 1
                );
            }

            float _X;
            float _Y;
            float _Z;
            float _Speed;
            
            v2f vert (appdata v)
            {
                v2f o;
                
                // 例として円状に移動するようにしてみる
                _X = _X * sin(_Time * _Speed);
                _Y = _Y * cos(_Time * _Speed);
                
                float4x4 v4 = translation(_X, _Y, _Z);
                float4 result = mul(v4, v.vertex);
                
                o.vertex = UnityObjectToClipPos(result);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
