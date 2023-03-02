local StrToNumber=tonumber;local Byte=string.byte;local Char=string.char;local Sub=string.sub;local Subg=string.gsub;local Rep=string.rep;local Concat=table.concat;local Insert=table.insert;local LDExp=math.ldexp;local GetFEnv=getfenv or function()return _ENV;end ;local Setmetatable=setmetatable;local PCall=pcall;local Select=select;local Unpack=unpack or table.unpack ;local ToNumber=tonumber;local function VMCall(ByteString,vmenv,...)local DIP=1;local repeatNext;ByteString=Subg(Sub(ByteString,5),"..",function(byte)if (Byte(byte,2)==79) then repeatNext=StrToNumber(Sub(byte,1,1));return "";else local a=Char(StrToNumber(byte,16));if repeatNext then local b=Rep(a,repeatNext);repeatNext=nil;return b;else return a;end end end);local function gBit(Bit,Start,End)if End then local Res=(Bit/(2^(Start-1)))%(2^(((End-1) -(Start-1)) + 1)) ;return Res-(Res%1) ;else local Plc=2^(Start-1) ;return (((Bit%(Plc + Plc))>=Plc) and 1) or 0 ;end end local function gBits8()local a=Byte(ByteString,DIP,DIP);DIP=DIP + 1 ;return a;end local function gBits16()local a,b=Byte(ByteString,DIP,DIP + 2 );DIP=DIP + 2 ;return (b * 256) + a ;end local function gBits32()local a,b,c,d=Byte(ByteString,DIP,DIP + 3 );DIP=DIP + 4 ;return (d * 16777216) + (c * 65536) + (b * 256) + a ;end local function gFloat()local Left=gBits32();local Right=gBits32();local IsNormal=1;local Mantissa=(gBit(Right,1,20) * (2^32)) + Left ;local Exponent=gBit(Right,21,31);local Sign=((gBit(Right,32)==1) and  -1) or 1 ;if (Exponent==0) then if (Mantissa==0) then return Sign * 0 ;else Exponent=1;IsNormal=0;end elseif (Exponent==2047) then return ((Mantissa==0) and (Sign * (1/0))) or (Sign * NaN) ;end return LDExp(Sign,Exponent-1023 ) * (IsNormal + (Mantissa/(2^52))) ;end local function gString(Len)local Str;if  not Len then Len=gBits32();if (Len==0) then return "";end end Str=Sub(ByteString,DIP,(DIP + Len) -1 );DIP=DIP + Len ;local FStr={};for Idx=1, #Str do FStr[Idx]=Char(Byte(Sub(Str,Idx,Idx)));end return Concat(FStr);end local gInt=gBits32;local function _R(...)return {...},Select("#",...);end local function Deserialize()local Instrs={};local Functions={};local Lines={};local Chunk={Instrs,Functions,nil,Lines};local ConstCount=gBits32();local Consts={};for Idx=1,ConstCount do local Type=gBits8();local Cons;if (Type==1) then Cons=gBits8()~=0 ;elseif (Type==2) then Cons=gFloat();elseif (Type==3) then Cons=gString();end Consts[Idx]=Cons;end Chunk[3]=gBits8();for Idx=1,gBits32() do local Descriptor=gBits8();if (gBit(Descriptor,1,1)==0) then local Type=gBit(Descriptor,2,3);local Mask=gBit(Descriptor,4,6);local Inst={gBits16(),gBits16(),nil,nil};if (Type==0) then Inst[3]=gBits16();Inst[4]=gBits16();elseif (Type==1) then Inst[3]=gBits32();elseif (Type==2) then Inst[3]=gBits32() -(2^16) ;elseif (Type==3) then Inst[3]=gBits32() -(2^16) ;Inst[4]=gBits16();end if (gBit(Mask,1,1)==1) then Inst[2]=Consts[Inst[2]];end if (gBit(Mask,2,2)==1) then Inst[3]=Consts[Inst[3]];end if (gBit(Mask,3,3)==1) then Inst[4]=Consts[Inst[4]];end Instrs[Idx]=Inst;end end for Idx=1,gBits32() do Functions[Idx-1 ]=Deserialize();end for Idx=1,gBits32() do Lines[Idx]=gBits32();end return Chunk;end local function Wrap(Chunk,Upvalues,Env)local Instr=Chunk[1];local Proto=Chunk[2];local Params=Chunk[3];return function(...)local VIP=1;local Top= -1;local Args={...};local PCount=Select("#",...) -1 ;local function Loop()local Instr=Instr;local Proto=Proto;local Params=Params;local _R=_R;local Vararg={};local Lupvals={};local Stk={};for Idx=0,PCount do if (Idx>=Params) then Vararg[Idx-Params ]=Args[Idx + 1 ];else Stk[Idx]=Args[Idx + 1 ];end end local Varargsz=(PCount-Params) + 1 ;local Inst;local Enum;while true do Inst=Instr[VIP];Enum=Inst[1];if (Enum<=10) then if (Enum<=4) then if (Enum<=1) then if (Enum>0) then VIP=Inst[3];else Stk[Inst[2]]=Upvalues[Inst[3]];end elseif (Enum<=2) then local A=Inst[2];Stk[A]=Stk[A]();elseif (Enum==3) then Stk[Inst[2]]();else Stk[Inst[2]][Inst[3]]=Stk[Inst[4]];end elseif (Enum<=7) then if (Enum<=5) then if (Stk[Inst[2]]==Inst[4]) then VIP=VIP + 1 ;else VIP=Inst[3];end elseif (Enum==6) then if Stk[Inst[2]] then VIP=VIP + 1 ;else VIP=Inst[3];end else Stk[Inst[2]]=Stk[Inst[3]];end elseif (Enum<=8) then local A=Inst[2];Stk[A]=Stk[A](Unpack(Stk,A + 1 ,Inst[3]));elseif (Enum==9) then local A=Inst[2];Stk[A]=Stk[A](Unpack(Stk,A + 1 ,Top));else local A=Inst[2];local B=Stk[Inst[3]];Stk[A + 1 ]=B;Stk[A]=B[Inst[4]];end elseif (Enum<=16) then if (Enum<=13) then if (Enum<=11) then local A=Inst[2];Stk[A](Unpack(Stk,A + 1 ,Inst[3]));elseif (Enum==12) then Stk[Inst[2]]=Stk[Inst[3]][Inst[4]];else Stk[Inst[2]]=Inst[3]~=0 ;end elseif (Enum<=14) then Upvalues[Inst[3]]=Stk[Inst[2]];elseif (Enum>15) then Stk[Inst[2]]=Wrap(Proto[Inst[3]],nil,Env);else local NewProto=Proto[Inst[3]];local NewUvals;local Indexes={};NewUvals=Setmetatable({},{__index=function(_,Key)local Val=Indexes[Key];return Val[1][Val[2]];end,__newindex=function(_,Key,Value)local Val=Indexes[Key];Val[1][Val[2]]=Value;end});for Idx=1,Inst[4] do VIP=VIP + 1 ;local Mvm=Instr[VIP];if (Mvm[1]==7) then Indexes[Idx-1 ]={Stk,Mvm[3]};else Indexes[Idx-1 ]={Upvalues,Mvm[3]};end Lupvals[ #Lupvals + 1 ]=Indexes;end Stk[Inst[2]]=Wrap(NewProto,NewUvals,Env);end elseif (Enum<=19) then if (Enum<=17) then Stk[Inst[2]]=Inst[3];elseif (Enum==18) then local A=Inst[2];Stk[A](Stk[A + 1 ]);else local A=Inst[2];local Results,Limit=_R(Stk[A](Unpack(Stk,A + 1 ,Inst[3])));Top=(Limit + A) -1 ;local Edx=0;for Idx=A,Top do Edx=Edx + 1 ;Stk[Idx]=Results[Edx];end end elseif (Enum<=20) then Env[Inst[3]]=Stk[Inst[2]];elseif (Enum>21) then do return;end else Stk[Inst[2]]=Env[Inst[3]];end VIP=VIP + 1 ;end end A,B=_R(PCall(Loop));if  not A[1] then local line=Chunk[4][VIP] or "?" ;error("Script error at ["   .. line   .. "]:"   .. A[2] );else return Unpack(A,2,B);end end;end return Wrap(Deserialize(),{},vmenv)(...);end VMCall("LOL!073O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O747047657403443O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F42696E696E74726F2O7A612F65763265767776772F6D61696E2F6D61696E2E6C756103063O0053637269707403073O00506C6163654964022O0090411289054200113O0012153O00013O001215000100023O00200A000100010003001211000300044O0013000100034O00095O00022O00023O0001000200060F00013O000100012O00077O001214000100053O001215000100023O00200C00010001000600260500010010000100070004013O00100001001215000100054O00030001000100012O00163O00013O00013O00363O0003093O004372656174654C696203193O005B31304D5D20476C6964652052616365205955544F2048554203073O0053657270656E7403063O004E657754616203043O004D61696E030A3O004E657753656374696F6E03093O004E657742752O746F6E03113O00696E6669206D6F6E657920284245746129030C3O004A5553542057414954203A2903093O004E6577546F2O676C6503123O005245442O454D2047494654204F4E4C494E4503043O0047494654030C3O004155544F205245424952544803123O004155544F20464F52204E494748542041464B03093O004E6577536C6964657203093O0057616C6B73702O6564031A3O004368616E67657320686F77206661737420796F752077616C6B2E025O00406F40026O00304003093O004A756D70506F776572031A3O004368616E67657320686F77206661737420796F75206A756D702E03083O0054454C45504F525403053O004D41502034030B3O00474F20544F204D4150203403053O004D41502033030B3O00474F20544F204D4150203303053O004D41502032030B3O00474F20544F204D4150203203053O004D41502031030B3O00474F20544F204D4150203103043O00452O677303063O0053656C65637403083O004E65774C6162656C030B3O005354617274657220652O6703173O005374617274657220652O672820316B3520636F696E202903173O005374617274657220652O67282031324B20636F696E202903173O005374617274657220652O67282039306B20636F696E202903073O0050726F20652O6703143O0050726F20652O6728203435304B20636F696E202903123O0050726F20652O672820334D20636F696E202903133O0050726F20652O67282031304D20636F696E202903093O004576656E7420652O6703093O0031324D20452O67732003093O004D6170203220652O6703143O004D6170203220652O67732O20282031354D20292003143O004D6170203220652O67732O20282033354D20292003093O004D6170203320652O6703143O004D6170203320652O67732O20282035304D20292003153O004D6170203320652O67732O202820312O304D20292003093O004D6170203420652O6703153O004D6170203420652O67732O202820322O304D20292003153O004D6170203320652O67732O202820342O304D20292003073O004372656469747303133O0043726561746564206279205955544F2048554200B39O003O00200C5O0001001211000100023O001211000200034O00083O0002000200200A00013O0004001211000300054O000800010003000200200A000200010006001211000400054O000800020004000200200A000300020007001211000500083O001211000600093O00021000076O000B00030007000100200A00030002000A0012110005000B3O0012110006000C3O000210000700014O000B00030007000100200A00030002000A0012110005000D3O0012110006000E3O000210000700024O000B00030007000100200A00030002000F001211000500103O001211000600113O001211000700123O001211000800133O000210000900034O000B00030009000100200A00030002000F001211000500143O001211000600153O001211000700123O001211000800133O000210000900044O000B00030009000100200A00033O0004001211000500164O000800030005000200200A000400030006001211000600164O000800040006000200200A000500040007001211000700173O001211000800183O000210000900054O000B00050009000100200A000500040007001211000700193O0012110008001A3O000210000900064O000B00050009000100200A0005000400070012110007001B3O0012110008001C3O000210000900074O000B00050009000100200A0005000400070012110007001D3O0012110008001E3O000210000900084O000B00050009000100200A00053O00040012110007001F4O000800050007000200200A000600050006001211000800204O00080006000800022O000D00075O00200A000800060021001211000A00224O000B0008000A000100200A00080006000A001211000A00233O001211000B001F3O00060F000C0009000100012O00073O00074O000B0008000C000100200A00080006000A001211000A00243O001211000B001F3O00060F000C000A000100012O00073O00074O000B0008000C000100200A00080006000A001211000A00253O001211000B001F3O00060F000C000B000100012O00073O00074O000B0008000C000100200A000800060021001211000A00264O000B0008000A000100200A00080006000A001211000A00273O001211000B001F3O00060F000C000C000100012O00073O00074O000B0008000C000100200A00080006000A001211000A00283O001211000B001F3O00060F000C000D000100012O00073O00074O000B0008000C000100200A00080006000A001211000A00293O001211000B001F3O00060F000C000E000100012O00073O00074O000B0008000C000100200A000800060021001211000A002A4O000B0008000A000100200A00080006000A001211000A002B3O001211000B001F3O00060F000C000F000100012O00073O00074O000B0008000C000100200A000800060021001211000A002C4O000B0008000A000100200A00080006000A001211000A002D3O001211000B001F3O00060F000C0010000100012O00073O00074O000B0008000C000100200A00080006000A001211000A002E3O001211000B001F3O00060F000C0011000100012O00073O00074O000B0008000C000100200A000800060021001211000A002F4O000B0008000A000100200A00080006000A001211000A00303O001211000B001F3O00060F000C0012000100012O00073O00074O000B0008000C000100200A00080006000A001211000A00313O001211000B001F3O00060F000C0013000100012O00073O00074O000B0008000C000100200A000800060021001211000A00324O000B0008000A000100200A00080006000A001211000A00333O001211000B001F3O00060F000C0014000100012O00073O00074O000B0008000C000100200A00080006000A001211000A00343O001211000B001F3O00060F000C0015000100012O00073O00074O000B0008000C000100200A00083O0004001211000A00354O00080008000A000200200A000900080006001211000B00354O00080009000B000200200A000A00090021001211000C00364O000B000A000C00012O00163O00013O00168O00014O00163O00017O00013O00073O000B3O0003113O004D61696E546F2O676C65456E61626C656403043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O005370696E030C3O005B432D535D5472795370696E030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01133O0012143O00014O000D00015O002O060001001200013O0004013O00120001001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O00120003000200010012150003000A3O0012110004000B4O00120003000200010004013O000200012O00163O00017O00133O00093O000A3O000B3O000B3O000C3O000C3O000C3O000C3O000C3O000C3O000C3O000C3O000D3O000D3O000E3O000E3O000E3O000E3O00103O000B3O0003113O004D61696E546F2O676C65456E61626C656403043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503053O004576656E7403073O005265626972746803123O005B432D535D54727942757952656269727468030A3O004669726553657276657203043O0077616974026O00F03F01133O0012143O00013O001215000100013O002O060001001200013O0004013O00120001001215000100023O00200A000100010003001211000300044O000800010003000200200C00010001000500200C00010001000600200C00010001000700200C00010001000800200A0002000100092O00120002000200010012150002000A3O0012110003000B4O00120002000200010004013O000100012O00163O00017O00133O00123O00133O00133O00133O00143O00143O00143O00143O00143O00143O00143O00143O00153O00153O00163O00163O00163O00163O00183O00063O0003043O0067616D6503073O00506C6179657273030B3O004C6F63616C506C6179657203093O0043686172616374657203083O0048756D616E6F696403093O0057616C6B53702O656401073O001215000100013O00200C00010001000200200C00010001000300200C00010001000400200C000100010005001004000100064O00163O00017O00073O001A3O001A3O001A3O001A3O001A3O001A3O001B3O00063O0003043O0067616D6503073O00506C6179657273030B3O004C6F63616C506C6179657203093O0043686172616374657203083O0048756D616E6F696403093O004A756D70506F77657201073O001215000100013O00200C00010001000200200C00010001000300200C00010001000400200C000100010005001004000100064O00163O00017O00073O001D3O001D3O001D3O001D3O001D3O001D3O001E3O000A3O0003043O0067616D6503073O00506C6179657273030B3O004C6F63616C506C6179657203093O0043686172616374657203103O0048756D616E6F6964522O6F745061727403063O00434672616D652O033O006E6577025O00A871C0025O00606440025O0096A240000D3O0012153O00013O00200C5O000200200C5O000300200C5O000400200C5O0005001215000100063O00200C000100010007001211000200083O001211000300093O0012110004000A4O00080001000400020010043O000600012O00163O00017O000D3O00223O00223O00223O00223O00223O00223O00223O00223O00223O00223O00223O00223O00233O000A3O0003043O0067616D6503073O00506C6179657273030B3O004C6F63616C506C6179657203093O0043686172616374657203103O0048756D616E6F6964522O6F745061727403063O00434672616D652O033O006E6577025O007069C0025O00606440025O00789A40000D3O0012153O00013O00200C5O000200200C5O000300200C5O000400200C5O0005001215000100063O00200C000100010007001211000200083O001211000300093O0012110004000A4O00080001000400020010043O000600012O00163O00017O000D3O00253O00253O00253O00253O00253O00253O00253O00253O00253O00253O00253O00253O00263O000A3O0003043O0067616D6503073O00506C6179657273030B3O004C6F63616C506C6179657203093O0043686172616374657203103O0048756D616E6F6964522O6F745061727403063O00434672616D652O033O006E6577025O00506AC0025O00806440025O00C88E40000D3O0012153O00013O00200C5O000200200C5O000300200C5O000400200C5O0005001215000100063O00200C000100010007001211000200083O001211000300093O0012110004000A4O00080001000400020010043O000600012O00163O00017O000D3O00283O00283O00283O00283O00283O00283O00283O00283O00283O00283O00283O00283O00293O000A3O0003043O0067616D6503073O00506C6179657273030B3O004C6F63616C506C6179657203093O0043686172616374657203103O0048756D616E6F6964522O6F745061727403063O00434672616D652O033O006E6577025O007061C0025O00606440026O0010C0000D3O0012153O00013O00200C5O000200200C5O000300200C5O000400200C5O0005001215000100063O00200C000100010007001211000200083O001211000300093O0012110004000A4O00080001000400020010043O000600012O00163O00017O000D3O002B3O002B3O002B3O002B3O002B3O002B3O002B3O002B3O002B3O002B3O002B3O002B3O002C3O000B3O0003083O00436F696E31352O3003043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O004C75636B030B3O005B432D535D446F4C75636B030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01154O000E9O0000015O002O060001001400013O0004013O00140001001211000100013O001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O0007000500014O000B0003000500010012150003000A3O0012110004000B4O00120003000200010004013O000100012O00163O00017O00153O00323O00333O00333O00333O00343O00353O00353O00353O00353O00353O00353O00353O00353O00363O00363O00363O00373O00373O00373O00373O00393O000B3O0003093O00436F696E31323O3003043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O004C75636B030B3O005B432D535D446F4C75636B030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01154O000E9O0000015O002O060001001400013O0004013O00140001001211000100013O001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O0007000500014O000B0003000500010012150003000A3O0012110004000B4O00120003000200010004013O000100012O00163O00017O00153O003B3O003C3O003C3O003C3O003D3O003E3O003E3O003E3O003E3O003E3O003E3O003E3O003E3O003F3O003F3O003F3O00403O00403O00403O00403O00423O000B3O0003093O00436F696E394O3003043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O004C75636B030B3O005B432D535D446F4C75636B030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01154O000E9O0000015O002O060001001400013O0004013O00140001001211000100013O001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O0007000500014O000B0003000500010012150003000A3O0012110004000B4O00120003000200010004013O000100012O00163O00017O00153O00443O00453O00453O00453O00463O00473O00473O00473O00473O00473O00473O00473O00473O00483O00483O00483O00493O00493O00493O00493O004B3O000B3O00030A3O00436F696E34354O3003043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O004C75636B030B3O005B432D535D446F4C75636B030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01154O000E9O0000015O002O060001001400013O0004013O00140001001211000100013O001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O0007000500014O000B0003000500010012150003000A3O0012110004000B4O00120003000200010004013O000100012O00163O00017O00153O004E3O004F3O004F3O004F3O00503O00513O00513O00513O00513O00513O00513O00513O00513O00523O00523O00523O00533O00533O00533O00533O00553O000B3O0003063O00436F696E334D03043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O004C75636B030B3O005B432D535D446F4C75636B030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01154O000E9O0000015O002O060001001400013O0004013O00140001001211000100013O001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O0007000500014O000B0003000500010012150003000A3O0012110004000B4O00120003000200010004013O000100012O00163O00017O00153O00573O00583O00583O00583O00593O005A3O005A3O005A3O005A3O005A3O005A3O005A3O005A3O005B3O005B3O005B3O005C3O005C3O005C3O005C3O005E3O000B3O0003073O00436F696E31304D03043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O004C75636B030B3O005B432D535D446F4C75636B030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01154O000E9O0000015O002O060001001400013O0004013O00140001001211000100013O001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O0007000500014O000B0003000500010012150003000A3O0012110004000B4O00120003000200010004013O000100012O00163O00017O00153O00603O00613O00613O00613O00623O00633O00633O00633O00633O00633O00633O00633O00633O00643O00643O00643O00653O00653O00653O00653O00673O000B3O0003073O00436F696E31324D03043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O004C75636B030B3O005B432D535D446F4C75636B030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01154O000E9O0000015O002O060001001400013O0004013O00140001001211000100013O001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O0007000500014O000B0003000500010012150003000A3O0012110004000B4O00120003000200010004013O000100012O00163O00017O00153O006A3O006B3O006B3O006B3O006C3O006D3O006D3O006D3O006D3O006D3O006D3O006D3O006D3O006E3O006E3O006E3O006F3O006F3O006F3O006F3O00713O000B3O0003073O00436F696E31354D03043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O004C75636B030B3O005B432D535D446F4C75636B030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01154O000E9O0000015O002O060001001400013O0004013O00140001001211000100013O001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O0007000500014O000B0003000500010012150003000A3O0012110004000B4O00120003000200010004013O000100012O00163O00017O00153O00743O00753O00753O00753O00763O00773O00773O00773O00773O00773O00773O00773O00773O00783O00783O00783O00793O00793O00793O00793O007B3O000B3O0003073O00436F696E33354D03043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O004C75636B030B3O005B432D535D446F4C75636B030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01154O000E9O0000015O002O060001001400013O0004013O00140001001211000100013O001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O0007000500014O000B0003000500010012150003000A3O0012110004000B4O00120003000200010004013O000100012O00163O00017O00153O007D3O007E3O007E3O007E3O007F3O00803O00803O00803O00803O00803O00803O00803O00803O00813O00813O00813O00823O00823O00823O00823O00843O000B3O0003073O00436F696E35304D03043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O004C75636B030B3O005B432D535D446F4C75636B030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01154O000E9O0000015O002O060001001400013O0004013O00140001001211000100013O001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O0007000500014O000B0003000500010012150003000A3O0012110004000B4O00120003000200010004013O000100012O00163O00017O00153O00873O00883O00883O00883O00893O008A3O008A3O008A3O008A3O008A3O008A3O008A3O008A3O008B3O008B3O008B3O008C3O008C3O008C3O008C3O008E3O000B3O0003083O00436F696E312O304D03043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O004C75636B030B3O005B432D535D446F4C75636B030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01154O000E9O0000015O002O060001001400013O0004013O00140001001211000100013O001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O0007000500014O000B0003000500010012150003000A3O0012110004000B4O00120003000200010004013O000100012O00163O00017O00153O00903O00913O00913O00913O00923O00933O00933O00933O00933O00933O00933O00933O00933O00943O00943O00943O00953O00953O00953O00953O00973O000B3O0003083O00436F696E322O304D03043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O004C75636B030B3O005B432D535D446F4C75636B030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01154O000E9O0000015O002O060001001400013O0004013O00140001001211000100013O001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O0007000500014O000B0003000500010012150003000A3O0012110004000B4O00120003000200010004013O000100012O00163O00017O00153O009A3O009B3O009B3O009B3O009C3O009D3O009D3O009D3O009D3O009D3O009D3O009D3O009D3O009E3O009E3O009E3O009F3O009F3O009F3O009F3O00A13O000B3O0003083O00436F696E342O304D03043O0067616D65030A3O004765745365727669636503113O005265706C69636174656453746F7261676503063O0052656D6F746503083O0046756E6374696F6E03043O004C75636B030B3O005B432D535D446F4C75636B030C3O00496E766F6B6553657276657203043O0077616974026O00F03F01154O000E9O0000015O002O060001001400013O0004013O00140001001211000100013O001215000200023O00200A000200020003001211000400044O000800020004000200200C00020002000500200C00020002000600200C00020002000700200C00020002000800200A0003000200092O0007000500014O000B0003000500010012150003000A3O0012110004000B4O00120003000200010004013O000100012O00163O00017O00153O00A33O00A43O00A43O00A43O00A53O00A63O00A63O00A63O00A63O00A63O00A63O00A63O00A63O00A73O00A73O00A73O00A83O00A83O00A83O00A83O00AA3O00B33O00033O00033O00033O00033O00033O00043O00043O00043O00053O00053O00053O00063O00063O00063O00073O00063O00083O00083O00083O00103O00083O00113O00113O00113O00183O00113O00193O00193O00193O00193O00193O001B3O00193O001C3O001C3O001C3O001C3O001C3O001E3O001C3O001F3O001F3O001F3O00203O00203O00203O00213O00213O00213O00233O00213O00243O00243O00243O00263O00243O00273O00273O00273O00293O00273O002A3O002A3O002A3O002C3O002A3O002D3O002D3O002D3O002E3O002E3O002E3O002F3O00303O00303O00303O00313O00313O00313O00393O00393O00313O003A3O003A3O003A3O00423O00423O003A3O00433O00433O00433O004B3O004B3O00433O004C3O004C3O004C3O004D3O004D3O004D3O00553O00553O004D3O00563O00563O00563O005E3O005E3O00563O005F3O005F3O005F3O00673O00673O005F3O00683O00683O00683O00693O00693O00693O00713O00713O00693O00723O00723O00723O00733O00733O00733O007B3O007B3O00733O007C3O007C3O007C3O00843O00843O007C3O00853O00853O00853O00863O00863O00863O008E3O008E3O00863O008F3O008F3O008F3O00973O00973O008F3O00983O00983O00983O00993O00993O00993O00A13O00A13O00993O00A23O00A23O00A23O00AA3O00AA3O00A23O00AB3O00AB3O00AB3O00AC3O00AC3O00AC3O00AD3O00AD3O00AD3O00AE3O00113O00013O00013O00013O00013O00013O00013O00013O00AE3O00AE3O00AE3O00AF3O00AF3O00AF3O00AF3O00B03O00B03O00B13O00",GetFEnv(),...);
