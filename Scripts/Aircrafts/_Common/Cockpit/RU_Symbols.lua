-- gettext marker override, to keep original key and allow to translation tool catch it
-- used  for "native" language avionics feature

local _ = function(str) return str end 

ru_symbols = {
[_("ETS")]    	= "ПРГ";  
[_("GNPD")]   	= "ППУ";  
[_("GUN")]    	= "ВПУ";  
[_("ALL")]    	= "ВСЕ";  
[_("DSP")]    	= "КМГ";  
[_("B")]      	= "Б";  
[_("ILV")]    	= "АВТ";  
[_("MED")]    	= "ЗПС";  
[_("HI")]     	= "ППС";  
[_("RL")]     	= "РЛ";  
[_("R")]      	= "Р";  
[_("ILL")]    	= "ИЗЛ";  
[_("EO")]     	= "ТП";  
[_("A")]      	= "А";  
[_("AFR")]    	= "АСВ";  
[_("LTV")]    	= "НТВ";  
[_("RF")]     	= "ДЗП";  
[_("NAV")]    	= "НАВ";  
[_("ENR")]    	= "МРШ";  
[_("RTN")]    	= "ВЗВ";  
[_("LNDG")]   	= "ПОС";  
[_("BVR")]    	= "ДВБ";  
[_("TWS")]    	= "СНП";  
[_("TWS2")]   	= "СНП2";
[_("SCN")]    	= "ОБЗ";  
[_("AWACS")]  	= "ДРЛО";  
[_("ATK")]    	= "АТК";  
[_("CAC")]    	= "БВБ";  
[_("GND")]    	= "ЗМЛ";  
[_("LNGT")]   	= "ФИ0";  
[_("HMT")]    	= "ШЛМ";  
[_("VS")]     	= "ВС";  
[_("OPT")]    	= "ОПТ";  
[_("TV")]     	= "ТВ";  
[_("L")]      	= "ЛД";  
[_("IP")]     	= "ОПТ";  
[_("AR")]     	= "АР";  
[_("AM")]     	= "АМ";  
[_("LA")]     	= "ПР";  
[_("NOLA")]   	= "ОТВ";  
[_("AC")]     	= "АС";  
[_("KC")]     	= "КС";  
[_("LR")]     	= "ИД";  
[_("DIRCM")]  	= "СОЭП";  
[_("ECM")]    	= "САП";  
[_("JAM")]    	= "АП";  
[_("S11")]      = "БУК";  
[_("SA6")]      = "КУБ";
[_("FLF")]      = "П19";--Flat Face B		
[_("SA8")]      = "ОСА";
[_("S15")]      = "ТОР";
[_("S19")]      = "2C6";
[_("SN9")]      = "КНЖ";
[_("SN6")]      = "ФРТ";
[_("S13")]	    = "С10";
[_("SA3")]	    = "125";
[_("BB")]	    = "300";
[_("FL")]	    = "30Н6";
[_("CS")]	    = "76Н6";
[_("T1")]       = "Ц1";
[_("T2")]       = "Ц2";
[_("DGE")]		= "9С80";
--[_('TLR')]		= "55Ж6";
}