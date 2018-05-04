Shader "Unlit/Kantenfilter"
{
	Properties
	{
		
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		// "Queue"="Transparent": Draw ourselves after all opaque geometry
		// "IgnoreProjector"="True": Don't be affected by any Projectors
		// "RenderType"="Transparent": Declare RenderType as transparent
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
       

        // Grab the screen behind the object into Default _GrabTexture
        // https://docs.unity3d.com/Manual/SL-GrabPass.html
        GrabPass
        {
        }
       
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
                float4 pos : SV_POSITION;
                float4 grabPosUV : TEXCOORD0;
            };

            // VERTEX SHADER
            v2f vert (appdata v)
            {
                v2f o;

                // use UnityObjectToClipPos from UnityCG.cginc to calculate 
                // the clip-space of the vertex
                o.pos = UnityObjectToClipPos(v.vertex);

                // use ComputeGrabScreenPos function from UnityCG.cginc
                // to get the correct texture coordinate
                o.grabPosUV = ComputeGrabScreenPos(o.pos);
                return o;
            }

            // define effect variables to use in Fragement Shader
            sampler2D _GrabTexture;

            // Size information needed to access the pixels of the texture 
            // https://docs.unity3d.com/Manual/SL-PropertiesInPrograms.html
            float4 _GrabTexture_TexelSize;

            float _Factor;

	    float a;
float b;
float c;
            // FRAGMENT SHADER
            half4 frag (v2f i) : SV_Target
            {
 				half4 pixelCol = half4(0, 0, 0, 0);




		#define ADDPIXEL_X(weight, kernelX, kernelY) tex2D(_GrabTexture, float2(i.grabPosUV.x + _GrabTexture_TexelSize.x  * 0.1 * kernelX, i.grabPosUV.y + _GrabTexture_TexelSize.y * 0.1 *  kernelY)) * weight

		pixelCol += ADDPIXEL_X( 1,-1, 1);
		pixelCol += ADDPIXEL_X( 2, 0, 1);
		pixelCol += ADDPIXEL_X( 1, 1, 1);
		pixelCol += ADDPIXEL_X( 0,-1, 0);
		pixelCol += ADDPIXEL_X( 0, 0, 0);
		pixelCol += ADDPIXEL_X( 0, 1, 0);
		pixelCol += ADDPIXEL_X(-1,-1,-1);
		pixelCol += ADDPIXEL_X(-2, 0,-1);
		pixelCol += ADDPIXEL_X(-1, 1,-1);


		pixelCol += ADDPIXEL_X( 1,-1, 1);
		pixelCol += ADDPIXEL_X( 0, 0, 1);
		pixelCol += ADDPIXEL_X(-1, 1, 1);
		pixelCol += ADDPIXEL_X( 2,-1, 0);
		pixelCol += ADDPIXEL_X( 0, 0, 0);
		pixelCol += ADDPIXEL_X(-2, 1, 0);
		pixelCol += ADDPIXEL_X( 1,-1,-1);
		pixelCol += ADDPIXEL_X( 0, 0,-1);
		pixelCol += ADDPIXEL_X(-1, 1,-1);
		

		

		pixelCol = length(pixelCol.xyz);
		
                return pixelCol;
            }
            ENDCG
        }
	}
}
