#include <sourcemod>
#include <dhooks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name 			= "Accuracy Nospread",
	author 			= "Haze",
	description 	= "",
	version 		= "1.0",
	url 			= "https://steamcommunity.com/id/0x134/"
};

ConVar gCV_AcurracyNoSpread = null;

public void OnPluginStart()
{
	gCV_AcurracyNoSpread = CreateConVar("sm_accuracy_nospread", "1", "", 0, true, 0.0, true, 1.0);
	
	Handle hGameData = LoadGameConfigFile("Nospread.games");
	if(!hGameData)
	{
		delete hGameData;
		SetFailState("Failed to load Nospread gamedata.");
	}

	Handle hFireBullets = DHookCreateDetour(Address_Null, CallConv_CDECL, ReturnType_Void, ThisPointer_Ignore); 
	DHookSetFromConf(hFireBullets, hGameData, SDKConf_Signature, "FX_FireBullets");
	DHookAddParam(hFireBullets, HookParamType_Int);
	DHookAddParam(hFireBullets, HookParamType_VectorPtr);
	DHookAddParam(hFireBullets, HookParamType_VectorPtr); 
	DHookAddParam(hFireBullets, HookParamType_Int);
	DHookAddParam(hFireBullets, HookParamType_Int);
	DHookAddParam(hFireBullets, HookParamType_Int);
	DHookAddParam(hFireBullets, HookParamType_Float);
	DHookAddParam(hFireBullets, HookParamType_Float);
	DHookAddParam(hFireBullets, HookParamType_Float);
	
	delete hGameData;

	if(!DHookEnableDetour(hFireBullets, false, DHook_FireBullets))
	{
		SetFailState("Couldn't enable FX_FireBullets detour.");
	}
}

public MRESReturn DHook_FireBullets(Handle hParams)
{

	if(gCV_AcurracyNoSpread.BoolValue)
	{
		DHookSetParam(hParams, 7, 0.0);
		return MRES_ChangedOverride;
	}
	
	return MRES_Ignored;
}