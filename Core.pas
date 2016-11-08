﻿unit Core;

interface //#################################################################### ■

uses System.Types, System.Classes, System.Math.Vectors,
     FMX.Types3D, FMX.Controls3D, FMX.MaterialSources,
     LUX, LUX.D1, LUX.D2, LUX.D3, LUX.D3.M4, LUX.M4;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTeapotShape

     TTeapotShape = class( TControl3D )
     private
       ///// メソッド
       procedure MakeModel;
     protected
       _Geometry :TMeshData;
       _Material :TMaterialSource;
       _DivN     :Integer;
       ///// アクセス
       procedure SetDivN( const DivN_:Integer );
       ///// メソッド
       procedure Render; override;
     public
       constructor Create( Owner_:TComponent ); override;
       destructor Destroy; override;
       ///// プロパティ
       property Geometry :TMeshData       read _Geometry                  ;
       property Material :TMaterialSource read _Material write   _Material;
       property DivN     :Integer         read _DivN     write SetDivN    ;
     end;

const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

      TeapotPatcs :array [ 1..32 ] of TIntegerM4 =
           ( ( _:( (   1,   2,   3,   4 ), (   5,   6,   7,   8 ), (   9,  10,  11,  12 ), (  13,  14,  15,  16 ) ) ),
             ( _:( (   4,  17,  18,  19 ), (   8,  20,  21,  22 ), (  12,  23,  24,  25 ), (  16,  26,  27,  28 ) ) ),
             ( _:( (  19,  29,  30,  31 ), (  22,  32,  33,  34 ), (  25,  35,  36,  37 ), (  28,  38,  39,  40 ) ) ),
             ( _:( (  31,  41,  42,   1 ), (  34,  43,  44,   5 ), (  37,  45,  46,   9 ), (  40,  47,  48,  13 ) ) ),
             ( _:( (  13,  14,  15,  16 ), (  49,  50,  51,  52 ), (  53,  54,  55,  56 ), (  57,  58,  59,  60 ) ) ),
             ( _:( (  16,  26,  27,  28 ), (  52,  61,  62,  63 ), (  56,  64,  65,  66 ), (  60,  67,  68,  69 ) ) ),
             ( _:( (  28,  38,  39,  40 ), (  63,  70,  71,  72 ), (  66,  73,  74,  75 ), (  69,  76,  77,  78 ) ) ),
             ( _:( (  40,  47,  48,  13 ), (  72,  79,  80,  49 ), (  75,  81,  82,  53 ), (  78,  83,  84,  57 ) ) ),
             ( _:( (  57,  58,  59,  60 ), (  85,  86,  87,  88 ), (  89,  90,  91,  92 ), (  93,  94,  95,  96 ) ) ),
             ( _:( (  60,  67,  68,  69 ), (  88,  97,  98,  99 ), (  92, 100, 101, 102 ), (  96, 103, 104, 105 ) ) ),
             ( _:( (  69,  76,  77,  78 ), (  99, 106, 107, 108 ), ( 102, 109, 110, 111 ), ( 105, 112, 113, 114 ) ) ),
             ( _:( (  78,  83,  84,  57 ), ( 108, 115, 116,  85 ), ( 111, 117, 118,  89 ), ( 114, 119, 120,  93 ) ) ),
             ( _:( ( 121, 122, 123, 124 ), ( 125, 126, 127, 128 ), ( 129, 130, 131, 132 ), ( 133, 134, 135, 136 ) ) ),
             ( _:( ( 124, 137, 138, 121 ), ( 128, 139, 140, 125 ), ( 132, 141, 142, 129 ), ( 136, 143, 144, 133 ) ) ),
             ( _:( ( 133, 134, 135, 136 ), ( 145, 146, 147, 148 ), ( 149, 150, 151, 152 ), (  69, 153, 154, 155 ) ) ),
             ( _:( ( 136, 143, 144, 133 ), ( 148, 156, 157, 145 ), ( 152, 158, 159, 149 ), ( 155, 160, 161,  69 ) ) ),
             ( _:( ( 162, 163, 164, 165 ), ( 166, 167, 168, 169 ), ( 170, 171, 172, 173 ), ( 174, 175, 176, 177 ) ) ),
             ( _:( ( 165, 178, 179, 162 ), ( 169, 180, 181, 166 ), ( 173, 182, 183, 170 ), ( 177, 184, 185, 174 ) ) ),
             ( _:( ( 174, 175, 176, 177 ), ( 186, 187, 188, 189 ), ( 190, 191, 192, 193 ), ( 194, 195, 196, 197 ) ) ),
             ( _:( ( 177, 184, 185, 174 ), ( 189, 198, 199, 186 ), ( 193, 200, 201, 190 ), ( 197, 202, 203, 194 ) ) ),
             ( _:( ( 204, 204, 204, 204 ), ( 207, 208, 209, 210 ), ( 211, 211, 211, 211 ), ( 212, 213, 214, 215 ) ) ),
             ( _:( ( 204, 204, 204, 204 ), ( 210, 217, 218, 219 ), ( 211, 211, 211, 211 ), ( 215, 220, 221, 222 ) ) ),
             ( _:( ( 204, 204, 204, 204 ), ( 219, 224, 225, 226 ), ( 211, 211, 211, 211 ), ( 222, 227, 228, 229 ) ) ),
             ( _:( ( 204, 204, 204, 204 ), ( 226, 230, 231, 207 ), ( 211, 211, 211, 211 ), ( 229, 232, 233, 212 ) ) ),
             ( _:( ( 212, 213, 214, 215 ), ( 234, 235, 236, 237 ), ( 238, 239, 240, 241 ), ( 242, 243, 244, 245 ) ) ),
             ( _:( ( 215, 220, 221, 222 ), ( 237, 246, 247, 248 ), ( 241, 249, 250, 251 ), ( 245, 252, 253, 254 ) ) ),
             ( _:( ( 222, 227, 228, 229 ), ( 248, 255, 256, 257 ), ( 251, 258, 259, 260 ), ( 254, 261, 262, 263 ) ) ),
             ( _:( ( 229, 232, 233, 212 ), ( 257, 264, 265, 234 ), ( 260, 266, 267, 238 ), ( 263, 268, 269, 242 ) ) ),
             ( _:( ( 270, 270, 270, 270 ), ( 279, 280, 281, 282 ), ( 275, 276, 277, 278 ), ( 271, 272, 273, 274 ) ) ),
             ( _:( ( 270, 270, 270, 270 ), ( 282, 289, 290, 291 ), ( 278, 286, 287, 288 ), ( 274, 283, 284, 285 ) ) ),
             ( _:( ( 270, 270, 270, 270 ), ( 291, 298, 299, 300 ), ( 288, 295, 296, 297 ), ( 285, 292, 293, 294 ) ) ),
             ( _:( ( 270, 270, 270, 270 ), ( 300, 305, 306, 279 ), ( 297, 303, 304, 275 ), ( 294, 301, 302, 271 ) ) ) );

      TeapotVerts :array [ 1..306 ] of TSingle3D =
           ( ( X:+1.4   ; Y: 0.0   ; Z:+2.4     ), ( X:+1.4   ; Y:-0.784 ; Z:+2.4     ),
             ( X:+0.784 ; Y:-1.4   ; Z:+2.4     ), ( X: 0.0   ; Y:-1.4   ; Z:+2.4     ),
             ( X:+1.3375; Y: 0.0   ; Z:+2.53125 ), ( X:+1.3375; Y:-0.749 ; Z:+2.53125 ),
             ( X:+0.749 ; Y:-1.3375; Z:+2.53125 ), ( X: 0.0   ; Y:-1.3375; Z:+2.53125 ),
             ( X:+1.4375; Y: 0.0   ; Z:+2.53125 ), ( X:+1.4375; Y:-0.805 ; Z:+2.53125 ),
             ( X:+0.805 ; Y:-1.4375; Z:+2.53125 ), ( X: 0.0   ; Y:-1.4375; Z:+2.53125 ),
             ( X:+1.5   ; Y: 0.0   ; Z:+2.4     ), ( X:+1.5   ; Y:-0.84  ; Z:+2.4     ),
             ( X:+0.84  ; Y:-1.5   ; Z:+2.4     ), ( X: 0.0   ; Y:-1.5   ; Z:+2.4     ),
             ( X:-0.784 ; Y:-1.4   ; Z:+2.4     ), ( X:-1.4   ; Y:-0.784 ; Z:+2.4     ),
             ( X:-1.4   ; Y: 0.0   ; Z:+2.4     ), ( X:-0.749 ; Y:-1.3375; Z:+2.53125 ),
             ( X:-1.3375; Y:-0.749 ; Z:+2.53125 ), ( X:-1.3375; Y: 0.0   ; Z:+2.53125 ),
             ( X:-0.805 ; Y:-1.4375; Z:+2.53125 ), ( X:-1.4375; Y:-0.805 ; Z:+2.53125 ),
             ( X:-1.4375; Y: 0.0   ; Z:+2.53125 ), ( X:-0.84  ; Y:-1.5   ; Z:+2.4     ),
             ( X:-1.5   ; Y:-0.84  ; Z:+2.4     ), ( X:-1.5   ; Y: 0.0   ; Z:+2.4     ),
             ( X:-1.4   ; Y:+0.784 ; Z:+2.4     ), ( X:-0.784 ; Y:+1.4   ; Z:+2.4     ),
             ( X: 0.0   ; Y:+1.4   ; Z:+2.4     ), ( X:-1.3375; Y:+0.749 ; Z:+2.53125 ),
             ( X:-0.749 ; Y:+1.3375; Z:+2.53125 ), ( X: 0.0   ; Y:+1.3375; Z:+2.53125 ),
             ( X:-1.4375; Y:+0.805 ; Z:+2.53125 ), ( X:-0.805 ; Y:+1.4375; Z:+2.53125 ),
             ( X: 0.0   ; Y:+1.4375; Z:+2.53125 ), ( X:-1.5   ; Y:+0.84  ; Z:+2.4     ),
             ( X:-0.84  ; Y:+1.5   ; Z:+2.4     ), ( X: 0.0   ; Y:+1.5   ; Z:+2.4     ),
             ( X:+0.784 ; Y:+1.4   ; Z:+2.4     ), ( X:+1.4   ; Y:+0.784 ; Z:+2.4     ),
             ( X:+0.749 ; Y:+1.3375; Z:+2.53125 ), ( X:+1.3375; Y:+0.749 ; Z:+2.53125 ),
             ( X:+0.805 ; Y:+1.4375; Z:+2.53125 ), ( X:+1.4375; Y:+0.805 ; Z:+2.53125 ),
             ( X:+0.84  ; Y:+1.5   ; Z:+2.4     ), ( X:+1.5   ; Y:+0.84  ; Z:+2.4     ),
             ( X:+1.75  ; Y: 0.0   ; Z:+1.875   ), ( X:+1.75  ; Y:-0.98  ; Z:+1.875   ),
             ( X:+0.98  ; Y:-1.75  ; Z:+1.875   ), ( X: 0.0   ; Y:-1.75  ; Z:+1.875   ),
             ( X:+2.0   ; Y: 0.0   ; Z:+1.35    ), ( X:+2.0   ; Y:-1.12  ; Z:+1.35    ),
             ( X:+1.12  ; Y:-2.0   ; Z:+1.35    ), ( X: 0.0   ; Y:-2.0   ; Z:+1.35    ),
             ( X:+2.0   ; Y: 0.0   ; Z:+0.9     ), ( X:+2.0   ; Y:-1.12  ; Z:+0.9     ),
             ( X:+1.12  ; Y:-2.0   ; Z:+0.9     ), ( X: 0.0   ; Y:-2.0   ; Z:+0.9     ),
             ( X:-0.98  ; Y:-1.75  ; Z:+1.875   ), ( X:-1.75  ; Y:-0.98  ; Z:+1.875   ),
             ( X:-1.75  ; Y: 0.0   ; Z:+1.875   ), ( X:-1.12  ; Y:-2.0   ; Z:+1.35    ),
             ( X:-2.0   ; Y:-1.12  ; Z:+1.35    ), ( X:-2.0   ; Y: 0.0   ; Z:+1.35    ),
             ( X:-1.12  ; Y:-2.0   ; Z:+0.9     ), ( X:-2.0   ; Y:-1.12  ; Z:+0.9     ),
             ( X:-2.0   ; Y: 0.0   ; Z:+0.9     ), ( X:-1.75  ; Y:+0.98  ; Z:+1.875   ),
             ( X:-0.98  ; Y:+1.75  ; Z:+1.875   ), ( X: 0.0   ; Y:+1.75  ; Z:+1.875   ),
             ( X:-2.0   ; Y:+1.12  ; Z:+1.35    ), ( X:-1.12  ; Y:+2.0   ; Z:+1.35    ),
             ( X: 0.0   ; Y:+2.0   ; Z:+1.35    ), ( X:-2.0   ; Y:+1.12  ; Z:+0.9     ),
             ( X:-1.12  ; Y:+2.0   ; Z:+0.9     ), ( X: 0.0   ; Y:+2.0   ; Z:+0.9     ),
             ( X:+0.98  ; Y:+1.75  ; Z:+1.875   ), ( X:+1.75  ; Y:+0.98  ; Z:+1.875   ),
             ( X:+1.12  ; Y:+2.0   ; Z:+1.35    ), ( X:+2.0   ; Y:+1.12  ; Z:+1.35    ),
             ( X:+1.12  ; Y:+2.0   ; Z:+0.9     ), ( X:+2.0   ; Y:+1.12  ; Z:+0.9     ),
             ( X:+2.0   ; Y: 0.0   ; Z:+0.45    ), ( X:+2.0   ; Y:-1.12  ; Z:+0.45    ),
             ( X:+1.12  ; Y:-2.0   ; Z:+0.45    ), ( X: 0.0   ; Y:-2.0   ; Z:+0.45    ),
             ( X:+1.5   ; Y: 0.0   ; Z:+0.225   ), ( X:+1.5   ; Y:-0.84  ; Z:+0.225   ),
             ( X:+0.84  ; Y:-1.5   ; Z:+0.225   ), ( X: 0.0   ; Y:-1.5   ; Z:+0.225   ),
             ( X:+1.5   ; Y: 0.0   ; Z:+0.15    ), ( X:+1.5   ; Y:-0.84  ; Z:+0.15    ),
             ( X:+0.84  ; Y:-1.5   ; Z:+0.15    ), ( X: 0.0   ; Y:-1.5   ; Z:+0.15    ),
             ( X:-1.12  ; Y:-2.0   ; Z:+0.45    ), ( X:-2.0   ; Y:-1.12  ; Z:+0.45    ),
             ( X:-2.0   ; Y: 0.0   ; Z:+0.45    ), ( X:-0.84  ; Y:-1.5   ; Z:+0.225   ),
             ( X:-1.5   ; Y:-0.84  ; Z:+0.225   ), ( X:-1.5   ; Y: 0.0   ; Z:+0.225   ),
             ( X:-0.84  ; Y:-1.5   ; Z:+0.15    ), ( X:-1.5   ; Y:-0.84  ; Z:+0.15    ),
             ( X:-1.5   ; Y: 0.0   ; Z:+0.15    ), ( X:-2.0   ; Y:+1.12  ; Z:+0.45    ),
             ( X:-1.12  ; Y:+2.0   ; Z:+0.45    ), ( X: 0.0   ; Y:+2.0   ; Z:+0.45    ),
             ( X:-1.5   ; Y:+0.84  ; Z:+0.225   ), ( X:-0.84  ; Y:+1.5   ; Z:+0.225   ),
             ( X: 0.0   ; Y:+1.5   ; Z:+0.225   ), ( X:-1.5   ; Y:+0.84  ; Z:+0.15    ),
             ( X:-0.84  ; Y:+1.5   ; Z:+0.15    ), ( X: 0.0   ; Y:+1.5   ; Z:+0.15    ),
             ( X:+1.12  ; Y:+2.0   ; Z:+0.45    ), ( X:+2.0   ; Y:+1.12  ; Z:+0.45    ),
             ( X:+0.84  ; Y:+1.5   ; Z:+0.225   ), ( X:+1.5   ; Y:+0.84  ; Z:+0.225   ),
             ( X:+0.84  ; Y:+1.5   ; Z:+0.15    ), ( X:+1.5   ; Y:+0.84  ; Z:+0.15    ),
             ( X:-1.6   ; Y: 0.0   ; Z:+2.025   ), ( X:-1.6   ; Y:-0.3   ; Z:+2.025   ),
             ( X:-1.5   ; Y:-0.3   ; Z:+2.25    ), ( X:-1.5   ; Y: 0.0   ; Z:+2.25    ),
             ( X:-2.3   ; Y: 0.0   ; Z:+2.025   ), ( X:-2.3   ; Y:-0.3   ; Z:+2.025   ),
             ( X:-2.5   ; Y:-0.3   ; Z:+2.25    ), ( X:-2.5   ; Y: 0.0   ; Z:+2.25    ),
             ( X:-2.7   ; Y: 0.0   ; Z:+2.025   ), ( X:-2.7   ; Y:-0.3   ; Z:+2.025   ),
             ( X:-3.0   ; Y:-0.3   ; Z:+2.25    ), ( X:-3.0   ; Y: 0.0   ; Z:+2.25    ),
             ( X:-2.7   ; Y: 0.0   ; Z:+1.8     ), ( X:-2.7   ; Y:-0.3   ; Z:+1.8     ),
             ( X:-3.0   ; Y:-0.3   ; Z:+1.8     ), ( X:-3.0   ; Y: 0.0   ; Z:+1.8     ),
             ( X:-1.5   ; Y:+0.3   ; Z:+2.25    ), ( X:-1.6   ; Y:+0.3   ; Z:+2.025   ),
             ( X:-2.5   ; Y:+0.3   ; Z:+2.25    ), ( X:-2.3   ; Y:+0.3   ; Z:+2.025   ),
             ( X:-3.0   ; Y:+0.3   ; Z:+2.25    ), ( X:-2.7   ; Y:+0.3   ; Z:+2.025   ),
             ( X:-3.0   ; Y:+0.3   ; Z:+1.8     ), ( X:-2.7   ; Y:+0.3   ; Z:+1.8     ),
             ( X:-2.7   ; Y: 0.0   ; Z:+1.575   ), ( X:-2.7   ; Y:-0.3   ; Z:+1.575   ),
             ( X:-3.0   ; Y:-0.3   ; Z:+1.35    ), ( X:-3.0   ; Y: 0.0   ; Z:+1.35    ),
             ( X:-2.5   ; Y: 0.0   ; Z:+1.125   ), ( X:-2.5   ; Y:-0.3   ; Z:+1.125   ),
             ( X:-2.65  ; Y:-0.3   ; Z:+0.9375  ), ( X:-2.65  ; Y: 0.0   ; Z:+0.9375  ),
             ( X:-2.0   ; Y:-0.3   ; Z:+0.9     ), ( X:-1.9   ; Y:-0.3   ; Z:+0.6     ),
             ( X:-1.9   ; Y: 0.0   ; Z:+0.6     ), ( X:-3.0   ; Y:+0.3   ; Z:+1.35    ),
             ( X:-2.7   ; Y:+0.3   ; Z:+1.575   ), ( X:-2.65  ; Y:+0.3   ; Z:+0.9375  ),
             ( X:-2.5   ; Y:+0.3   ; Z:+1.125   ), ( X:-1.9   ; Y:+0.3   ; Z:+0.6     ),
             ( X:-2.0   ; Y:+0.3   ; Z:+0.9     ), ( X:+1.7   ; Y: 0.0   ; Z:+1.425   ),
             ( X:+1.7   ; Y:-0.66  ; Z:+1.425   ), ( X:+1.7   ; Y:-0.66  ; Z:+0.6     ),
             ( X:+1.7   ; Y: 0.0   ; Z:+0.6     ), ( X:+2.6   ; Y: 0.0   ; Z:+1.425   ),
             ( X:+2.6   ; Y:-0.66  ; Z:+1.425   ), ( X:+3.1   ; Y:-0.66  ; Z:+0.825   ),
             ( X:+3.1   ; Y: 0.0   ; Z:+0.825   ), ( X:+2.3   ; Y: 0.0   ; Z:+2.1     ),
             ( X:+2.3   ; Y:-0.25  ; Z:+2.1     ), ( X:+2.4   ; Y:-0.25  ; Z:+2.025   ),
             ( X:+2.4   ; Y: 0.0   ; Z:+2.025   ), ( X:+2.7   ; Y: 0.0   ; Z:+2.4     ),
             ( X:+2.7   ; Y:-0.25  ; Z:+2.4     ), ( X:+3.3   ; Y:-0.25  ; Z:+2.4     ),
             ( X:+3.3   ; Y: 0.0   ; Z:+2.4     ), ( X:+1.7   ; Y:+0.66  ; Z:+0.6     ),
             ( X:+1.7   ; Y:+0.66  ; Z:+1.425   ), ( X:+3.1   ; Y:+0.66  ; Z:+0.825   ),
             ( X:+2.6   ; Y:+0.66  ; Z:+1.425   ), ( X:+2.4   ; Y:+0.25  ; Z:+2.025   ),
             ( X:+2.3   ; Y:+0.25  ; Z:+2.1     ), ( X:+3.3   ; Y:+0.25  ; Z:+2.4     ),
             ( X:+2.7   ; Y:+0.25  ; Z:+2.4     ), ( X:+2.8   ; Y: 0.0   ; Z:+2.475   ),
             ( X:+2.8   ; Y:-0.25  ; Z:+2.475   ), ( X:+3.525 ; Y:-0.25  ; Z:+2.49375 ),
             ( X:+3.525 ; Y: 0.0   ; Z:+2.49375 ), ( X:+2.9   ; Y: 0.0   ; Z:+2.475   ),
             ( X:+2.9   ; Y:-0.15  ; Z:+2.475   ), ( X:+3.45  ; Y:-0.15  ; Z:+2.5125  ),
             ( X:+3.45  ; Y: 0.0   ; Z:+2.5125  ), ( X:+2.8   ; Y: 0.0   ; Z:+2.4     ),
             ( X:+2.8   ; Y:-0.15  ; Z:+2.4     ), ( X:+3.2   ; Y:-0.15  ; Z:+2.4     ),
             ( X:+3.2   ; Y: 0.0   ; Z:+2.4     ), ( X:+3.525 ; Y:+0.25  ; Z:+2.49375 ),
             ( X:+2.8   ; Y:+0.25  ; Z:+2.475   ), ( X:+3.45  ; Y:+0.15  ; Z:+2.5125  ),
             ( X:+2.9   ; Y:+0.15  ; Z:+2.475   ), ( X:+3.2   ; Y:+0.15  ; Z:+2.4     ),
             ( X:+2.8   ; Y:+0.15  ; Z:+2.4     ), ( X: 0.0   ; Y: 0.0   ; Z:+3.15    ),
             ( X: 0.0   ; Y:-0.002 ; Z:+3.15    ), ( X:+0.002 ; Y: 0.0   ; Z:+3.15    ),
             ( X:+0.8   ; Y: 0.0   ; Z:+3.15    ), ( X:+0.8   ; Y:-0.45  ; Z:+3.15    ),
             ( X:+0.45  ; Y:-0.8   ; Z:+3.15    ), ( X: 0.0   ; Y:-0.8   ; Z:+3.15    ),
             ( X: 0.0   ; Y: 0.0   ; Z:+2.85    ), ( X:+0.2   ; Y: 0.0   ; Z:+2.7     ),
             ( X:+0.2   ; Y:-0.112 ; Z:+2.7     ), ( X:+0.112 ; Y:-0.2   ; Z:+2.7     ),
             ( X: 0.0   ; Y:-0.2   ; Z:+2.7     ), ( X:-0.002 ; Y: 0.0   ; Z:+3.15    ),
             ( X:-0.45  ; Y:-0.8   ; Z:+3.15    ), ( X:-0.8   ; Y:-0.45  ; Z:+3.15    ),
             ( X:-0.8   ; Y: 0.0   ; Z:+3.15    ), ( X:-0.112 ; Y:-0.2   ; Z:+2.7     ),
             ( X:-0.2   ; Y:-0.112 ; Z:+2.7     ), ( X:-0.2   ; Y: 0.0   ; Z:+2.7     ),
             ( X: 0.0   ; Y:+0.002 ; Z:+3.15    ), ( X:-0.8   ; Y:+0.45  ; Z:+3.15    ),
             ( X:-0.45  ; Y:+0.8   ; Z:+3.15    ), ( X: 0.0   ; Y:+0.8   ; Z:+3.15    ),
             ( X:-0.2   ; Y:+0.112 ; Z:+2.7     ), ( X:-0.112 ; Y:+0.2   ; Z:+2.7     ),
             ( X: 0.0   ; Y:+0.2   ; Z:+2.7     ), ( X:+0.45  ; Y:+0.8   ; Z:+3.15    ),
             ( X:+0.8   ; Y:+0.45  ; Z:+3.15    ), ( X:+0.112 ; Y:+0.2   ; Z:+2.7     ),
             ( X:+0.2   ; Y:+0.112 ; Z:+2.7     ), ( X:+0.4   ; Y: 0.0   ; Z:+2.55    ),
             ( X:+0.4   ; Y:-0.224 ; Z:+2.55    ), ( X:+0.224 ; Y:-0.4   ; Z:+2.55    ),
             ( X: 0.0   ; Y:-0.4   ; Z:+2.55    ), ( X:+1.3   ; Y: 0.0   ; Z:+2.55    ),
             ( X:+1.3   ; Y:-0.728 ; Z:+2.55    ), ( X:+0.728 ; Y:-1.3   ; Z:+2.55    ),
             ( X: 0.0   ; Y:-1.3   ; Z:+2.55    ), ( X:+1.3   ; Y: 0.0   ; Z:+2.4     ),
             ( X:+1.3   ; Y:-0.728 ; Z:+2.4     ), ( X:+0.728 ; Y:-1.3   ; Z:+2.4     ),
             ( X: 0.0   ; Y:-1.3   ; Z:+2.4     ), ( X:-0.224 ; Y:-0.4   ; Z:+2.55    ),
             ( X:-0.4   ; Y:-0.224 ; Z:+2.55    ), ( X:-0.4   ; Y: 0.0   ; Z:+2.55    ),
             ( X:-0.728 ; Y:-1.3   ; Z:+2.55    ), ( X:-1.3   ; Y:-0.728 ; Z:+2.55    ),
             ( X:-1.3   ; Y: 0.0   ; Z:+2.55    ), ( X:-0.728 ; Y:-1.3   ; Z:+2.4     ),
             ( X:-1.3   ; Y:-0.728 ; Z:+2.4     ), ( X:-1.3   ; Y: 0.0   ; Z:+2.4     ),
             ( X:-0.4   ; Y:+0.224 ; Z:+2.55    ), ( X:-0.224 ; Y:+0.4   ; Z:+2.55    ),
             ( X: 0.0   ; Y:+0.4   ; Z:+2.55    ), ( X:-1.3   ; Y:+0.728 ; Z:+2.55    ),
             ( X:-0.728 ; Y:+1.3   ; Z:+2.55    ), ( X: 0.0   ; Y:+1.3   ; Z:+2.55    ),
             ( X:-1.3   ; Y:+0.728 ; Z:+2.4     ), ( X:-0.728 ; Y:+1.3   ; Z:+2.4     ),
             ( X: 0.0   ; Y:+1.3   ; Z:+2.4     ), ( X:+0.224 ; Y:+0.4   ; Z:+2.55    ),
             ( X:+0.4   ; Y:+0.224 ; Z:+2.55    ), ( X:+0.728 ; Y:+1.3   ; Z:+2.55    ),
             ( X:+1.3   ; Y:+0.728 ; Z:+2.55    ), ( X:+0.728 ; Y:+1.3   ; Z:+2.4     ),
             ( X:+1.3   ; Y:+0.728 ; Z:+2.4     ), ( X: 0.0   ; Y: 0.0   ; Z: 0.0     ),
             ( X:+1.5   ; Y: 0.0   ; Z:+0.15    ), ( X:+1.5   ; Y:+0.84  ; Z:+0.15    ),
             ( X:+0.84  ; Y:+1.5   ; Z:+0.15    ), ( X: 0.0   ; Y:+1.5   ; Z:+0.15    ),
             ( X:+1.5   ; Y: 0.0   ; Z:+0.075   ), ( X:+1.5   ; Y:+0.84  ; Z:+0.075   ),
             ( X:+0.84  ; Y:+1.5   ; Z:+0.075   ), ( X: 0.0   ; Y:+1.5   ; Z:+0.075   ),
             ( X:+1.425 ; Y: 0.0   ; Z: 0.0     ), ( X:+1.425 ; Y:+0.798 ; Z: 0.0     ),
             ( X:+0.798 ; Y:+1.425 ; Z: 0.0     ), ( X: 0.0   ; Y:+1.425 ; Z: 0.0     ),
             ( X:-0.84  ; Y:+1.5   ; Z:+0.15    ), ( X:-1.5   ; Y:+0.84  ; Z:+0.15    ),
             ( X:-1.5   ; Y: 0.0   ; Z:+0.15    ), ( X:-0.84  ; Y:+1.5   ; Z:+0.075   ),
             ( X:-1.5   ; Y:+0.84  ; Z:+0.075   ), ( X:-1.5   ; Y: 0.0   ; Z:+0.075   ),
             ( X:-0.798 ; Y:+1.425 ; Z: 0.0     ), ( X:-1.425 ; Y:+0.798 ; Z: 0.0     ),
             ( X:-1.425 ; Y: 0.0   ; Z: 0.0     ), ( X:-1.5   ; Y:-0.84  ; Z:+0.15    ),
             ( X:-0.84  ; Y:-1.5   ; Z:+0.15    ), ( X: 0.0   ; Y:-1.5   ; Z:+0.15    ),
             ( X:-1.5   ; Y:-0.84  ; Z:+0.075   ), ( X:-0.84  ; Y:-1.5   ; Z:+0.075   ),
             ( X: 0.0   ; Y:-1.5   ; Z:+0.075   ), ( X:-1.425 ; Y:-0.798 ; Z: 0.0     ),
             ( X:-0.798 ; Y:-1.425 ; Z: 0.0     ), ( X: 0.0   ; Y:-1.425 ; Z: 0.0     ),
             ( X:+0.84  ; Y:-1.5   ; Z:+0.15    ), ( X:+1.5   ; Y:-0.84  ; Z:+0.15    ),
             ( X:+0.84  ; Y:-1.5   ; Z:+0.075   ), ( X:+1.5   ; Y:-0.84  ; Z:+0.075   ),
             ( X:+0.798 ; Y:-1.425 ; Z: 0.0     ), ( X:+1.425 ; Y:-0.798 ; Z: 0.0     ) );

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

uses System.SysUtils, System.RTLConsts,
     LUX.Curve.T2.D3;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTeapotShape

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TTeapotShape.MakeModel;
var
   N1, I0 :Integer;
//･･････････････････････････････
     function XYtoI( const X_,Y_:Integer ) :Integer;
     begin
          Result := I0 + N1 * Y_ + X_;
     end;
//･･････････････････････････････
var
   N2, I, J, X, Y, X0, Y0, X1, Y1 :Integer;
   Ps :TSingle3DM4;
   T :TSingle2D;
   M :TSingleM4;
begin
     N1 := _DivN + 1;  N2 := Pow2( N1 );

     with _Geometry do
     begin
          with VertexBuffer do
          begin
               Length := 32{Patc} * N2{Poin};

               J := 0;
               for I := 1 to 32 do
               begin
                    for Y := 1 to 4 do
                    for X := 1 to 4 do Ps[ Y, X ] := TeapotVerts[ TeapotPatcs[ I ][ Y, 5-X ] ];

                    for Y := 0 to _DivN do
                    begin
                         T.Y := Y / _DivN;

                         for X := 0 to _DivN do
                         begin
                              T.X := X / _DivN;

                              M := TensorBezie4( Ps, T );

                              Vertices [ J ] := M.AxisP;
                              Tangents [ J ] := M.AxisX;
                              BiNormals[ J ] := M.AxisY;
                              Normals  [ J ] := M.AxisZ;
                              TexCoord0[ J ] := TPointF.Create( T.X, T.Y );

                              Inc( J );
                         end;
                    end;
               end;
          end;

          with IndexBuffer do
          begin
               Length := 32{Patc} * Pow2( _DivN ){Quad} * 2{Tria} * 3{Poin};

               I0 := 0;
               J  := 0;
               for I := 1 to 32 do
               begin
                    for Y0 := 0 to _DivN-1 do
                    begin
                         Y1 := Y0 + 1;

                         for X0 := 0 to _DivN-1 do
                         begin
                              X1 := X0 + 1;

                              //    X0      X1
                              //  Y0┼───┼
                              //    │＼    │
                              //    │  ＼  │
                              //    │    ＼│
                              //  Y1┼───┼

                              Indices[ J ] := XYtoI( X0, Y0 );  Inc( J );
                              Indices[ J ] := XYtoI( X1, Y0 );  Inc( J );
                              Indices[ J ] := XYtoI( X1, Y1 );  Inc( J );

                              Indices[ J ] := XYtoI( X1, Y1 );  Inc( J );
                              Indices[ J ] := XYtoI( X0, Y1 );  Inc( J );
                              Indices[ J ] := XYtoI( X0, Y0 );  Inc( J );
                         end;
                    end;

                    Inc( I0, N2 );
               end;
          end;
     end;

     Repaint;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

procedure TTeapotShape.SetDivN( const DivN_:Integer );
begin
     _DivN := DivN_;  MakeModel;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TTeapotShape.Render;
begin
     Context.SetMatrix( AbsoluteMatrix);

     _Geometry.Render( Context, TMaterialSource.ValidMaterial(_Material), AbsoluteOpacity );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TTeapotShape.Create( Owner_:TComponent );
begin
     inherited;

     _Geometry := TMeshData.Create;

     HitTest := False;

     _DivN := 1;

     MakeModel;
end;

destructor TTeapotShape.Destroy;
begin
     _Geometry.Free;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
